-- Built from the intermediate layer, not from fct_orders, because fct_orders points back here.
select
    cast(customer_unique_id as varchar) as customer_unique_id,
    cast(arg_max(customer_state, purchased_at) as varchar) as state,
    cast(arg_max(customer_city, purchased_at) as varchar) as city,
    cast(min(purchased_at) as timestamp) as first_order_at,
    cast(max(purchased_at) as timestamp) as last_order_at,
    cast(count(*) as bigint) as order_count,
    cast(coalesce(sum(items_revenue) filter (where status = 'delivered'), 0) as decimal(18, 2)) as lifetime_revenue
from {{ ref('int_orders_enriched') }}
where customer_unique_id is not null
group by customer_unique_id
