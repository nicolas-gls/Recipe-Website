"""Validate the Assignment 2 machine-readable system documents."""

from __future__ import annotations

import json
from pathlib import Path

import yaml
from jsonschema import Draft202012Validator
from openapi_spec_validator import validate_spec


ROOT = Path(__file__).resolve().parents[1]


def load_yaml(path: Path) -> dict:
    with path.open(encoding="utf-8") as stream:
        value = yaml.safe_load(stream)
    if not isinstance(value, dict):
        raise ValueError(f"{path} must contain a YAML object")
    return value


def main() -> None:
    schema = json.loads((ROOT / "system.schema.json").read_text(encoding="utf-8"))
    system = load_yaml(ROOT / "system.yaml")
    errors = sorted(Draft202012Validator(schema).iter_errors(system), key=str)
    if errors:
        for error in errors:
            print(error.message)
        raise SystemExit("system.yaml does not conform to system.schema.json")

    for service in ("catalog", "shopping"):
        validate_spec(load_yaml(ROOT / "services" / service / "openapi.yaml"))

    print("system.yaml and both OpenAPI documents are valid")


if __name__ == "__main__":
    main()
