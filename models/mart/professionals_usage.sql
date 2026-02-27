{{ config(materialized='table') }}

with professionals as (
    select
        users.id,
        users.created_at,
        profiles.id as profile_id,
        profiles.company,
        profiles.job_title
    from {{ ref('stg_users') }} as users
    left join {{ ref('stg_professional_profiles') }} as profiles
        on users.id = profiles.user_id
    where users.type = 'professional'
),
conversations as (
    select
        professional_id,
        count(distinct id) as nb_conv,
        sum(case when status = 'replied' then 1 else 0 end) as conv_replied,
        percentile_cont(0.5) within group (order by datediff(
            'day', created_at, first_response_at
        ) ) as median_response_time_days
    from {{ ref('stg_conversations') }}
    group by professional_id
),
appointments as (
    select
        p.id as user_id,
        count(distinct a.id) as appointments_created,
        sum(case when a.status = 'completed' then 1 else 0 end) as appointments_completed,
        avg(a.rating) as average_rating
    from {{ ref('stg_appointments') }} a
    left join {{ ref('int__helper_user_usage') }} h on a.id = h.appointment_id
    left join professionals p on (p.id = h.user_id and h.user_type='professional')
    group by p.id
)

select
    professionals.id,
    professionals.job_title,
    professionals.company,

    -- conversations stats
    conversations.nb_conv,
    conversations.conv_replied,
    round(conversations.conv_replied / nullif(conversations.nb_conv, 0), 2) as reply_rate,
    conversations.median_response_time_days,
    
    -- appointments stats
    appointments.appointments_created,
    appointments.appointments_completed,
    round(appointments.appointments_created / nullif(appointments.appointments_completed, 0), 2) as completion_rate,
    appointments.average_rating

from professionals
left join conversations
    on professionals.id = conversations.professional_id
left join appointments
    on professionals.id = appointments.user_id
