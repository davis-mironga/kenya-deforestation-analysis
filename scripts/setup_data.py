"""
setup_data.py
Kenya Deforestation Analysis — Data Setup & Validation
Author: Davis Mironga

Run this script before any analysis to verify all required data files
are present and have the expected columns.

Usage:
    python scripts/setup_data.py

The script will print a checklist and raise clear errors for missing files.
"""

import os
import sys
import csv
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
RAW = ROOT / "data" / "raw"

REQUIRED_FILES = {
    "gfw_tree_cover_loss.csv": {
        "source": "https://www.globalforestwatch.org/dashboards/country/KEN/",
        "instructions": (
            "Go to GFW > Kenya > Subnational > Download > Tree cover loss by year. "
            "Select 'County' level, years 2001-2024, download as CSV."
        ),
        "required_columns": ["country", "subnational_1", "year", "tree_cover_loss_ha", "co2_emissions_mt"],
    },
    "gfw_loss_by_driver.csv": {
        "source": "https://www.globalforestwatch.org/dashboards/country/KEN/",
        "instructions": (
            "Go to GFW > Kenya > Subnational > Download > Tree cover loss by dominant driver. "
            "Select 'County' level, download as CSV."
        ),
        "required_columns": ["country", "subnational_1", "year", "driver", "tree_cover_loss_ha"],
    },
    "faostat_land_use.csv": {
        "source": "https://www.fao.org/faostat/en/#data/RL",
        "instructions": (
            "Go to FAOSTAT > Inputs > Land Use. "
            "Filter: Country=Kenya, Items=Forest land, Years=1990-2022. Download as CSV."
        ),
        "required_columns": ["area", "item", "element", "year", "value", "unit"],
    },
    "fao_fra.csv": {
        "source": "https://fra-data.fao.org/KE/fra2020/",
        "instructions": (
            "Go to FAO FRA 2020 > Kenya > Forest area. "
            "Export the table covering 1990, 2000, 2010, 2015, 2020 as CSV."
        ),
        "required_columns": ["country", "year", "forest_area_ha", "natural_forest_ha", "planted_forest_ha", "carbon_stock_mt"],
    },
    "worldbank_indicators.csv": {
        "source": "https://data.worldbank.org/country/kenya",
        "instructions": (
            "Download from World Bank DataBank. Required indicators:\n"
            "  SI.POV.NAHC  — Poverty headcount ratio at national poverty lines\n"
            "  SP.RUR.TOTL.ZS — Rural population (% of total)\n"
            "  AG.LND.FRST.ZS — Forest area (% of land area)\n"
            "Filter: Country=Kenya, Years=2001-2022."
        ),
        "required_columns": ["country", "indicator_code", "indicator_name", "year", "value"],
    },
}


def check_file(filename, spec):
    filepath = RAW / filename
    status = {"file": filename, "exists": False, "columns_ok": False, "row_count": 0, "issues": []}

    if not filepath.exists():
        status["issues"].append(f"File not found: {filepath}")
        return status

    status["exists"] = True

    try:
        with open(filepath, newline="", encoding="utf-8") as f:
            reader = csv.DictReader(f)
            headers = reader.fieldnames or []
            rows = list(reader)
            status["row_count"] = len(rows)

        missing = [c for c in spec["required_columns"] if c not in headers]
        if missing:
            status["issues"].append(f"Missing columns: {missing}")
        else:
            status["columns_ok"] = True

        if status["row_count"] == 0:
            status["issues"].append("File is empty (0 data rows)")

    except Exception as e:
        status["issues"].append(f"Could not read file: {e}")

    return status


def main():
    print("\n" + "=" * 60)
    print("Kenya Deforestation Analysis — Data Setup Check")
    print("=" * 60)

    RAW.mkdir(parents=True, exist_ok=True)

    all_ok = True
    results = []

    for filename, spec in REQUIRED_FILES.items():
        status = check_file(filename, spec)
        results.append((filename, spec, status))

    for filename, spec, status in results:
        ok = status["exists"] and status["columns_ok"] and status["row_count"] > 0
        icon = "✓" if ok else "✗"
        print(f"\n  {icon}  {filename}")

        if ok:
            print(f"      {status['row_count']} rows, columns verified")
        else:
            all_ok = False
            for issue in status["issues"]:
                print(f"      ISSUE: {issue}")
            print(f"      Source:  {spec['source']}")
            print(f"      How to get it:")
            for line in spec["instructions"].splitlines():
                print(f"        {line}")

    print("\n" + "=" * 60)
    if all_ok:
        print("All data files present and valid. Ready to run analysis.")
    else:
        print("Some files are missing or invalid. See details above.")
        print("Place all CSV files in:  data/raw/")
        sys.exit(1)

    print("=" * 60 + "\n")


if __name__ == "__main__":
    main()
