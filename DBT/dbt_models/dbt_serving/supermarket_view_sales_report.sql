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
    s.total_amount,
    p.product_name,
    p.category_name,
    p.unit_cost,
    p.unit_price,
    c.first_name,
    c.last_name,
    b.branch_name,
    b.manager_name,
    b.city,
    b.region
FROM {{ ref('supermarket_view_fact_sales')}} s
LEFT JOIN {{ ref('supermarket_view_dim_products')}} p ON s.product_id = p.product_id
LEFT JOIN {{ ref('supermarket_view_dim_customers')}} c ON s.customer_id = c.customer_id
LEFT JOIN {{ ref('supermarket_view_dim_branches')}} b ON s.branch_id = b.branch_id