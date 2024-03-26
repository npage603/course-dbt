select i.order_id
    , i.product_id
    , i.quantity
    , o.promo_id
    , o.user_id
    , o.address_id
    , o.created_at
    , o.order_cost
    , o.shipping_cost
    , o.order_total
    , o.tracking_id
    , o.shipping_service
    , o.estimated_delivery_at
    , o.delivered_at
    , o.status
from DEV_DB.DBT_NICKPAGESIGMACOMPUTINGCOM.stg_order_items i
left join DEV_DB.DBT_NICKPAGESIGMACOMPUTINGCOM.stg_orders o on o.order_id = i.order_id
;