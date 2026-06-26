{{ config(materialized='table') }}

SELECT DISTINCT
    md5(Month || '-' || CAST(Weekend AS VARCHAR) || '-' || CAST(SpecialDay AS VARCHAR)) AS time_key,
    Month,
    Weekend,
    SpecialDay,
    holiday_proximity
FROM {{ ref('stg_sessions') }}