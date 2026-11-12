-- The source misspells "lenght"; those columns are not used downstream, so they are dropped here.
select
    product_id,
    {{ clean_text('product_category_name') }} as category_name,
    try_cast({{ clean_text('product_photos_qty') }} as integer) as photos_qty,
    try_cast({{ clean_text('product_weight_g') }} as integer) as weight_g
from {{ source('olist', 'products') }}
