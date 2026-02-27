{{ config(materialized='table') }}

with source as (
    select * from {{ ref('users') }}
),

renamed as (
    select
        _id as id,
        lower(type) as type,
        created_at,
        country,
        school_id,
        lower(fos) as field_of_study,
        lower(acquisition_channel) as acquisition_channel,
        active,
        last_seen_at
    from source
)

select * from renamed