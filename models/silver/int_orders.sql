SELECT
    t1.id as order_id,
    CAST(t1.order_date as date) as order_date,
    t1.employee_id as employee_id,
    t1.customer_id as customer_id,
    t2.product_id as product_id,
    t2.quantity as order_qty,
    t2.unit_price as order_unit,
    t2.discount as order_discount,
    t1.shipping_fee as order_shipfee,
    t1.taxes as order_tax,
    t3.status_name as order_status,
    t4.status as order_detail_status,
    CAST(t1.shipped_date as date) as order_shipdate,
    CAST(t1.paid_date as date) as order_paiddate,
    t1.payment_type as order_paymentype,
    t1.ship_name as order_shipname,
    t1.ship_city as order_shipcity,
    t5.company as order_shipcompany
FROM
    {{ source('staging', 'stg_orders') }} as t1
LEFT JOIN
    {{ source('staging', 'stg_order_details') }} as t2
ON
    t1.id = t2.order_id
LEFT JOIN
    {{ source('staging', 'stg_orders_status')}} as t3
ON
    t1.status_id = t3.id
LEFT JOIN
    {{ source('staging', 'stg_order_details_status')}} as t4
ON
    t2.status_id = t4.id
LEFT JOIN
    {{ source('staging', 'stg_shippers')}} as t5
ON
    t1.shipper_id = t5.id
ORDER BY
    order_id ASC