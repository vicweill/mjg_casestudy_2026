{{ config(materialized='table') }}

with source as (
    select * from {{ ref('schools') }}
),

renamed as (
    select
        _id as id,
        name,
        region,
        lower(type) as type
    from source
)

select * from renamed