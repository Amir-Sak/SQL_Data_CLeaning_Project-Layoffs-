# SQL_Data_CLeaning_Project-Layoffs-
This SQL project cleans data in the 'layoffs' table, removing duplicates, standardizing entries, handling null values, and removing unnecessary columns/rows, ensuring data integrity for analysis.
Data Cleaning (Continued):

After removing duplicates, I will standardize the data to ensure consistency and coherence.
This involves addressing issues such as null or blank values in the dataset and correcting any inconsistencies in column values.
Remove Duplicates:

I've identified duplicates in the dataset based on specific columns such as company, location, industry, total laid off, percentage laid off, date, stage, country, and funds raised.
I will delete duplicate entries to ensure the integrity of the data and avoid redundancy.
Standardize Data:

I will standardize column values, such as company names, by removing leading and trailing spaces or converting them to a consistent format.
Additionally, I'll update industry names for consistency and standardize country names.
Handle Null or Blank Values:

Next, I'll address null or blank values in the dataset. This involves identifying columns with missing values and deciding how to handle them.
For instance, I may replace null values with appropriate default values or delete rows with missing critical information, depending on the context.
Data Verification:

After cleaning and standardizing the data, I'll verify the changes to ensure accuracy and completeness.
This includes checking for any remaining inconsistencies or errors and validating the data against the original source or business requirements.

SQL Project Roadmap: Data Cleaning for layoffs Dataset Roadmap 

1. Remove Duplicates
   
Identified duplicates based on company, location, industry, etc.
Deleted duplicates from the layoffs table using a staging table approach due to MySQL constraints on deleting directly from CTEs.

2. Standardize Data and Fix Errors
   
Trimmed leading and trailing spaces from the company column using TRIM().
Standardized the industry column:
Updated industry names to 'Crypto' for consistency (Crypto Currency to Crypto).
Standardized the country column:
Removed trailing periods from country names.
Converted the date column to a consistent date format ('%m/%d/%Y').

3. Handle Null Values
Identified and handled null or blank values:
Populated null values in the industry column where possible by matching with non-null values from the same company.
Set blank values in the industry column to null to facilitate easier handling.

4. Remove Unnecessary Columns and Rows
   
Removed rows where total_laid_off and percentage_laid_off are both null.
Deleted rows containing useless data that cannot be utilized further.
Project Outcome
Cleaned and standardized the layoffs dataset (layoffs2 table) for further analysis.
Ensured consistency in data formats and completeness by handling null values and fixing errors.

Next Steps

Perform exploratory data analysis (EDA) to gain insights into layoff trends by industry, location, and time.

Create visualizations and reports based on cleaned data to communicate findings effectively.
