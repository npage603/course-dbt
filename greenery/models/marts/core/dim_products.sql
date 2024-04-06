
with products as (
    select * from {{ ref('stg_postgres__products') }}
) 
select p.product_id
    , p.product_name
    , p.product_price
    , p.product_inventory
from products p