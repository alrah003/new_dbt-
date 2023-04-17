{{ config(materialized='view') }}

with tripdata as 
(
  select *,
    row_number() over(partition by pickup_datetime) as rn
  from {{ source('staging','fvhridesnew') }}
)

select
    -- identifiers
    dispatching_base_num,
    cast(PUlocationID as integer) as  pickup_locationid,
    cast(DOlocationID as integer) as dropoff_locationid,
    
    -- timestamps
    cast(pickup_datetime as timestamp) as pickup_datetime,
    cast(dropOff_datetime as timestamp) as dropoff_datetime,
    
    -- trip info
    Affiliated_base_number as affiliated_base_number

from tripdata


-- dbt build --m <model.sql> --var 'is_test_run: false'
{% if var('is_test_run', default=true) %}

  limit 100

{% endif %}
