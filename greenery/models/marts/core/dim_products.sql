select p.product_id
    , p.name as product_name
    , p.price
    , p.inventory
from DEV_DB.DBT_NICKPAGESIGMACOMPUTINGCOM.stg_products p
;