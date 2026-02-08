select
  user_id                                   as user_id,
  event_ts                                  as event_time,
  event_name                                as event_type,

  -- Event properties like Amplitude/Heap “event properties”
  jsonb_build_object(
    'country', country,
    'device_category', device_category,
    'source', source,
    'medium', medium,
    'transaction_id', transaction_id,
    'purchase_revenue_usd', purchase_revenue_usd
  ) as event_properties,

  -- Optional user properties (you can expand later)
  jsonb_build_object(
    'country', country,
    'device_category', device_category
  ) as user_properties
from {{ ref('stg_ga4_events') }}
