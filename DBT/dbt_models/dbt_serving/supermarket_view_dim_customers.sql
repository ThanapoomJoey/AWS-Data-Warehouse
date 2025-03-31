{{
    config(
	materialized = 'view',
	schema = 'serving'
	)
}}
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    c.phone,
    l.city,
    l.region
FROM {{ ref('supermarket_raw_customers') }} c
LEFT JOIN {{ ref('supermarket_raw_locations')}} l
    ON c.location_id = l.location_id