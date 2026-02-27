{{ config(materialized='table') }}

with source as (
    select * from {{ ref('appointments') }}
),

renamed as (
    select
        _id as id,
        conversation_id,
        created_at,
        scheduled_at,
        completed_at,
        status,
        lower(type) as type,
        duration_minutes,
        rating
    from source
)

select * from renamed
