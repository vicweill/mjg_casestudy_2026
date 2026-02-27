{{ config(materialized='table') }}

with students as (
    select
        users.id,
        users.created_at,
        schools.name as school_name
    from
        {{ ref('stg_users') }} users
    left join {{ ref('stg_schools') }} as schools
        on users.school_id = schools.id and users.type = 'student'
)

select
    students.id,
    students.created_at,
    students.school_name,
    count(distinct conversations.id) as total_conversations,
    count(conversations.id) filter (where conversations.status = 'replied') as conversations_replied,
    count(distinct appointments.id) as total_appointments,
    count(conversations.id) filter (where appointments.status = 'completed') as appointments_completed
from students
left join {{ ref('stg_conversations') }} as conversations
    on conversations.student_id = students.id
left join {{ ref('stg_appointments') }} as appointments
    on conversations.id = appointments.conversation_id
group by students.id, students.created_at, students.school_name
order by students.id
