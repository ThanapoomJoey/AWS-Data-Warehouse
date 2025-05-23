{{
    config(
	materialized = 'view',
	schema = 'serving'
	)
}}
SELECT
    s.sale_id,
    s.customer_id,
    s.product_id,
    s.branch_id,
    s.sale_date,
    s.quantity,
    p.unit_price,
    s.total_amount,
    p.unit_cost,
    ROUND((p.unit_price - p.unit_cost) * s.quantity,2) AS profit,
    CASE 
        WHEN s.unit_price = 0 THEN 0
        ELSE ROUND(((p.unit_price - p.unit_cost) / p.unit_price) * 100, 2)
    END AS "margin(%)"
FROM {{ ref('supermarket_raw_sales')}} s
LEFT JOIN {{ ref('supermarket_raw_products')}} p 
    ON s.product_id = p.product_id