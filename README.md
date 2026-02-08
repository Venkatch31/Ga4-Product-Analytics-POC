# GA4 Product Analytics Platform (Postgres + dbt + Metabase + Python)

End-to-end product analytics project using GA4-style event data to compute engagement, retention, funnels, and lightweight experimentation. Data is loaded into Postgres, modeled with dbt, visualized in Metabase, and analyzed in Python (NumPy/Pandas + SciPy/Statsmodels). Includes an Amplitude/Heap-style event export to demonstrate compatibility with common product analytics tools.

---

## What this project does

**Goal:** Build a small but complete product analytics “platform” locally that supports:
- Daily Active Users (DAU), engagement trends
- Cohort retention (by cohort date + day number)
- Funnel metrics (example: session_start → page_view → view_item)
- Experiment evaluation (A/B style split + significance tests)
- Export to Amplitude/Heap-like event format

---

## Architecture

1) **Raw ingestion**
- GA4 CSV → Postgres schema `raw`

2) **Modeling (dbt)**
- `stg_ga4_events` (staging: cleaned standardized events)
- `daily_active_users` (mart: DAU by date)
- `cohort_retention` (mart: retention matrix)

3) **BI (Metabase)**
- Dashboard over dbt models (DAU trend, retention table, event distribution)

4) **Python analytics**
- Notebook: funnel + A/B testing using NumPy/Pandas + SciPy/Statsmodels  
- Optional ML hooks (scikit-learn / XGBoost) for churn-style classification

---

## Repository structure

```text
ga4-product-analytics-platform/
├── docker-compose.yml
├── README.md
├── data/
│   ├── ga4_raw.csv
│   └── ga4_events_skinny.csv
├── ga4_analytics_dbt/
│   ├── dbt_project.yml
│   ├── models/
│   │   ├── staging/
│   │   └── marts/
│   └── profiles.yml.example
├── notebooks/
│   └── 03_ga4_experimentation_and_churn_modeling.ipynb
├── outputs/
│   ├── events_product_analytics.csv
│   └── amplitude_heap_events.csv
├── dashboards/
│   └── metabase_dashboard_notes.md
├── screenshots/
│   └── metabase/
├── scripts/
│   ├── 01_make_skinny_csv.py
│   ├── 02_load_to_postgres.sql
│   └── 03_export_amplitude_heap.sql
└── reports/
    └── findings.md
```

### Dataset

Source: GA4 obfuscated sample ecommerce events (CSV)

Notes: The raw file contains many columns; this project creates a “skinny” event table with the fields required for product analytics.

Skinny event columns
user_id, event_date, event_timestamp, event_name
country, device_category, source, medium
transaction_id, purchase_revenue_usd

### Key outputs
1. dbt models
- analytics.stg_ga4_events — cleaned/standardized event stream
- analytics.daily_active_users — DAU trend by date
- analytics.cohort_retention — cohort retention by day number 

2. Exports
- outputs/events_product_analytics.csv — event stream export used for notebook + tooling
- outputs/amplitude_heap_events.csv — Amplitude/Heap-style standardized event export

3. Notebook
- notebooks/03_ga4_experimentation_and_churn_modeling.ipynb
- A/B evaluation using Statsmodels/SciPy (z-test + Fisher exact)
- Data manipulation using NumPy/Pandas

### Tech stack
- Warehouse: Postgres 15 (Docker)
- Transform: dbt (dbt-postgres)
- Dashboards: Metabase (Docker)
- Analysis: Python, NumPy, Pandas, SciPy, Statsmodels (+ optional scikit-learn/XGBoost)
- Dev: Docker Compose, Git, VS Code

### Screenshots

![Screenshot](../metabase/screenshot1.png)   
![Screenshot](../metabase/screenshot2.png)   

