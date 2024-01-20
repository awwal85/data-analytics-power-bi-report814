# Data Analytics-Power BI-Report814

## Data Loading
### Orders Table
This table has been loaded through Azure SQL Database. The Order Date and Shipping Date columns have been divided into individual Date and Time columns.
In order to preserve data integrity, any rows with null or missing values in the new Date column have been eliminated.
Additionally, for the sake of data privacy, the Card Number column has also been removed.

### Product Table
This is a comma-separated values (CSV) file, which can be loaded using the CSV/text icon located on the home tab.
To ensure the uniqueness of each product, I have eliminated any duplicate entries from the product code column.
Additionally, the weight column has been split into separate Values and Units columns.
The data type for the Values column has been changed to decimals, and all measurements in grams or milliliters have been converted to kilograms for consistency.

### Stores Table
The file is accessed by connecting to Azure Bob storage with the appropriate credentials.
The columns have been renamed to align with Power BI's naming conventions.
