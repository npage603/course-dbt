
with session_details as (
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
    from {{ ref('stg_events') }}
    group by 1,2
),
users as (
    select * from {{ ref('stg_users') }}
)
select s.session_id
    , s.user_id
    , u.user_name
    , u.user_email
    , s.session_events
    , s.first_session_event_day_utc
    , s.first_session_event_timestamp_utc
    , s.last_session_event_timestamp_utc
    , s.page_view_count
    , s.checkout_count
    , s.package_shipped_count
    , s.add_to_cart_count
from session_details s 
left join users u on u.user_id = s.user_id