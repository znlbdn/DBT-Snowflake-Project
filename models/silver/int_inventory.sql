SELECT
    t1.id as inv_id,
    CAST(t1.transaction_created_date as date)  as inv_date,
    t1.product_id as product_id,
    t1.quantity as inv_qty,
    t2.type_name as inv_type,
    CAST(t1.transaction_modified_date as date) as inv_modif_date
FROM 
    {{ source('staging', 'stg_inventory_transactions') }} as t1
LEFT JOIN
    {{ source('staging', 'stg_inventory_transaction_types') }} as t2
ON 
    t1.id = t2.id
ORDER BY
    inv_id ASC