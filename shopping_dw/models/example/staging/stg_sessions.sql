{{ config(materialized='view') }}
select
    *,
    case when BounceRates > 1 or ExitRates > 1 then true else false end as is_bad_rate,
    case 
        when SpecialDay = 0 then 'No holiday'
        when SpecialDay > 0 and SpecialDay <= 0.2 then 'Near holiday'
        else 'Holiday or very close'
    end as holiday_proximity,
    case when PageValues > 0 then true else false end as has_page_value
from {{ source('bronze', 'raw_sessions') }}
where
    PageValues >= 0
    and SpecialDay between 0 and 1
    and Administrative >= 0
    and ProductRelated >= 0
    and Administrative_Duration >= 0
    and ProductRelated_Duration >= 0