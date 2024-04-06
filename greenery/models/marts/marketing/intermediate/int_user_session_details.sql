with events as (
    select * from {{ ref('stg_postgres__events') }}
)

select session_id
    , user_id
    , count(distinct event_id) as session_events
    , min(date_trunc("day",event_created_at_utc)) as first_session_event_day_utc
    , min(event_created_at_utc) as first_session_event_timestamp_utc
    , max(event_created_at_utc) as last_session_event_timestamp_utc
    , sum(case when event_type='page_view' then 1 else 0 end) as page_view_count
    , sum(case when event_type='checkout' then 1 else 0 end) as checkout_count
    , sum(case when event_type='package_shipped' then 1 else 0 end) as package_shipped_count
    , sum(case when event_type='add_to_cart' then 1 else 0 end) as add_to_cart_count
from events
group by 1,2