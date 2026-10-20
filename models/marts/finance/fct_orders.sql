SELECT 
    o.order_id, 
    c.customer_id, 
    p.amount
from {{ ref('stg_jaffle_shop__orders') }} o
INNER JOIN {{ ref('stg_jaffle_shop__customers') }} c ON o.customer_id = c.customer_id
INNER JOIN {{ ref('stg_stripe__payments') }} p ON o.order_id = p.order_id

