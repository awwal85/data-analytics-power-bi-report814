# Data Analytics-Power BI-Report814

## Data Loading
#### Orders Table
This table has been loaded through Azure SQL Database. The Order Date and Shipping Date columns have been divided into individual Date and Time columns.
In order to preserve data integrity, any rows with null or missing values in the new Date column have been eliminated.
Additionally, for the sake of data privacy, the Card Number column has also been removed. The columns have been renamed to align with Power BI's naming conventions.

#### Product Table
This is a comma-separated values (CSV) file, which can be loaded using the CSV/text icon located on the home tab.
To ensure the uniqueness of each product, I have eliminated any duplicate entries from the product code column.
Additionally, the weight column has been split into separate Values and Units columns.
The data type for the Values column has been changed to decimals, and all measurements in grams or milliliters have been converted to kilograms for consistency.
The columns have been renamed to align with Power BI's naming conventions.

#### Stores Table
The file is accessed by connecting to Azure Bob storage with the appropriate credentials.
The columns have been renamed to align with Power BI's naming conventions.

#### Customers Table
The initial file was in zip format, which I then extracted and accessed through the Folder connector in the Get Data icon.
Additionally, I merged the first name and last name columns to generate a full name column.
Furthermore, the columns have been renamed to adhere to Power BI's standard naming conventions.

## Creating Data Model
#### Date Models
The Date Table serves as a continuously updated timeline, providing the necessary framework for implementing time-efficient functions in subsequent analyses.

#### Star Schema Data Model
These are one-to-many relationships where the active relationship is between orders and the Date Table, specifically through [Order Date] and [Date].

