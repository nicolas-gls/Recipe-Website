#!/usr/bin/env bash

set -euo pipefail

: "${AZ_RESOURCE_GROUP:?AZ_RESOURCE_GROUP is required}"
: "${AZ_SQL_SERVER:?AZ_SQL_SERVER is required}"
: "${AZ_CATALOG_DATABASE:?AZ_CATALOG_DATABASE is required}"
: "${AZ_SHOPPING_DATABASE:?AZ_SHOPPING_DATABASE is required}"
: "${AZ_CATALOG_APP:?AZ_CATALOG_APP is required}"
: "${AZ_SHOPPING_APP:?AZ_SHOPPING_APP is required}"
: "${UI_ORIGIN:?UI_ORIGIN is required}"

SQL_SERVER_NAME="${AZ_SQL_SERVER%%.*}"
UI_ORIGIN="${UI_ORIGIN%/}"

require_command() {
    command -v "$1" >/dev/null 2>&1 || {
        echo "Required command not found: $1" >&2
        exit 1
    }
}

require_command az
require_command curl

app_fqdn() {
    az containerapp show \
        --name "$1" \
        --resource-group "$AZ_RESOURCE_GROUP" \
        --query properties.configuration.ingress.fqdn \
        --output tsv
}

verify_app_configuration() {
    local app_name="$1"
    local fqdn external target_port min_replicas max_replicas

    fqdn="$(app_fqdn "$app_name")"
    external="$(az containerapp show --name "$app_name" --resource-group "$AZ_RESOURCE_GROUP" --query properties.configuration.ingress.external --output tsv)"
    target_port="$(az containerapp show --name "$app_name" --resource-group "$AZ_RESOURCE_GROUP" --query properties.configuration.ingress.targetPort --output tsv)"
    min_replicas="$(az containerapp show --name "$app_name" --resource-group "$AZ_RESOURCE_GROUP" --query properties.template.scale.minReplicas --output tsv)"
    max_replicas="$(az containerapp show --name "$app_name" --resource-group "$AZ_RESOURCE_GROUP" --query properties.template.scale.maxReplicas --output tsv)"

    [[ -n "$fqdn" ]] || { echo "$app_name has no public FQDN" >&2; exit 1; }
    [[ "$external" == "true" ]] || { echo "$app_name ingress is not external" >&2; exit 1; }
    [[ "$target_port" == "8000" ]] || { echo "$app_name targets port $target_port, expected 8000" >&2; exit 1; }
    [[ "$min_replicas" == "0" ]] || { echo "$app_name min replicas is $min_replicas, expected 0" >&2; exit 1; }
    [[ "$max_replicas" == "1" ]] || { echo "$app_name max replicas is $max_replicas, expected 1" >&2; exit 1; }

    printf '%s configuration: fqdn=%s external=%s targetPort=%s minReplicas=%s maxReplicas=%s\n' \
        "$app_name" "$fqdn" "$external" "$target_port" "$min_replicas" "$max_replicas"
}

verify_health() {
    local app_name="$1"
    local fqdn status

    fqdn="$(app_fqdn "$app_name")"
    status="$(curl --silent --show-error --retry 18 --retry-delay 10 --retry-all-errors \
        --output /dev/null --write-out '%{http_code}' "https://$fqdn/health")"
    [[ "$status" == "200" ]] || { echo "$app_name /health returned HTTP $status" >&2; exit 1; }
    printf '%s /health: HTTP %s\n' "$app_name" "$status"
}

verify_cors() {
    local app_name="$1"
    local method="$2"
    local path="$3"
    local fqdn headers

    fqdn="$(app_fqdn "$app_name")"
    headers="$(curl --silent --show-error --dump-header - --output /dev/null \
        --request OPTIONS "https://$fqdn$path" \
        --header "Origin: $UI_ORIGIN" \
        --header "Access-Control-Request-Method: $method" \
        --header "Access-Control-Request-Headers: content-type")"

    grep -Fqi "access-control-allow-origin: $UI_ORIGIN" <<<"$headers" || {
        echo "$app_name did not allow the configured UI origin" >&2
        exit 1
    }
    printf '%s CORS preflight: allowed origin %s\n' "$app_name" "$UI_ORIGIN"
}

