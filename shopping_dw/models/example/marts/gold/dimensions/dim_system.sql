{{ config(materialized='table') }}

SELECT DISTINCT
    md5(CAST(OperatingSystems AS VARCHAR) || '-' || CAST(Browser AS VARCHAR) || '-' || CAST(Region AS VARCHAR) || '-' || CAST(TrafficType AS VARCHAR)) AS system_key,
    OperatingSystems,
    Browser,
    Region,
    TrafficType
FROM {{ ref('stg_sessions') }}