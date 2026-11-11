-- A delivered order with no items would be a data problem upstream.
select order_id
from {{ ref('fct_orders') }}
where status = 'delivered' and item_count = 0
