{{ config(materialized='table') }}

with source as (
    select * from {{ ref('professional_profiles') }}
),

renamed as (
    select
        _id as id,
        user_id,
        company,
        industry,
        job_title,
        years_experience,
        accepting_requests
    from source
)

select * from renamed
