SELECT
    t2.cust_name as name,
    t2.cust_company as company,
    t1.order_date as order_date,
    t3.prod_code as code,
    t3.prod_name as product_name,
    t3.prod_category as category,
    SUM(t1.order_qty) as qty,
    SUM(t1.order_unit) as unit_price,
    SUM(t1.order_discount) as discount,
    SUM(t1.order_shipfee) as shipping_fee,
    SUM(t1.order_tax) as tax,
    SUM(t1.order_total_value) as total_amount,
    t1.order_status as status_order,
    t1.order_detail_status as status_payment,
    t1.order_paiddate as paid_date,
    t1.order_paymentype as payment_method
FROM
    {{ ref('fact_orders') }} as t1
LEFT JOIN
    {{ ref('dim_customers') }} as t2
ON
    t1.customer_id = t2.cust_id
LEFT JOIN
    {{ ref('dim_products') }} as t3
ON 
    t1.product_id = t3.prod_id
GROUP BY
    name, company, order_date, code, product_name, category, status_order, status_payment, paid_date, payment_method