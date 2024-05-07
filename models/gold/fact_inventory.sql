SELECT
    inv_id,
    inv_date,
    product_id,
    SUM(inv_qty) as inv_qty,
    inv_type,
    inv_modif_date
FROM
    {{ ref('int_inventory') }}
GROUP BY
    inv_id,
    inv_date,
    product_id,
    inv_type,
    inv_modif_date