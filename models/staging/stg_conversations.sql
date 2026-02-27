{{ config(materialized='table') }}

with source as (
    select * from {{ ref('conversations') }}
),

renamed as (
    select
        _id as id,
        student_id,
        professional_id,
        created_at,
        first_response_at,
        lower(status) as status,
        message_count
    from source
)

select * from renamed
