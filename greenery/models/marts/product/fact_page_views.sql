/*
ideas: daily page views by product, daily orders by product, 
    what is getting a lot of traffic but not converting into purchases
*/
with events as (
    select * from {{ ref('stg_events') }}
), 
users as (
    select * from {{ ref('stg_users') }}
),
products as (
    select * from {{ ref('stg_products') }}
)
select e.event_id
    , e.session_id
    , e.user_id
    , u.user_email
    , e.page_url
    , e.event_created_at_utc
    , e.product_id
    , p.product_name
    , p.product_price
    , p.product_inventory
from events e
left join users u on e.user_id = u.user_id
left join products p on e.product_id = p.product_id
where 1=1
and e.event_type = 'page_view'