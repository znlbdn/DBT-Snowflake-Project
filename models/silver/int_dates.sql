SELECT
    '2006-01-01'::date + row_number() over(order by 0) as Date
FROM
    table(generator(rowcount => 365))