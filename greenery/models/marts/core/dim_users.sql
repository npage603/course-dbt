select u.user_id
    , u.first_name
    , u.last_name
    , u.email
    , u.phone_number
    , a.address
    , a.zipcode
    , a.state
    , a.country
from DEV_DB.DBT_NICKPAGESIGMACOMPUTINGCOM.stg_users u
left join DEV_DB.DBT_NICKPAGESIGMACOMPUTINGCOM.stg_addresses a on a.address_id = u.address_id
;