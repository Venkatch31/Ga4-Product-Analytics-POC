select
  user_id,
  lower(nullif(event_name,'')) as event_name,
  nullif(country,'') as country,
  nullif(device_category,'') as device_category,
  nullif(source,'') as source,
  nullif(medium,'') as medium,
  nullif(transaction_id,'') as transaction_id,

  -- purchase revenue -> numeric (blank -> null)
  nullif(purchase_revenue_usd,'')::numeric as purchase_revenue_usd,

  -- event_date is YYYYMMDD text
  to_date(event_date, 'YYYYMMDD') as event_date,

  -- event_timestamp is microseconds text -> timestamp
  to_timestamp((event_timestamp::bigint) / 1000000.0) as event_ts
from {{ source('raw', 'ga4_events') }}
where nullif(user_id,'') is not null
  and nullif(event_date,'') is not null
  and nullif(event_timestamp,'') is not null
  and nullif(event_name,'') is not null
