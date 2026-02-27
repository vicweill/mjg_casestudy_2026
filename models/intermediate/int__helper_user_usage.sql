{# Join more easily a user to its activity #}
{{ config(materialized='view') }}

select
    u.id as user_id,
    u.type as user_type,
    c.id as conversation_id,
    a.id as appointment_id
from {{ ref('stg_users') }} as u
left join {{ ref('stg_conversations') }} as c
    on (u.id = c.student_id and u.type = 'student'
    or u.id = c.professional_id and u.type = 'professional')
left join {{ ref('stg_appointments') }} as a
    on c.id = a.conversation_id
