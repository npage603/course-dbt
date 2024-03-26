/*
ideas: daily page views by product, daily orders by product, 
    what is getting a lot of traffic but not converting into purchases
*/
select e.event_id
    , e.session_id
    , e.user_id
    , u.email as user_email
    , e.page_url
    , e.created_at as event_created_at
    , e.product_id
    , p.name as product_name
    , p.price as product_price
    , p.inventory as product_inventory
from DEV_DB.DBT_NICKPAGESIGMACOMPUTINGCOM.stg_events e
left join DEV_DB.DBT_NICKPAGESIGMACOMPUTINGCOM.stg_users u on e.user_id = u.user_id
left join DEV_DB.DBT_NICKPAGESIGMACOMPUTINGCOM.stg_products p on e.product_id = p.product_id
where 1=1
    and e.event_type = 'page_view'
;