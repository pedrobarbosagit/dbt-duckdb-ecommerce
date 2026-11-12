select
    cast(date_trunc('month', purchased_at) as date) as order_month,
    cast(count(*) as bigint) as delivered_orders,
    cast(avg(delivery_days) as decimal(10, 1)) as avg_delivery_days,
    cast(count(*) filter (where is_late) as bigint) as late_orders,
    cast(count(*) filter (where is_late) * 1.0 / count(*) as decimal(5, 4)) as late_rate
from {{ ref('fct_orders') }}
where status = 'delivered' and delivery_days is not null
group by 1
