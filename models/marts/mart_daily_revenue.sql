-- Revenue means item prices of delivered orders. Freight is reported apart, never mixed in.
select
    cast(purchased_at as date) as order_date,
    cast(count(*) as bigint) as orders,
    cast(sum(items_revenue) as decimal(18, 2)) as revenue,
    cast(sum(freight_total) as decimal(18, 2)) as freight,
    cast(sum(items_revenue) / count(*) as decimal(18, 2)) as avg_order_value
from {{ ref('fct_orders') }}
where status = 'delivered'
group by 1
