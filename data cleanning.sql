-- SQL Project - Data Cleaning

SELECT 
    *
FROM
    layoffs;
-- Remove  Duplicates
-- Standarize the Data
-- Null values or Blanks
-- Rmove any colums

-- create duplication in case of prevention
CREATE TABLE layoffs_test LIKE layoffs;

SELECT 
    *
FROM
    layoffs_test;
    
INSERT layoffs_test
SELECT *
FROM layoffs;
-- -------------------------------------------------------------------
-- 1. Remove Duplicates

# First let's check for duplicates

SELECT *
FROM  world_layoffs.layoffs_test;
SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM world_layoffs.layoffs_test;

With duplacte_cte AS
(
SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM world_layoffs.layoffs_test
)

SELECT *
FROM duplacte_cte
WHERE row_num > 1;
-- let's just look at Casper to confirm if its dupliccated
SELECT * 
FROM world_layoffs.layoffs_test
Where company = 'Casper';

-- there is defrnnce betwin sql mic an mysql to delet duplicate
-- delete duplicat
With duplacte_cte AS
(
SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM world_layoffs.layoffs_test
)

SELECT *
FROM duplacte_cte
WHERE row_num > 1;
-- let's just look at Casper to confirm if its dupliccated
SELECT * 
FROM world_layoffs.layoffs_test
Where company = 'Casper';

-- one solution, which I think is a good one. Is to create a new column and add those row numbers in. Then delete where row numbers are over 2, then delete that column
-- so let's do it!!

CREATE TABLE `layoffs_test2` (
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
FROM world_layoffs.layoffs_test2;

INSERT into world_layoffs.layoffs_test2
SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM world_layoffs.layoffs_test;

SELECT * 
FROM world_layoffs.layoffs_test2
where row_num >1;
--  to check Statement then we delete and 
-- enable save mode SET SQL_SAFE_UPDATES = 0;

SET SQL_SAFE_UPDATES = 0;

DELETE  
FROM world_layoffs.layoffs_test2
where row_num > 1;
-- donne 
SELECT * 
FROM world_layoffs.layoffs_test2
where row_num >1;
SET SQL_SAFE_UPDATES = 1;
-- ------------------------------------------------------------------------------------------------
-- 2. Standardize Data <<dinding issuses and fix it>>

SELECT company, TRIM(company)
from layoffs_test2;

SET SQL_SAFE_UPDATES = 0;

UPDATE layoffs_test2
set company = TRIM(company);

--  3 Standardize industri Colum , Updating industry names to 'Crypto' for consistency , -- Verifying the updates

SELECT *
FROM layoffs_test2
WHERE industry LIKE 'Crypto%';

SET SQL_SAFE_UPDATES = 1;
UPDATE layoffs_test2
SET industry = 'Crypto'
WHERE industry IN ('Crypto Currency', 'CryptoCurrency');

SELECT DISTINCT industry
FROM layoffs_test2;
-- everything looks good except apparently we have some "United States" and some "United States." with a period at the end. Let's standardize this.
SELECT DISTINCT country
FROM layoffs_test2
ORDER BY country;


UPDATE layoffs_test2
SET country = TRIM(TRAILING '.' FROM country);

SELECT DISTINCT country
FROM layoffs_test2;

-- Let's also fix the date columns with the converted date values

SELECT `date`
,STR_TO_DATE(`date`, '%m/%d/%y') 
FROM layoffs_test2;

update layoffs_test2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

alter table layoffs_test2
MODIFY column `date` DATE;
-- populate null or blank  colums
SELECT *
from layoffs_test2
where total_laid_off is null 
and percentage_laid_off is null;

SELECT *
from layoffs_test2
where industry is null 
OR industry = '';

SELECT *
from layoffs_test2
where company = 'Airbnb'; 

-- it looks like airbnb is a travel, but this one just isn't populated.
-- I'm sure it's the same for the others. What we can do is
-- write a query that if there is another row with the same company name, it will update it to the non-null industry values
-- makes it easy so if there were thousands we wouldn't have to manually check them all
-- we should set the blanks to nulls since those are typically easier to work with



UPDATE world_layoffs.layoffs_test2
SET industry = NULL
WHERE industry = '';
select *
from layoffs_test2 T1
join layoffs_test2 t2
	on T1.company = T2.company
    AND T1.location = T2.location
 where (T1.industry is null or T1.industry = '')
 AND T2.industry is not null;


select T1.industry, T2.industry
from layoffs_test2 T1
join layoffs_test2 t2
	on T1.company = T2.company
    AND T1.location = T2.location
 where (T1.industry is null or T1.industry = '')
 AND T2.industry is not null;

UPDATE layoffs_test2 T1
	join layoffs_test2 t2
	 ON T1.company = T2.company
SET  T1.industry = T2.industry
where T1.industry is null 
AND T2.industry is not null;
UPDATE layoffs_test2
SET industry = (SELECT industry FROM layoffs_test);

-- 4. remove any columns and rows we need toSELECT * 
SELECT *
from layoffs_test2
	WHERE total_laid_off is null
	And percentage_laid_off is null;
    
DELETE 
from layoffs_test2
	WHERE total_laid_off is null
	And percentage_laid_off is null;
    
SELECT *
from layoffs_test2;

alter table layoffs_test2
drop column row_num;








