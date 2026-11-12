select
    cast(p.product_id as varchar) as product_id,
    cast(coalesce(p.category_name, 'unknown') as varchar) as category_name,
    cast(coalesce(c.category_name_english, 'unknown') as varchar) as category_name_english,
    cast(p.weight_g as integer) as weight_g
from {{ ref('stg_products') }} as p
left join {{ ref('stg_product_categories') }} as c on p.category_name = c.category_name
