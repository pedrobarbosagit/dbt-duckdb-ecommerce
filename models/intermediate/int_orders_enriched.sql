-- Left joins on purpose: orders that were canceled before getting items or a payment must stay.
select
    o.order_id,
    c.customer_unique_id,
    c.state as customer_state,
    c.city as customer_city,
    o.status,
    o.purchased_at,
    o.delivered_to_customer_at,
    o.estimated_delivery_at,
    coalesce(i.item_count, 0) as item_count,
    coalesce(i.items_revenue, 0) as items_revenue,
    coalesce(i.freight_total, 0) as freight_total,
    coalesce(p.paid_amount, 0) as paid_amount,
    coalesce(p.payment_count, 0) as payment_count
from {{ ref('stg_orders') }} as o
left join {{ ref('stg_customers') }} as c on o.customer_id = c.customer_id
left join {{ ref('int_order_items_agg') }} as i on o.order_id = i.order_id
left join {{ ref('int_order_payments_agg') }} as p on o.order_id = p.order_id
