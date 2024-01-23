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

![image](https://github.com/awwal85/data-analytics-power-bi-report814/assets/114372396/ed64a49c-4410-4c07-864a-abc7d80970d7)

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
Two hierarchies have been established: Year and Geography. This allows for the ability to delve deeper into the data and conduct
![image](https://github.com/awwal85/data-analytics-power-bi-report814/assets/114372396/a072535f-1d08-441e-84fb-8db87c758e2d)
![image](https://github.com/awwal85/data-analytics-power-bi-report814/assets/114372396/f1f21506-56a5-4761-bd9e-dfa3af26ed7f)

detailed analysis in our report.



