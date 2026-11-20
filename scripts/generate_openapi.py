"""Generate the committed OpenAPI document for one service."""

from __future__ import annotations

import argparse
from pathlib import Path

import yaml


ROOT = Path(__file__).resolve().parents[1]


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("service", choices=("catalog", "shopping"))
    args = parser.parse_args()

    # PYTHONPATH points at the selected service, so each application keeps its
    # own independent `app` package namespace.
    from app.main import app  # pylint: disable=import-outside-toplevel

    output_path = ROOT / "services" / args.service / "openapi.yaml"
    output_path.write_text(
        yaml.safe_dump(app.openapi(), sort_keys=False, allow_unicode=True),
        encoding="utf-8",
    )
    print(f"Generated {output_path}")


if __name__ == "__main__":
    main()
