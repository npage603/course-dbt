/*
ideas: daily page views by product, daily orders by product, 
    what is getting a lot of traffic but not converting into purchases
*/
with events as (
    select * from {{ ref('stg_postgres__events') }}
), 
order_items as (
    select * from {{ ref('stg_postgres__order_items') }}
),
products as (
    select * from {{ ref('stg_postgres__products') }}
)
select e.event_id
    , e.session_id
    , e.user_id
    , e.event_type
    , e.event_created_at_utc
    , e.order_id
    , o.product_id
    , p.product_name
    , p.product_price
    , p.product_inventory
from events e
left join order_items o on e.order_id = o.order_id
left join products p on o.product_id = p.product_id