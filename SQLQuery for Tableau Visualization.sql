/*
SQL Queries used for Tableau Project
*/

--1
Select sum(new_cases)as total_cases,sum(cast(new_deaths as int)) as total_deaths,Round((sum(cast(new_deaths as int))/sum(new_cases))*100,2) As Death_Percentage 
from PortfolioProject..[Death by Covid]
--Where location = 'India'
where continent is not null
--group by date
order by 1,2

---2
--taken these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe


select location, sum(convert(int,new_deaths)) as TotalDeath
from PortfolioProject..[Death by Covid]
where continent is null and location not in ('World','European Union','International')
group by location
Order by TotalDeath DESC

---3
select location, population, max(total_cases) as HighestInfecioncount, MAx((total_cases/population))*100 as PercentPopulaionInfected
from PortfolioProject..[Death by Covid]
group by location,population
order by PercentPopulaionInfected desc

----4
select location, population, date, max(total_cases) as HighestInfecioncount, MAx((total_cases/population))*100 as PercentPopulaionInfected
from PortfolioProject..[Death by Covid]
group by location,population, date
order by PercentPopulaionInfected desc
