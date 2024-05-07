SELECT
    id as ship_id,
    company as ship_company,
    city as ship_city,
    state_province as ship_province,
    country_region as ship_region,
    address as ship_address,
    zip_postal_code as ship_postalcode
FROM 
    {{ source('staging', 'stg_shippers') }}
ORDER BY 
    ship_id ASC