#...Data Cleaing 
create database word_layoffs;
use word_layoffs;

SELECT * FROM layoffs_sql;

-- 1) Remove duplicateds
-- 2) Standardize the Data
-- 3) Null values and Blank values
-- 4) Remove any columns

create table layoffs_stages
like layoffs_sql;


select * from layoffs_staging;

insert layoffs_staging
select * from layoffs_sql;


-- remove duplicated values 



 with duplicated_cte
 as ( SELECT *, ROW_NUMBER() OVER (
           PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country,
         funds_raised_millions
         ) AS row_num
  FROM layoffs_staging
  )
  
select * from duplicated_cte
where row_num > 1;
-- create new table 

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
  
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


select * from layoffs_staging2;


  
-- insert all data 

  INSERT INTO layoffs_staging2 (
  company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions, row_num
)
SELECT 
  company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions,
  ROW_NUMBER() OVER (
    PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions
    ORDER BY company
  ) AS row_num
FROM layoffs_staging;

select * from layoffs_staging2
where row_num > 1;

-- now delete duplicated data

delete from layoffs_staging2
where row_num > 1;

set sql_safe_updates=0;

select * from layoffs_staging2
where row_num > 1;


select * from layoffs_staging2;


-- now all duplicated rows are deleted in our dataset

#....Standardizing Data

select distinct(company) from layoffs_staging2;

select company, (trim(company)) from layoffs_staging2;

update layoffs_staging2
set company = trim(company);

select * from layoffs_staging2;

select distinct industry from layoffs_staging2
order by 1;


select * from layoffs_staging2
where industry like 'crypto%';

update layoffs_staging2 
set industry = "crypto"
where industry = 'crypto%';

select distinct country, trim(trailing '.' from country)
from layoffs_staging2
order by 1;

#step 3) remove null and blank rows

-- delete null in total_laid_off columns

select * from layoffs_staging2
where total_laid_off is not null;

delete  from layoffs_staging2
where total_laid_off is null;

select * from layoffs_staging2;

-- now same delete null rows in percentage_laid_off columns
-- step 1) cheak null values in perecentage_laid_off columns

select * from layoffs_staging2
where percentage_laid_off is null;

-- step 2) now delete the all null rows in perecentage_laid_off columns
delete from layoffs_staging2
where percentage_laid_off is null;

select * from layoffs_staging2;

-- now replace null in specific values in funds_raised_millions columns ....

UPDATE layoffs_staging
SET total_laid_off = 0
WHERE total_laid_off IS NULL;



update layoffs_staging2
set  funds_raised_millions = ifnull(funds_raised_millions,0);

#Option 1: If you had a backup before update

UPDATE layoffs_staging2
SET funds_raised_millions = NULL
WHERE funds_raised_millions = 0;

select * from layoffs_staging2;
select company,
coalesce(location,industry,total_laid_off) as first_non_null from layoffs_staging2;


-- delete null rows in stage columns and date....?
-- stage columns
delete from layoffs_staging2
where stage is null;

-- date columns
delete from layoffs_staging2
where date is null;

select * from layoffs_staging2;
#Find Columns with Mostly NULLs........
 SELECT 
  COUNT(*) AS total_rows,
  SUM(CASE WHEN company IS NULL THEN 1 ELSE 0 END) AS null_company,
  SUM(CASE WHEN location IS NULL THEN 1 ELSE 0 END) AS null_location,
  SUM(CASE WHEN industry IS NULL THEN 1 ELSE 0 END) AS null_industry,
  SUM(CASE WHEN date IS NULL THEN 1 ELSE 0 END) AS null_date
FROM layoffs_staging;
#cheak for duplicated columns
SELECT COUNT(*) 
FROM layoffs_staging
WHERE company = location;

select * from layoffs_staging2
where industry is not null;

-- cheak for blank row 
select count(*) as blank_rows
from layoffs_staging2
where  trim(industry)= '';

-- delete blank rows in industry columns
delete from layoffs_staging2
where industry = '';

-- cheak for blank rows in date columns
select count(*) as blank_rows
from layoffs_staging2
where trim(date)= '';

-- now delete blank rows in date columns
delete from layoffs_staging2
where date = '';


select * from layoffs_staging2 limit 100;

#cheak for before cleaning data 

CREATE TABLE layoffs_cleaned AS
SELECT * FROM layoffs_staging;

select * from layoffs_cleaned


#now all data cleaning part in over in our data sets
