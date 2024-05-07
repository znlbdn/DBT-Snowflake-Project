SELECT
    id as prod_id,
    product_code as prod_code,
    product_name as prod_name,
    category as prod_category,
    standart_cost as prod_standardcost,
    list_price as prod_listprice,
    reorder_level as prod_reorderlevel,
    target_level as prod_targetlevel,
    supplier_ids as prod_supplierid,
    quantity_per_unit as prod_unit
FROM 
    {{ source('staging', 'stg_products') }}
ORDER BY 
    prod_id ASC