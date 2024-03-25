Welcome to your new dbt project!

### Using the starter project

Try running the following commands:
- dbt run
- dbt test


### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices

------------------------------------------

WEEK 1 SHORT ANSWERS

1. How many users do we have?
There are 130 unique users. Below is the SQL used to reach this answer.

select count(1)
from (
    select distinct user_id
    from DEV_DB.DBT_NICKPAGESIGMACOMPUTINGCOM.stg_users
)
;

2. On average, how many orders do we receive per hour?
On avergae, 7.520833 are received per hour. Below is the SQL used to reach this answer.

with hourly_orders as (
    select date_trunc("hour",created_at) as order_hour
        ,count(distinct order_id) as num_orders
    from DEV_DB.DBT_NICKPAGESIGMACOMPUTINGCOM.stg_orders
    group by 1
)
select avg(num_orders)
from hourly_orders
;


3. On average, how long does an order take from being placed to being delivered?
On average, it takes 3.891803 days from an order being placed to being delivered. Below is the SQL used to reach this answer.

select avg(datediff("day",created_at,delivered_at)) as avg_delivery_time
from DEV_DB.DBT_NICKPAGESIGMACOMPUTINGCOM.stg_orders
;

4. How many users have only made one purchase? Two purchases? Three+ purchases? Note: you should consider a purchase to be a single order. In other words, if a user places one order for 3 products, they are considered to have made 1 purchase.
25 users have made only 1 purchase, 28 users have made two purchases, and 34 users have made 3+ purchases. Below is the SQL used to reach this answer.

with user_details as (
    select user_id
        , count(distinct order_id) as user_orders
    from DEV_DB.DBT_NICKPAGESIGMACOMPUTINGCOM.stg_orders
    group by 1
)
select case when user_orders > 2 then 3 else user_orders end as user_order_categories
    , count(distinct user_id)
from user_details
group by 1
order by 1
;

6. On average, how many unique sessions do we have per hour?
On average, there are 16.327586 unique sessions per hour.

with hourly_sessions as (
    select date_trunc("hour",created_at) as order_hour
        ,count(distinct session_id) as num_sessions
    from DEV_DB.DBT_NICKPAGESIGMACOMPUTINGCOM.stg_events
    group by 1
)
select avg(num_sessions)
from hourly_sessions
;