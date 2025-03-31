{{
    config(
	materialized = 'view',
	schema = 'serving'
	)
}}
SELECT
    b.branch_id,
    b.branch_name,
    b.open_date,
    b.manager_name,
    l.city,
    l.region
FROM {{ ref('supermarket_raw_branches') }} b
LEFT JOIN {{ ref('supermarket_raw_locations') }} l
    ON b.location_id = l.location_id