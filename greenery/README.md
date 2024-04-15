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

### WEEK 1 SHORT ANSWERS

1. How many users do we have?
There are 130 unique users. Below is the SQL used to reach this answer.

```
select count(1)
from (
    select distinct user_id
    from DEV_DB.DBT_NICKPAGESIGMACOMPUTINGCOM.stg_users
)
;
```

2. On average, how many orders do we receive per hour?
On avergae, 7.520833 are received per hour. Below is the SQL used to reach this answer.

```
with hourly_orders as (
    select date_trunc("hour",created_at) as order_hour
        ,count(distinct order_id) as num_orders
    from DEV_DB.DBT_NICKPAGESIGMACOMPUTINGCOM.stg_orders
    group by 1
)
select avg(num_orders)
from hourly_orders
;
```

3. On average, how long does an order take from being placed to being delivered?
On average, it takes 3.891803 days from an order being placed to being delivered. Below is the SQL used to reach this answer.

```
select avg(datediff("day",created_at,delivered_at)) as avg_delivery_time
from DEV_DB.DBT_NICKPAGESIGMACOMPUTINGCOM.stg_orders
;
```

4. How many users have only made one purchase? Two purchases? Three+ purchases? Note: you should consider a purchase to be a single order. In other words, if a user places one order for 3 products, they are considered to have made 1 purchase.
25 users have made only 1 purchase, 28 users have made two purchases, and 34 users have made 3+ purchases. Below is the SQL used to reach this answer.

```
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
```

6. On average, how many unique sessions do we have per hour?
On average, there are 16.327586 unique sessions per hour.

```
with hourly_sessions as (
    select date_trunc("hour",created_at) as order_hour
        ,count(distinct session_id) as num_sessions
    from DEV_DB.DBT_NICKPAGESIGMACOMPUTINGCOM.stg_events
    group by 1
)
select avg(num_sessions)
from hourly_sessions
;
```

------------------------------------------

### WEEK 2 SHORT ANSWERS

## Part 1: Models
1. What is our user repeat rate?

_Repeat Rate = Users who purchased 2 or more times / users who purchased_

Our user repeat rate is 0.798387. Below is the SQL used to get to this answer.

```
with user_details as (
    select user_id
        , count(distinct order_id) as user_orders
    from DEV_DB.DBT_NICKPAGESIGMACOMPUTINGCOM.stg_orders
    group by 1
),
repeat_users as (
select user_id
    , user_orders
    , case
        when user_orders > 1 then 1
    end as user_repeat_flg
from user_details
)
select div0(sum(user_repeat_flg),count(1)) as repeat_rate
from repeat_users
;
```

2. What are good indicators of a user who will likely purchase again? What about indicators of users who are likely NOT to purchase again? If you had more data, what features would you want to look into to answer this question?

_NOTE: This is a hypothetical question vs. something we can analyze in our Greenery data set. Think about what exploratory analysis you would do to approach this question._

Below are potential good indicators of a user who will likely purchase again.
- If they've purchased before, time between purchases
- The number of times a user visits the website
- Session lengths on website, checkout page
- Total amount spent

Below are potential good indicators of a user who is NOT likely to purchase again.
- Opposite of the above indicators (i.e., user is not spending a lot of time on website, has purchased very little, large amount of time between prior purchases)
- User has refunded a purchase

3. Models created:
    - /marts/core/
        - dim_products
            - This model brings in the data from stg_products as is so that it can joined with other dimension and fact tables.
        - dim_users
            - This model combines user data as well as the most important address data for stakeholders to easily use.
        - fact_orders
            - This model combines order data with the granularity of order items for stakeholders to get all the info they need on orders.
    - /marts/marketing/
        - intermediate/int_user_order_facts
            - This model combines user and order data to make querying data about a user easier for stakeholders. The idea is that a stakeholder can do a simple group by on user to understand things like when was a user's first order, when was a user's last order, how many orders have they made, and their overall total spend.
        - intermediate/int_user_session_details
            - This model tracks what each user is doing on the website such as their first event, their last event, number of page views, etc. Each row is a unique user and this user data is combined with events data at the session level of granularity
    - /marts/product/
        - intermediate/int_user_products_daily
            - This model breaks down page view stats by day for each product ID. Things like daily page views by product can be obtained from this model. A simple join to orders would tell us our daily orders by product as well as what’s getting a lot of traffic then ultimately converting.
        - fact_page_views
            - This model shows all page view data combined with some user and product level data for the product team to easily query against


