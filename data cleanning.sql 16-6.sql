-- SQL Project - Data Cleaning

-- https://www.kaggle.com/datasets/swaptr/layoffs-2022


-- now when we are data cleaning we usually follow a few steps
-- 1. check for duplicates and remove any
-- 2. standardize data and fix errors
-- 3. Look at null values and see what 
-- 4. remove any columns and rows that are not necessary - few ways

SELECT 
    *
FROM
    layoffs;
   -- ----------------------------------------------------------------------------
   
   
-- 1. Remove Duplicates

-- # First let's check for duplicates
SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs;

With duplacte_cte AS
(
SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs
)

SELECT *
FROM duplacte_cte
WHERE row_num > 1;

-- let's just look at Casper to confirm if its dupliccated
SELECT * 
FROM layoffs
Where company = 'Casper';

-- Delete duplicate
With duplacte_cte AS
(
SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs
)

delete
FROM duplacte_cte
WHERE row_num > 1;
-- ----
SELECT * 
FROM layoffs
Where company = 'Casper';
-- Since MySQL does not allow deleting directly from a CTE, so cerate new tabel 
CREATE TABLE `layoffs2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` bigint DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * 
FROM layoffs2;

INSERT into layoffs2
SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs;

SELECT * 
FROM layoffs2
where row_num >= 2;

delete 
FROM layoffs2
where row_num >= 2;

SELECT * 
FROM layoffs2
Where company = 'Casper';


-- -------------------------------------------------------------------------------------------------------


-- 2. Standardize Data <<dinding issuses and fix it>>


-- The TRIM function in SQL is used to remove leading and trailing spaces from a string.
SELECT company, TRIM(company)
from layoffs2;

UPDATE layoffs2
SET company = TRIM(company);


--  3 Standardize industri Colum , Updating industry names to 'Crypto' for consistency , -- Verifying the updates


-- Updating industry names to 'Crypto' for consistency
SELECT *
FROM layoffs2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs2
SET industry = 'Crypto'
WHERE industry IN ('Crypto Currency', 'CryptoCurrency');



-- Standardize industri Colum 

SELECT DISTINCT industry
FROM layoffs2;
-- everything looks good except apparently we have some "United States" and some "United States." with a period at the end. Let's standardize this.
SELECT DISTINCT country
FROM layoffs2
ORDER BY country;

UPDATE layoffs2
SET country = TRIM(TRAILING '.' FROM country);

-- now if we run this again it is fixed

SELECT DISTINCT country
FROM layoffs2;



-- Let's also fix the date columns with the converted date values
SELECT `date`
FROM layoffs2;

SELECT `date`
,STR_TO_DATE(`date`, '%m/%d/%y') 
FROM layoffs2;

update layoffs2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

alter table layoffs2
MODIFY column `date` DATE;




-- populate null or blank  colums


SELECT *
from layoffs2
where total_laid_off is null 
and percentage_laid_off is null;

SELECT *
from layoffs2
where industry is null 
OR industry = '';

SELECT *
from layoffs2
where company = 'Airbnb'; 

-- it looks like airbnb is a travel, but this one just isn't populated.
-- I'm sure it's the same for the others. What we can do is
-- write a query that if there is another row with the same company name, it will update it to the non-null industry values
-- makes it easy so if there were thousands we wouldn't have to manually check them all


-- we should set the blanks to nulls since those are typically easier to work with

UPDATE layoffs2
SET industry = NULL
WHERE industry = '';

-- now if we check those are all null

SELECT *
from layoffs2
where industry is null 
OR industry = '';


-- now we need to populate those nulls if possible
SELECT 
    t1.company,
    t1.industry,
    t2.industry 
FROM 
    layoffs2 t1
JOIN 
    layoffs2 t2
ON t1.company = t2.company
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

UPDATE 
	layoffs2 t1
JOIN 
	layoffs2 t2
ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

SELECT *
from layoffs2
where company = 'Airbnb'; 

-- --------------------------------------------------------------------------------
-- 4. remove any columns and rows we need to

SELECT *
FROM layoffs2
WHERE total_laid_off IS NULL;

SELECT *
FROM layoffs2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- Delete Useless data we can't really use
DELETE FROM layoffs2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT * 
FROM layoffs2;
ALTER TABLE layoffs2
DROP COLUMN row_num;

SELECT * 
FROM layoffs2;







