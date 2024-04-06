with users as (
    select * from {{ ref('stg_postgres__users') }}
),
addresses as (
    select * from {{ ref('stg_postgres__addresses') }}
)
select u.user_id
    , u.user_first_name
    , u.user_last_name
    , u.user_name
    , u.user_email
    , u.user_phone_number
    , a.address
    , a.zipcode
    , a.state
    , a.country
from users u
left join addresses a on a.address_id = u.address_id