verify_sql_database() {
    local database="$1"
    local sku_tier sku_name sku_family capacity
    local min_capacity auto_pause_delay max_size_bytes status

    sku_tier="$(az sql db show \
        --resource-group "$AZ_RESOURCE_GROUP" \
        --server "$SQL_SERVER_NAME" \
        --name "$database" \
        --query sku.tier \
        --output tsv)"

    sku_name="$(az sql db show \
        --resource-group "$AZ_RESOURCE_GROUP" \
        --server "$SQL_SERVER_NAME" \
        --name "$database" \
        --query sku.name \
        --output tsv)"

    sku_family="$(az sql db show \
        --resource-group "$AZ_RESOURCE_GROUP" \
        --server "$SQL_SERVER_NAME" \
        --name "$database" \
        --query sku.family \
        --output tsv)"

    capacity="$(az sql db show \
        --resource-group "$AZ_RESOURCE_GROUP" \
        --server "$SQL_SERVER_NAME" \
        --name "$database" \
        --query sku.capacity \
        --output tsv)"

    min_capacity="$(az sql db show \
        --resource-group "$AZ_RESOURCE_GROUP" \
        --server "$SQL_SERVER_NAME" \
        --name "$database" \
        --query minCapacity \
        --output tsv)"

    auto_pause_delay="$(az sql db show \
        --resource-group "$AZ_RESOURCE_GROUP" \
        --server "$SQL_SERVER_NAME" \
        --name "$database" \
        --query autoPauseDelay \
        --output tsv)"

    max_size_bytes="$(az sql db show \
        --resource-group "$AZ_RESOURCE_GROUP" \
        --server "$SQL_SERVER_NAME" \
        --name "$database" \
        --query maxSizeBytes \
        --output tsv)"

    status="$(az sql db show \
        --resource-group "$AZ_RESOURCE_GROUP" \
        --server "$SQL_SERVER_NAME" \
        --name "$database" \
        --query status \
        --output tsv)"

    [[ "$sku_tier" == "GeneralPurpose" ]] || {
        echo "$database tier is $sku_tier, expected GeneralPurpose" >&2
        exit 1
    }

    [[ "$sku_name" == "GP_S_Gen5_1" ]] || {
        echo "$database SKU is $sku_name, expected GP_S_Gen5_1" >&2
        exit 1
    }

    [[ "$sku_family" == "Gen5" ]] || {
        echo "$database family is $sku_family, expected Gen5" >&2
        exit 1
    }

    [[ "$capacity" == "1" ]] || {
        echo "$database capacity is $capacity, expected 1" >&2
        exit 1
    }

    [[ "$min_capacity" == "0.5" ]] || {
        echo "$database minimum capacity is $min_capacity, expected 0.5" >&2
        exit 1
    }

    [[ "$auto_pause_delay" == "60" ]] || {
        echo "$database auto-pause delay is $auto_pause_delay, expected 60" >&2
        exit 1
    }

    [[ "$max_size_bytes" == "34359738368" ]] || {
        echo "$database maximum size is $max_size_bytes, expected 32 GB" >&2
        exit 1
    }

    [[ -n "$status" ]] || {
        echo "$database returned no status" >&2
        exit 1
    }

    printf '%s SQL configuration: tier=%s sku=%s family=%s capacity=%s minCapacity=%s autoPauseDelay=%s maxSizeBytes=%s status=%s\n' \
        "$database" \
        "$sku_tier" \
        "$sku_name" \
        "$sku_family" \
        "$capacity" \
        "$min_capacity" \
        "$auto_pause_delay" \
        "$max_size_bytes" \
        "$status"
}

verify_app_configuration "$AZ_CATALOG_APP"
verify_app_configuration "$AZ_SHOPPING_APP"
verify_health "$AZ_CATALOG_APP"
verify_health "$AZ_SHOPPING_APP"
verify_cors "$AZ_CATALOG_APP" GET /recipes
verify_cors "$AZ_SHOPPING_APP" POST /shopping-list
verify_sql_database "$AZ_CATALOG_DATABASE"
verify_sql_database "$AZ_SHOPPING_DATABASE"

echo "Azure deployment verification passed."
