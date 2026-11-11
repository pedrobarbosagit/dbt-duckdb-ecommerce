-- Singular test: it returns the rows that BREAK the rule, so zero rows means pass.
select order_id, payment_sequential, payment_value
from {{ ref('stg_payments') }}
where payment_value < 0
