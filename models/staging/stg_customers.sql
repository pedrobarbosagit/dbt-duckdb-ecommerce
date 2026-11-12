select
    customer_id,
    customer_unique_id,
    {{ clean_text('customer_zip_code_prefix') }} as zip_code_prefix,
    {{ clean_text('customer_city') }} as city,
    upper({{ clean_text('customer_state') }}) as state
from {{ source('olist', 'customers') }}
