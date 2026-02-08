with events as (
  select event_date, user_id, event_name
  from {{ ref('stg_ga4_events') }}
)
select
  event_date,
  count(distinct case when event_name = 'session_start' then user_id end) as sessions,
  count(distinct case when event_name = 'view_item' then user_id end) as viewers,
  count(distinct case when event_name = 'add_to_cart' then user_id end) as add_to_cart,
  count(distinct case when event_name = 'purchase' then user_id end) as purchasers
from events
group by 1
order by 1
