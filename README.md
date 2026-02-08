# GA4 Product Analytics Platform

End-to-end analytics proof-of-concept that ingests GA4-style event data into Postgres, models engagement + retention KPIs with dbt, validates data quality, runs experimentation analysis in Python (NumPy/SciPy/Statsmodels), and delivers self-serve dashboards in Metabase. Includes an Amplitude/Heap-style event export artifact.

---

## What this project shows

- **Ingestion:** GA4 CSV → Postgres `raw` layer
- **Transformations:** dbt staging + marts for KPIs (DAU, cohort retention)
- **Data Quality:** dbt tests (not_null/accepted values where applicable)
- **Experimentation:** A/B test evaluation with proxy conversions using Python + Statsmodels/SciPy
- **Dashboards:** Metabase dashboard cards for DAU + cohorts + event volume
- **Product Analytics Export:** Event stream exported in **Amplitude/Heap-like** format

---

## Architecture

```text
GA4 CSV (Kaggle)
  ↓
Postgres (raw schema)
  ↓
dbt models (staging → marts)
  ↓
Metabase dashboards + Python notebook outputs + exports

ga4-product-analytics-platform/
├── docker-compose.yml
├── data/
│   ├── ga4_raw.csv                          (original download, optional)
│   └── ga4_events_skinny.csv                (cleaned/skinny file used for loading)
├── ga4_analytics_dbt/
│   ├── dbt_project.yml
│   ├── models/
│   │   ├── staging/
│   │   │   └── stg_ga4_events.sql
│   │   └── marts/
│   │       ├── daily_active_users.sql
│   │       └── cohort_retentin.sql          (note: name reflects current model file)
│   └── profiles.yml                         (local dev profile OR use ~/.dbt/profiles.yml)
├── notebooks/
│   └── 03_ga4_experimentation_and_churn_modeling.ipynb
├── scripts/
│   └── export_amplitude_heap_format.py
├── outputs/
│   ├── events_product_analytics.csv
│   └── amplitude_heap_events.csv
└── screenshots/
    └── metabase/
        ├── dashboard_overview.png
        ├── dau_trend.png
        └── cohort_retention.png

** Data **

Source: GA4 obfuscated ecommerce sample (CSV from Kaggle)

Example events present in this sample:

page_view, scroll, session_start, view_promotion, user_engagement, first_visit, view_item

**Key outputs **
**dbt models**

analytics.stg_ga4_events — cleaned/standardized event stream

analytics.daily_active_users — DAU trend by date

analytics.cohort_retentin — cohort retention by day number (model name reflects current file)

Exports

outputs/events_product_analytics.csv — event stream export used for notebook + tooling

outputs/amplitude_heap_events.csv — Amplitude/Heap-style standardized event export

Notebook

notebooks/03_ga4_experimentation_and_churn_modeling.ipynb

A/B evaluation using Statsmodels/SciPy (z-test + Fisher exact)

Data manipulation using NumPy/Pandas

(Optional) churn/retention feature engineering + modeling if enabled

Tech stack

Warehouse: Postgres 15 (Docker)

Transform: dbt (dbt-postgres)

Dashboards: Metabase (Docker)

Analysis: Python, NumPy, Pandas, SciPy, Statsmodels (+ optional scikit-learn/XGBoost)

Dev: Docker Compose, Git, VS Code

** Screenshots **
screenshots/metabase/screenshot1.png
screenshots/metabase/screenshot2.png

