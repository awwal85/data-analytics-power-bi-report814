SELECT 
    orders.store_code::text, 
    orders.total_orders,
    country_region.country::text,
    dim_date.year 

FROM 
    orders,
    country_region,
    dim_date

WHERE
    dim_date.year::text LIKE '%22' AND country::text LIKE 'Ge%'

GROUP BY 
    country::text, store_code::text, total_orders, dim_date.year

ORDER BY
    country::text, total_orders DESC

LIMIT 1;