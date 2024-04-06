
with events as (
    select * from {{ ref('stg_postgres__events') }}
),
order_items as (
    select * from {{ ref('stg_postgres__order_items') }}
),
session_details as (
    select * from {{ ref('int_user_session_details')}}
)

select e.session_id
    , e.user_id
    , coalesce(e.product_id, oi.product_id) as product_id
    , s.session_events
    , s.first_session_event_day_utc
    , s.first_session_event_timestamp_utc
    , s.last_session_event_timestamp_utc
    , s.page_view_count
    , s.checkout_count
    , s.package_shipped_count
    , s.add_to_cart_count
from events e
left join order_items oi on e.order_id = oi.order_id
left join session_details s on e.session_id = s.session_id and e.user_id = s.user_id