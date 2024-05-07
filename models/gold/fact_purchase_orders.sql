SELECT
    purch_id,
    purch_date,
    product_id,
    SUM(purch_qty) as purch_qty,
    SUM(purch_unit) as purch_unit,
    SUM(purch_shipfee) as purch_shipfee,
    SUM(purch_tax) as purch_tax,
    SUM({{ total_val('purch_qty', 'purch_unit', 'purch_shipfee', 'purch_tax') }}) as total_value_purch,
    purch_status
FROM
    {{ ref('int_purchase_orders') }}
GROUP BY
    purch_id,
    purch_date,
    product_id,
    purch_status