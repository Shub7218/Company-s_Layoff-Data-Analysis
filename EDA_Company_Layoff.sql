-- Exploratory Data Analysis

select * from layoff_staging2;

select count(company) from layoff_staging2;

select * from layoff_staging2
where total_laid_off = 
(select MAX(total_laid_off) 
from layoff_staging2);

select * from layoff_staging2
where percentage_laid_off=1;

select company , SUM(total_laid_off)
from layoff_staging2
group by company
order by 2 desc;

select MIN(`date`), MAX(`date`)
from layoff_staging2;

select industry , SUM(total_laid_off)
from layoff_staging2
group by industry
order by 2 desc;

select country , SUM(total_laid_off)
from layoff_staging2
group by country
order by 2 desc;

select `date` , SUM(total_laid_off)
from layoff_staging2
group by `date`
order by 2 desc;

select stage , SUM(total_laid_off)
from layoff_staging2
group by stage
order by 2 desc;

select substring(`date`, 1, 7) AS `MONTH` , SUM(total_laid_off)
from layoff_staging2
WHERE substring(`date`, 1, 7) is not null
group by `MONTH`
order by 1 ASC;

with Rolling_total AS 
(
select substring(`date`, 1, 7) AS `MONTH` , SUM(total_laid_off) as monthly_layoff
from layoff_staging2
WHERE substring(`date`, 1, 7) is not null
group by `MONTH`
order by 1 ASC
)
SELECT `MONTH` , monthly_layoff , SUM(monthly_layoff) over(ORDER BY `MONTH`) AS rolling_sum
from Rolling_total;


select company ,YEAR(`date`),  SUM(total_laid_off)
from layoff_staging2
group by company, YEAR(`date`)
order by company ASC;

with company_year (company , years,total_laid_off)  as
(
select company ,YEAR(`date`),  SUM(total_laid_off)
from layoff_staging2
group by company, YEAR(`date`)
), Company_year_ranking as
(
select *,
dense_rank() OVER(partition by years order by total_laid_off desc) as ranking
from company_year
)
select * 
from Company_year_ranking
where ranking <= 5
;
