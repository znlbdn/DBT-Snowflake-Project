SELECT
    id as sup_id,
    concat(first_name, ' ', last_name) as emp_name,
    company as emp_company,
    job_title as emp_job
FROM
    {{ source('staging', 'stg_suppliers') }}
ORDER BY 
    sup_id ASC