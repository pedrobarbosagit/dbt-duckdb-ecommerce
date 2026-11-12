{{ config(
    materialized='incremental',
    unique_key='order_id',
    incremental_strategy='delete+insert'
) }}

select
    cast(order_id as varchar) as order_id,
    cast(customer_unique_id as varchar) as customer_unique_id,
    cast(customer_state as varchar) as customer_state,
    cast(status as varchar) as status,
    cast(purchased_at as timestamp) as purchased_at,
    cast(delivered_to_customer_at as timestamp) as delivered_to_customer_at,
    cast(estimated_delivery_at as timestamp) as estimated_delivery_at,
    cast(item_count as bigint) as item_count,
    cast(items_revenue as decimal(18, 2)) as items_revenue,
    cast(freight_total as decimal(18, 2)) as freight_total,
    cast(paid_amount as decimal(18, 2)) as paid_amount,
    cast(date_diff('day', purchased_at, delivered_to_customer_at) as integer) as delivery_days,
    delivered_to_customer_at > estimated_delivery_at as is_late
from {{ ref('int_orders_enriched') }}

{% if is_incremental() %}
-- Later runs only read orders from the latest purchase time onwards; delete+insert replaces
-- the boundary rows, so running twice never duplicates an order.
where purchased_at >= (select max(purchased_at) from {{ this }})
{% endif %}
