SELECT 
    orders.total_orders,
    forview.percentage_of_sales, 
    new_store_overview.count,
    dim_store.store_type

FROM 
    orders,
    forview,
    new_store_overview,
    dim_store

GROUP BY 
    total_orders, count, percentage_of_sales,dim_store.store_type

ORDER BY
    store_type DESC;    