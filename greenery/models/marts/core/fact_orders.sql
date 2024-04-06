with order_items as (
    select * from {{ ref('stg_postgres__order_items') }}
),
orders as (
    select * from {{ ref('stg_postgres__orders') }}
)
select i.order_id
    , i.product_id
    , i.order_quantity
    , o.promo_id
    , o.user_id
    , o.address_id as user_address_id
    , o.order_created_at_utc
    , o.order_cost
    , o.shipping_cost
    , o.order_total
    , o.tracking_id
    , o.shipping_service
    , o.order_estimated_delivery_at_utc
    , o.order_delivered_at_utc
    , o.order_status
from order_items i
left join orders o on o.order_id = i.order_id