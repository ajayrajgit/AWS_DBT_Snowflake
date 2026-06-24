# AWS S3 → Snowflake → dbt Analytics Pipeline

An end-to-end data engineering pipeline that ingests raw Airbnb data from **AWS S3** into **Snowflake** via secure storage integrations, then transforms it through a multi-layered **dbt** architecture into analytics-ready tables.

---

## Overview

This project demonstrates a production-style data pipeline covering secure cloud storage integration, layered data modeling, reusable transformation logic, and historical change tracking — all built on the modern Snowflake + dbt stack.

---

## AWS S3 & Snowflake Storage Integration

Rather than passing static IAM credentials, the pipeline uses a **Snowflake Storage Integration** backed by an AWS IAM Role trust relationship. This allows Snowflake to securely read from the S3 bucket without exposing long-lived access keys.

**How it works:**
- An IAM Role is created in AWS with read-only access scoped to the relevant S3 bucket.
- A trust policy on that role grants Snowflake's own AWS IAM user permission to assume it, gated by a unique external ID for added security.
- On the Snowflake side, a storage integration object is created and described to retrieve the IAM user ARN and external ID needed to complete the AWS trust configuration.
- File formats, external stages, and raw staging tables are then set up under the `AIRBNB_RAW` database and `AIRBNB_BRONZE` schema, and raw data is copied into staging tables ready for transformation.

---

## dbt Transformation Architecture

Data flows through three structured modeling layers, each with a distinct purpose and materialization strategy.

### Bronze Layer — Staging
A pass-through extraction layer from the raw Snowflake staging tables, materialized as tables in the `bronze` schema. Incremental loading is applied so each run only processes new records based on a `created_at` timestamp watermark, rather than reprocessing the full dataset.

**Models:** `bronze_bookings`, `bronze_listings`, `bronze_hosts`

### Silver Layer — Conformed & Cleansed
Standardizes and enriches the bronze data, materialized as tables in the `silver` schema. This layer applies:
- Text trimming and formatting via custom macros
- Booking revenue calculations using shared multiplication logic
- Tier classifications (e.g., host response rate level, listing price level)

**Models:** `silver_bookings`, `silver_listings`, `silver_hosts`

### Gold Layer — Reporting, Ephemeral & One Big Table
The final, analytics-facing layer, materialized under the `gold` schema.
- **One Big Table (OBT):** A flat, denormalized table joining bookings, listings, and hosts. Join logic is generated dynamically from a configuration list rather than hand-written for each relationship, making the model easier to extend.
- **Fact Airbnb:** The primary fact table for reporting, built on top of the OBT.
- **Ephemeral models** (`bookings`, `listings`, `hosts`): Lightweight, non-materialized models that exist only to feed clean, well-bounded inputs into the snapshot layer.

---

## Reusable Jinja Macros

A small set of shared macros, found in `macros/`, keeps transformation logic consistent across models:

| Macro | Purpose |
|---|---|
| `trimmer` | Trims whitespace and standardizes text to uppercase |
| `tag` | Buckets a value into `low`, `medium`, or `high` based on thresholds |
| `multiply` | Multiplies two values and rounds to a specified precision |
| `generate_schema_name` | Resolves clean custom schema names (e.g., `bronze` instead of `dbt_schema_bronze`) |

---

## Slowly Changing Dimensions (dbt Snapshots)

Historical changes to key dimensions are tracked using **SCD Type 2** snapshots, configured in the `snapshots/` directory:

- **Strategy:** Timestamp-based change detection
- **Tracked dimensions:** `dim_bookings`, `dim_hosts`, `dim_listings`
- **Validity tracking:** Currently active records are marked with an open-ended valid-to date, making it easy to query the state of any dimension at any point in time

---

## Getting Started

### Prerequisites
- Python 3.12+
- `uv` (recommended) or `pip` for dependency management

### Setup
1. Install dependencies using `uv sync`, or `pip install -r pyproject.toml`.
2. Configure your Snowflake connection details — account, database, schema, credentials, role, and warehouse — in `profiles.yml`.
3. From the `aws_dbt_snowflake_project` folder, verify your connection with `dbt debug`.

### Running the Pipeline
Once connected, the typical workflow is:
1. Run all models across the Bronze, Silver, and Gold layers.
2. Run snapshots to capture SCD Type 2 history.
3. Run tests to validate schema and data integrity.
4. Generate and serve dbt documentation to explore the project interactively.

---

## Project Structure

- `models/bronze/` — Staging models
- `models/silver/` — Cleansed and conformed models
- `models/gold/` — Reporting models, including the OBT, fact table, and ephemeral models
- `macros/` — Shared transformation logic
- `snapshots/` — SCD Type 2 dimension tracking
- `profiles.yml` — Local connection configuration
- `dbt_project.yml` — Project and schema configuration