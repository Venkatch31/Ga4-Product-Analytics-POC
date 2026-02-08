select
  event_date,
  count(distinct user_id) as dau
from {{ ref('stg_ga4_events') }}
group by 1
order by 1
