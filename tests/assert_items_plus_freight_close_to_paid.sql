{{ config(severity='warn') }}
-- Known to differ a little in the real data (vouchers, rounding), so it warns instead of failing.
-- The tolerance is one real; it only reports delivered orders.
select order_id, items_revenue + freight_total as expected, paid_amount
from {{ ref('fct_orders') }}
where status = 'delivered'
    and item_count > 0
    and abs(items_revenue + freight_total - paid_amount) > 1.00
