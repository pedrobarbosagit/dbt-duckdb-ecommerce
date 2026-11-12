select
    order_id,
    count(*) as payment_count,
    sum(payment_value) as paid_amount
from {{ ref('stg_payments') }}
group by order_id
