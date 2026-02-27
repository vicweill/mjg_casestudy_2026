/** Test if there is no missing professional profile**/

select u.id
from {{ ref('stg_users') }} as u
left join {{ ref('stg_professional_profiles') }} as pp 
    on u.id = pp.user_id
where u.type='professional'
group by u.id
having (COUNT(pp.id) > 1 or COUNT(pp.id) = 0)
