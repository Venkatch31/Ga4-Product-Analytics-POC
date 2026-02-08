with first_seen as (
  select user_id, min(event_date) as cohort_date
  from {{ ref('stg_ga4_events') }}
  group by 1
),
activity as (
  select distinct
    e.user_id,
    f.cohort_date,
    e.event_date,
    (e.event_date - f.cohort_date) as day_number
  from {{ ref('stg_ga4_events') }} e
  join first_seen f using (user_id)
)
select
  cohort_date,
  day_number,
  count(distinct user_id) as active_users
from activity
where day_number between 0 and 14
group by 1,2
order by 1,2
