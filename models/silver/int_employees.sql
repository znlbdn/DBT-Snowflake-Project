SELECT
    id as emp_id,
    concat(first_name, ' ', last_name) as emp_name,
    email_address as emp_email,
    company as emp_company,
    job_title as emp_job,
    business_phone as emp_phonenum,
    fax_number as emp_faxnum,
    city as emp_city,
    state_province as emp_province,
    country_region as emp_region,
    address as emp_address,
    zip_postal_code as emp_postalcode
FROM
    {{ source('staging', 'stg_employees') }}
ORDER BY 
    emp_id ASC