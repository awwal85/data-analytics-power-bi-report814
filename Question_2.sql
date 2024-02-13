SELECT 
    dim_date.month_name:: text, 
    orders.total_orders,
    dim_date.year 

FROM 
    orders,
    dim_date

WHERE
    dim_date.year::text LIKE '%22'

GROUP BY 
    month_name::text, total_orders, dim_date.year

ORDER BY
    month_name::text, total_orders DESC

LIMIT 1; 