select
    {{ clean_text('product_category_name') }} as category_name,
    {{ clean_text('product_category_name_english') }} as category_name_english
from {{ source('olist', 'product_category_name_translation') }}
