{{ config(materialized='table') }}

SELECT DISTINCT
    md5(CAST(VisitorType AS VARCHAR)) AS visitor_key,
    VisitorType
FROM {{ ref('stg_sessions') }}