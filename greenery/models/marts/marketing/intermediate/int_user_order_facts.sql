

with order_details as (
    select order_id
        , user_id
        , order_cost
        , shipping_cost
        , order_total
        , order_created_at_utc
    from {{ ref('stg_orders') }}
),
users as (
    select *
    from {{ ref('stg_users') }}
)
select o.user_id
    , u.user_name
    , u.user_email
    , o.order_cost
    , o.shipping_cost
    , o.order_total
    , o.order_created_at_utc
from order_details o
left join users u on o.user_id = u.user_id
