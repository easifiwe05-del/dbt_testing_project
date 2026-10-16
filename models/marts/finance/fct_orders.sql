-- SELECT 
--     o.order_id, 
--     c.customer_id, 
--     p.amount
-- from {{ ref('stg_jaffle_shop__orders') }} o
-- INNER JOIN {{ ref('stg_jaffle_shop__customers') }} c ON o.customer_id = c.customer_id
-- INNER JOIN {{ ref('stg_stripe__payments') }} p ON o.order_id = p.order_id

with orders as  (
    select * from {{ ref ('stg_jaffle_shop__orders' )}}
),

payments as (
    select * from {{ ref ('stg_stripe__payment') }}
),

order_payments as (
    select
        order_id,
        sum (case when payment_status = 'success' then payment_amount end) as amount

    from payments
    group by 1
),

 final as (

    select
        orders.order_id,
        orders.customer_id,
        orders.order_date,
        coalesce (order_payments.amount, 0) as amount

    from orders
    left join order_payments using (order_id)
)

select * from final