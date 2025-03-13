-- Data Cleaning Using SQL
SELECT * FROM world_layoffs.layoffs;

CREATE TABLE layoff_staging
LIKE layoffs;

 
 INSERT layoff_staging
 SELECT * FROM layoffs;
 
SELECT * FROM world_layoffs.layoff_staging;

-- Removing duplicates via row_number and windows function
WITH duplicate_cte AS
(
SELECT *, 
ROW_NUMBER() OVER (PARTITION BY company, location, industry , total_laid_off ,percentage_laid_off, `date`, stage, country, funds_raised) AS row_num
FROM layoff_staging
)
SELECT * 
FROM duplicate_cte
WHERE row_num>1;

CREATE TABLE `layoff_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` bigint DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised` bigint DEFAULT NULL,
  `row_num` int 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO layoff_staging2
SELECT *, 
ROW_NUMBER() OVER (PARTITION BY company, location, industry , total_laid_off ,percentage_laid_off, `date`, stage, country, funds_raised) AS row_num
FROM layoff_staging;

SELECT * FROM layoff_staging2
WHERE row_num>1;

SET SQL_SAFE_UPDATES = 1;


DELETE FROM layoff_staging2
WHERE row_num>1;

SELECT * FROM layoff_staging2;

-- Standardizing data (Finding issues and fixing them

UPDATE layoff_staging2
SET company = TRIM(company);

select distinct industry
from layoff_staging2
order by 1;

SELECT * FROM layoff_staging2;

select `date` ,
str_to_date(`date`,'%m/%d/%Y')
from layoff_staging2;

select `date` ,
substring(`date`,1,10)
from layoff_staging2;

UPDATE layoff_staging2
SET `date` = SUBSTRING(`date`, 1, 10);

select `date` ,
str_to_date(`date`,'%Y-%m-%d')
from layoff_staging2;

UPDATE layoff_staging2
SET `date` = str_to_date(`date`,'%Y-%m-%d');

ALTER TABLE layoff_staging2
MODIFY COLUMN `date` DATE;

select DISTINCT industry 
from layoff_staging2;

select * from layoff_staging2
where industry is null
or industry = '';

select * from layoff_staging2
where company = 'Appsmith';

select * from layoff_staging2;

select location
from layoff_staging2;

select loaction , TRIM(location);

SELECT 
    TRIM(SUBSTRING_INDEX(REPLACE(REPLACE(location, '[', ''), ']', ''), ',', 1)) AS location
FROM layoff_staging2;

UPDATE layoff_staging2 
SET location = TRIM(SUBSTRING_INDEX(REPLACE(REPLACE(location, '[', ''), ']', ''), ',', 1));


UPDATE layoff_staging2
SET location = TRIM(BOTH '''' FROM location);

ALTER TABLE layoff_staging2
DROP COLUMN row_num;

select * from layoff_staging2;

select distinct industry 
from layoff_staging2;

select * 
from layoff_staging2
where location='Mumbai';

select count(*) from layoff_staging2;
