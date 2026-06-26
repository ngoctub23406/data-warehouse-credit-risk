{{ config(materialized='table') }}

WITH base_data AS (
    SELECT * FROM {{ ref('stg_sessions') }}
),
feature_calc AS (
    SELECT 
        *,
        -- 1. Tổng số trang đã xem
        (Administrative + Informational + ProductRelated) AS total_pages_viewed,
        -- Tổng thời lượng
        (Administrative_Duration + Informational_Duration + ProductRelated_Duration) AS total_duration
    FROM base_data
)
SELECT 
    *,
    -- 2. Thời gian trung bình cho mỗi trang (xử lý lỗi chia cho 0)
    CASE 
        WHEN total_pages_viewed = 0 THEN 0
        ELSE total_duration / total_pages_viewed 
    END AS avg_time_per_page,
    
    -- 3. Phiên có giá trị trang cao (So sánh với trung vị)
    CASE 
        WHEN PageValues > (SELECT percentile_cont(0.5) WITHIN GROUP (ORDER BY PageValues) FROM base_data) THEN TRUE
        ELSE FALSE
    END AS is_high_value_session,
    
    -- Chuyển biến mục tiêu (Revenue) từ boolean sang 1/0 để dễ train mô hình
    CAST(Revenue AS INTEGER) AS target_revenue
FROM feature_calc