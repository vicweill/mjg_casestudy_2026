{# Join more easily a user to its details information #}
{{ config(materialized='view') }}

select
    u.id as user_id,
    u.type as user_type,
    s.id as school_id,
    pp.id as pro_profile_id
from {{ ref('stg_users') }} as u
left join {{ ref('stg_schools') }} as s
    on u.school_id = s.id and u.type = 'student'
left join {{ ref('stg_professional_profiles') }} as pp
    on pp.user_id = u.id and u.type = 'professional'
