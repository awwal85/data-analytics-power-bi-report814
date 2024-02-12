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
Additionally, it includes an Executive Summary and a Stores Drillthrough and Toltip pages, which offers further insight into our various store locations for an enhanced understanding of our business.

#### Customer Detail page
In order to get a quick understanding of our customer base, I have developed card visuals that showcase unique customers and their corresponding revenue, as well as the number of orders and revenue for our top customer. The line chart and bar charts provide a comprehensive look into the impact of our products on past customer behaviour. Additionally, a donut chart has been utilized to highlight which regions yield the highest sales. Furthermore, a table has been generated outlining the top 10 customers based on revenue.

#### Product Detail page
This page offers an overview of our product performance. The report includes three (3) gauges illustrating the current quarter's orders, revenue, and profit in comparison to their respective targets. Additionally, a table featuring the top 10 current products and a scatter plot displaying each product's contribution to company profit have been included. A line chart has also been utilized to depict the trend of our target revenue over the years.


