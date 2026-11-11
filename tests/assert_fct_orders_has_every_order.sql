-- Orders without items or payments must survive the joins (left joins, not inner joins).
select fct.n as fct_orders_rows, stg.n as stg_orders_rows
from (select count(*) as n from {{ ref('fct_orders') }}) as fct
cross join (select count(*) as n from {{ ref('stg_orders') }}) as stg
where fct.n <> stg.n