4. The following commands were super helpful in visualizing the DAG for the models I built.
`$ dbt docs generate`
`$ dbt docs serve --no-browser`

## Part 2: Tests

I added "not null" and "unique" tests to the primary keys of all of my staging tables (except for order items where the primary key is a combination of order_id and product_id). These are probably the most important tests to ensure my stakeholders aren't dealing with any duplicated data. The way that it's set up would cause failures if any of those tests failed. There are other tests I could likely build upon as well (positive values for all order amounts, last event dates occurring after first event dates, etc.). Put another way, I could test whether quantities like order quantity or prices are positive values where you expect them to be positive or perhaps date tests that ensure you have correct data i.e. order dates should be BEFORE arrival dates.  In going through this exercise, I did not come across any bad data (yet).

## Part 3: dbt Snapshots

After running `dbt snapshot`, the following products had their inventory change from week 1 to week 2:
    - Pothos
    - Philodendron
    - Monstera
    - String of pearls

I got to this answer by running the following SQL and observing the output.

```
select *
from DEV_DB.DBT_NICKPAGESIGMACOMPUTINGCOM.inventory_snapshot
where 1=1
order by product_id
;
```
------------------------------------------

### WEEK 3 SHORT ANSWERS

## Part 1: Create new models

- What is our overall conversion rate?
The overall conversion rate is 62.46%. To get this answer, I connected to `fact_user_sessions` in Sigma and created a summary using the function `CountDistinctIf([SESSION_ID], [CHECKOUT_COUNT] > 0) / CountDistinct([SESSION_ID])`.

- What is our conversion rate by product?
To get our conversion rate by product, I used the same model mentioned above, but in Sigma, I grouped the table on Product ID and then used the same calculation specified above at the product level. From there I sorted convrsion rate in descending and performed a lookup on the `dim_products` table to find the products with the top conversion rates. These top products were Fiddle Leaf Fig (89.29%), String of pearls (89.06%), and Monstera (87.76%).


_Note: Conversion rate is defined as the # of unique sessions with a purchase event / total number of unique sessions. Conversion rate by product is defined as the # of unique sessions with a purchase event of that product / total number of unique sessions that viewed that product_

- A question to think about: Why might certain products be converting at higher/lower rates than others? We don't actually have data to properly dig into this, but we can make some hypotheses.

The thing that immediately comes to mind here is marketing effectiveness, brand recognition, etc

## Part 2: Create macros

I created a macro called `count_col_value_occurrences`. This macro dynamically counts all possible occurrences of a given value within a given column. I specifically used this in `int_user_session_details` to dynamically create columns showing each event type count.

## Part 3: Create grant post hook

I created a post hook that grants usage/select to the "reporting" role. This is under the macros folder and called `grant.sql`. The post hook is specified in the dbt_project.yml file.

## Part 4: dbt Packages

I added the dbt-labs/dbt_utils and calogica/dbt_expectations packages and installed them by running `dbt deps` once I specified these packages in my `packages.yml` file. One example of using these packages is that I used `get_column_values` in `int_user_session_details` to grab each unique event type that would then get dynamically used to count occurrences (as mentioned above).

## Part 5: dbt docs

I ran `dbt docs generate` and then `dbt docs serve --no-browser` to show how I simplified/improved my DAG from last week using macros and/or dbt packages. It does look cleaner and part of that is because I also removed models that were not being used (from the example/tutorial before the course).

## Part 6: dbt snapshot

I am getting to this part of the week 3 assigment a week behind schedule so it's possible the values have since changed again but after running `dbt snapshot`, I have found that the following products had inventory changes since I had last checked.
    - Philodendron
    - Bamboo
    - ZZ Plant
    - Monstera


------------------------------------------

### WEEK 4 SHORT ANSWERS