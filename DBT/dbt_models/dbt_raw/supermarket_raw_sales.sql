{{
    config(
        materialized = 'incremental',
        schema = 'raw'
        )
}}

select
  *
from {{ source('supermarket','supermarket_sales') }}

{% if is_incremental() %}

  where sale_date > (select max(sale_date) from {{ this }} )

{% endif %}
