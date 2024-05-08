SELECT
    date,
    year(date) as year,
    month(date) as month,
    monthname(date) as monthname,
    dayofweek(date) as dayofweek,
    weekofyear(date) as weekofyear,
    dayofyear(date) as dayofyear
FROM
    {{ ref('int_dates') }}