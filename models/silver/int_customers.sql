SELECT
    distinct id as cust_id,
    concat(first_name, ' ', last_name) as cust_name,
    company as cust_company,
    job_title as cust_job,
    business_phone as cust_phonenum,
    fax_number as cust_faxnum,
    city as cust_city,
    state_province as cust_province,
    country_region as cust_region,
    address as cust_address,
    zip_postal_code as cust_postalcode
FROM
    {{ source('staging', 'stg_customers')}}
ORDER BY 
    cust_id ASC