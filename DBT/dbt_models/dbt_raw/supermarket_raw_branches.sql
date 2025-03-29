{{
    config(
	materialized = 'table',
	schema = 'raw'
	)
}}

select
  *
from {{ source('supermarket','supermarket_branches') }}
