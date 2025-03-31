{{
    config(
	materialized = 'view',
	schema = 'serving'
	)
}}
SELECT
    p.product_id,
    p.product_name,
    c.category_name,
    p.unit_cost,
    p.unit_price,
    p.stock_quantity,
    p.last_restock_date
FROM {{ ref('supermarket_raw_products') }} p
LEFT JOIN {{ ref('supermarket_raw_categories') }} c 
    on p.category_id = c.category_id