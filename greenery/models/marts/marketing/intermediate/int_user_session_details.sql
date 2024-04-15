{% set event_types = dbt_utils.get_column_values(table=ref('stg_postgres__events'), column='event_type') %}

with events as (
    select * from {{ ref('stg_postgres__events') }}
)

select session_id
    , user_id
    , count(distinct event_id) as session_events
    , min(date_trunc("day",event_created_at_utc)) as first_session_event_day_utc
    , min(event_created_at_utc) as first_session_event_timestamp_utc
    , max(event_created_at_utc) as last_session_event_timestamp_utc
    {% for i in event_types %}
    , {{ count_col_value_occurrences('event_type', i)}} as {{ i }}_count
    {% endfor %}
from events
group by 1,2