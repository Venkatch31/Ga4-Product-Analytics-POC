import glob
import pandas as pd

# 1) Find your raw CSV (Kaggle GA4 export)
raw_files = glob.glob("data/*raw*.csv") or glob.glob("data/*.csv")
raw_path = raw_files[0]
print("Reading:", raw_path)

df = pd.read_csv(raw_path, low_memory=False)

# 2) Keep only the fields we need for analytics
keep = [
    "user_pseudo_id",
    "event_date",
    "event_timestamp",
    "event_name",
    "geo.country",
    "device.category",
    "traffic_source.source",
    "traffic_source.medium",
    "ecommerce.transaction_id",
    "ecommerce.purchase_revenue_in_usd",
]
keep = [c for c in keep if c in df.columns]
out = df[keep].copy()

# 3) Rename for Postgres/dbt friendliness
rename_map = {
    "user_pseudo_id": "user_id",
    "geo.country": "country",
    "device.category": "device_category",
    "traffic_source.source": "source",
    "traffic_source.medium": "medium",
    "ecommerce.transaction_id": "transaction_id",
    "ecommerce.purchase_revenue_in_usd": "purchase_revenue_usd",
}
out = out.rename(columns={k: v for k, v in rename_map.items() if k in out.columns})

# Ensure columns exist
for col in ["user_id", "event_date", "event_timestamp", "event_name"]:
    if col not in out.columns:
        out[col] = ""

# Normalize blanks
for c in out.columns:
    out[c] = out[c].fillna("").astype(str).str.strip()

# Drop empty rows (must have at least one important field)
important = ["user_id", "event_date", "event_timestamp", "event_name"]
mask = out[important].apply(lambda s: s.ne(""), axis=0).any(axis=1)
out = out[mask].copy()

# Fix formatting (remove trailing .0)
out["event_date"] = out["event_date"].str.replace(r"\.0$", "", regex=True)
out["event_timestamp"] = out["event_timestamp"].str.replace(r"\.0$", "", regex=True)

out_path = "data/ga4_events_skinny.csv"
out.to_csv(out_path, index=False)

print("Wrote:", out_path)
print("Rows:", len(out))
print("Columns:", list(out.columns))
print(out.head(3))
