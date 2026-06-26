{{ config(materialized='table') }}

SELECT
    ROW_NUMBER() OVER() AS session_id, -- Tạo ID tự tăng cho mỗi phiên
    md5(CAST(VisitorType AS VARCHAR)) AS visitor_key,
    md5(CAST(OperatingSystems AS VARCHAR) || '-' || CAST(Browser AS VARCHAR) || '-' || CAST(Region AS VARCHAR) || '-' || CAST(TrafficType AS VARCHAR)) AS system_key,
    md5(Month || '-' || CAST(Weekend AS VARCHAR) || '-' || CAST(SpecialDay AS VARCHAR)) AS time_key,
    
    -- Các chỉ số định lượng
    Administrative,
    Administrative_Duration,
    Informational,
    Informational_Duration,
    ProductRelated,
    ProductRelated_Duration,
    BounceRates,
    ExitRates,
    PageValues,
    has_page_value,
    is_bad_rate,
    
    -- Biến mục tiêu
    Revenue AS is_revenue
FROM {{ ref('stg_sessions') }}