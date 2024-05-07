SELECT
    id as ivc_id,
    CAST(invoice_date as date) as inc_date,
    order_id as order_id,
    tax as inc_tax,
    shipping as ivc_shipping,
    amount_due as inc_amount
FROM
    {{ source('staging', 'stg_invoices') }}
ORDER BY
    ivc_id ASC