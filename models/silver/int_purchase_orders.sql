SELECT
    t1.id as purch_id,
    CAST(t1.creation_date as date) as purch_date,
    t2.product_id as product_id,
    t2.quantity as purch_qty,
    t2.unit_cost as purch_unit,
    t3.status as purch_status,
    t1.shipping_fee as purch_shipfee,
    t1.taxes as purch_tax
FROM
    {{ source('staging', 'stg_purchase_orders') }} as t1
LEFT JOIN
    {{ source('staging', 'stg_purchase_order_details') }} as t2
ON
    t1.id = t2.purchase_order_id
LEFT JOIN
    {{ source('staging', 'stg_purchase_order_status') }} as t3
ON
    t1.status_id = t3.id
ORDER BY
    purch_id ASC