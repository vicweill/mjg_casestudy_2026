{{ config(materialized='table') }}

with monthly_users as (
    select
        date_trunc('month', created_at) as month,
        count(id) as new_users,
        count(id) filter (where type = 'student') as new_students,
        count(id) filter (where type = 'professional') as new_professionals
    from {{ ref('stg_users') }} as users
    group by month
),

monthly_conversations as (
    select
        date_trunc('month', created_at) as month,
        count(id) as nb_conversations
    from {{ ref('stg_conversations') }}
    where status = 'replied'
    group by month
),

monthly_appointments as (
    select
        date_trunc('month', created_at) as month,
        count(id) as nb_appointments_done,
        avg(rating) as avg_rating
    from {{ ref('stg_appointments') }}
    where status = 'completed'
    group by month
)

select
    mu.month,
    mu.new_students,
    mu.new_professionals,
    mc.nb_conversations,
    ma.nb_appointments_done,
    round(ma.avg_rating, 2) as avg_apt_rating
from monthly_users as mu
left join monthly_conversations as mc on mu.month = mc.month
left join monthly_appointments as ma on mu.month = ma.month
order by mu.month asc
