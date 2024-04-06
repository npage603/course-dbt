
with events as (
    select * from {{ ref('stg_postgres__events') }}
),
users as (
    select * from {{ ref('stg_postgres__users') }}
),
products as (
    select * from {{ ref('stg_postgres__products') }}
)
select e.product_id
    , date_trunc("day",e.event_created_at_utc) as event_day
    , count(distinct e.event_id) as page_view_count
    , count(distinct e.user_id) as distinct_user_view_count
from events e
left join users u on e.user_id = u.user_id
left join products p on e.product_id = p.product_id
where 1=1
and e.event_type = 'page_view'
group by 1,2