![image](https://github.com/awwal85/data-analytics-power-bi-report814/assets/114372396/b80331e0-0e1a-41ed-acd5-6c49ab850ba8)


#### Measures Table
The measures table contains the primary metrics used for the data analysis and reporting. Each of the following DAX formulas were utilized in obtaining these measures.

Total Orders = COUNT(Orders[Product Code])

Total Revenue = SUMX(Orders,Orders[Product Quantity] * RELATED(Products[Sale Price]))

Total Profit = SUMX(Orders, Orders[Product Quantity] * (RELATED(Products[Sale Price]) - RELATED(Products[Cost Price])))

Total Customers = DISTINCTCOUNT(Orders[User ID])

Total Quantity = COUNT(Orders[Product Quantity])

Profit YTD = TOTALYTD(SUMX(Orders, Orders[Product Quantity] * (RELATED(Products[Sale Price]) - RELATED(Products[Cost Price]))), 'Date Table'[Date])

Revenue YTD = CALCULATE (TOTALYTD (SUMX (FILTER (Orders,Orders[Order Date] <= MAX ( 'Date Table'[Date])),
                              Orders[Product Quantity] * RELATED ( Products[Sale Price] )),
                        'Date Table'[Date]))
#### Hierarchies
Two hierarchies have been established: Year and Geography. This allows for the ability to delve deeper into the data and conduct detailed analysis in our report.

![image](https://github.com/awwal85/data-analytics-power-bi-report814/assets/114372396/f1f21506-56a5-4761-bd9e-dfa3af26ed7f)
![image](https://github.com/awwal85/data-analytics-power-bi-report814/assets/114372396/a072535f-1d08-441e-84fb-8db87c758e2d)

## Reports
The report consists of six comprehensive pages, each dedicated to providing detailed information on our customers, products, and stores. 
Additionally, it includes an Executive Summary and a Stores Drillthrough and Toltip pages, which offers further insight into our various store locations for an enhanced understanding of our business. Each page has a navigation bar to enable users move between pages.

#### Executive Summary
This page provides a comprehensive overview of the overall performance of the company. The visual representations on the dashboard showcase the total revenue, profit, and orders. The donut chart offers a quick glance at revenue breakdown by country and store type. Additionally, the line chart presents a timeline view of total revenue for each month, quarter, and year. Furthermore, the bar chart displays total orders categorized by product category, while the table ranks products based on their total orders. Moreover, key performance indicators (KPIs) have been included for quarterly revenue, profit, and orders with a targeted growth rate of 5%. These figures were derived using DAX formulas to compute the previous quarter's revenue, orders, and profit.

Previous Quarter Ordeers = CALCULATE([Total orders], PREVIOUSQUARTER('Date Table'[Date]))

Previous Quarter Profit = CALCULATE([Total Profit], PREVIOUSQUARTER('Date Table'[Date]))

Previous Quarter Revenue = CALCULATE([Total Revenue], PREVIOUSQUARTER('Date Table'[Date]))

#### Customer Detail 
In order to get a quick understanding of the customer base, I have developed card visuals that showcase unique customers and their corresponding revenue, as well as the number of orders and revenue for our top customer. The line chart and bar charts provide a comprehensive look into the impact of our products on past customer behaviour. Additionally, a donut chart has been utilized to highlight which regions yield the highest sales. Furthermore, a table has been generated outlining the top 10 customers based on revenue. The DAX formula: 'Measures Table.'[Total Revenue]/'Measures Table.'[Total Customers] gives the revenue per customer measure.

#### Product Detail 
This page offers an overview of our product performance. The report includes three (3) gauges illustrating the current quarter's orders, revenue, and profit in comparison to their respective targets. Additionally, a table featuring the top 10 current products and a scatter plot displaying each product's contribution to company profit have been included. A line chart has also been utilized to depict the trend of our target revenue over the years. The product and country selection are achieved using the DAX formulas below.

Category Selection = IF(ISFILTERED(Products[Category]), SELECTEDVALUE(Products[Category]), "No Selection")

Country Selection = IF(ISFILTERED(Stores[Country]), SELECTEDVALUE(Stores[Country]), "No Selection")

#### Stores Map
The Stores map page displays the year-to-date profit for all of our business locations. This feature includes a country slicer, allowing for easy access to specific store performance in any location.

#### Stores Drillthrough
This page features a card visual showcasing store locations, accompanied by gauges displaying profit and revenue YTD alongside their corresponding targets. This allows for a simple comparison of each location's performance against its targets in terms of profit and revenue. Additionally, the column chart provides insights into customer purchasing patterns across different locations. For further insight, the table highlights the top five highest-earning products based on revenue.

#### Stores Tooltip
To ensure our users have a thorough understanding of each store's year-to-date profit performance in relation to the set target, I have implemented a personalized tooltip feature using the profit gauge visual. This means that when hovering over any location, the tool will display both the YTD profit and its corresponding target.

## SQL Queries
#### Connection to data
The data was stored on a Postgres database hosted on Microsoft Azure. As such, I connected to it using code in VS Code.

#### Queries and database
The queries serve as the answers to the five business insight enquiries.

1. #### How many staff are there in all of the UK stores?
   
   SELECT SUM(staff_numbers)
   
   FROM dim_store
   #### Answer: 20780

   
3.  #### Which month in 2022 has had the highest revenue?
   
    SELECT  dim_date.month_name:: text,  orders.total_orders, dim_date.year 

    FROM  orders, dim_date

    WHERE dim_date.year::text LIKE '%22'

    GROUP BY month_name::text, total_orders, dim_date.year

    ORDER BY month_name::text, total_orders DESC

    LIMIT 1;
    #### Answer: April
    

   
4. #### Which German store type had the highest revenue for 2022?
   
   SELECT orders.store_code::text, orders.total_orders, country_region.country::text, dim_date.year 

   FROM orders, country_region, dim_date

   WHERE dim_date.year::text LIKE '%22' AND country::text LIKE 'Ge%'

   GROUP BY country::text, store_code::text, total_orders, dim_date.year

   ORDER BY country::text, total_orders DESC

   LIMIT 1;
   #### Answer:
   
   
6. #### Create a view where the rows are the store types and the columns are the total sales, percentage of total sales and the count of orders
   
   SELECT orders.total_orders, forview.percentage_of_sales, test_store_overviews_2.totalled_sales, forquerying2.store_type

   FROM orders, forview, test_store_overviews_2, forquerying2

   GROUP BY total_orders, percentage_of_sales, store_type
   #### Answer:
   
   
8. ####  Which product category generated the most profit for the "Wiltshire, UK" region in 2021?
   SELECT forview.category, test_store_overviews_2.totalled_sales, forview.full_region::text, dim_date.year 

   FROM test_store_overviews_2, orders, forview, dim_date
    
   WHERE dim_date.year::text LIKE '%21' AND full_region LIKE 'Wiltshire, UK'

   GROUP BY category, full_region::text, dim_date.year, totalled_sales, total_orders

   ORDER BY total_orders DESC

   LIMIT 1;
   #### Answer:
