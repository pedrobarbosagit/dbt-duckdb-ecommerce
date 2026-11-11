-- Joining items and payments naively multiplies rows (fan-out) and inflates revenue.
-- Totals in the fact table must equal totals in the staging tables.
with fct as (
    select sum(items_revenue) as revenue, sum(paid_amount) as paid, sum(item_count) as items
    from {{ ref('fct_orders') }}
),

stg as (
    select
        (select sum(price) from {{ ref('stg_order_items') }}) as revenue,
        (select sum(payment_value) from {{ ref('stg_payments') }}) as paid,
        (select count(*) from {{ ref('stg_order_items') }}) as items
)

select fct.revenue as fct_revenue, stg.revenue as stg_revenue, fct.paid as fct_paid, stg.paid as stg_paid
from fct
cross join stg
where abs(fct.revenue - stg.revenue) > 0.01
    or abs(fct.paid - stg.paid) > 0.01
    or fct.items <> stg.items
