select
    order_id,
    customer_id,
    lower({{ clean_text('order_status') }}) as status,
    try_cast({{ clean_text('order_purchase_timestamp') }} as timestamp) as purchased_at,
    try_cast({{ clean_text('order_approved_at') }} as timestamp) as approved_at,
    try_cast({{ clean_text('order_delivered_carrier_date') }} as timestamp) as delivered_to_carrier_at,
    try_cast({{ clean_text('order_delivered_customer_date') }} as timestamp) as delivered_to_customer_at,
    try_cast({{ clean_text('order_estimated_delivery_date') }} as timestamp) as estimated_delivery_at
from {{ source('olist', 'orders') }}
