Use PorfolioProject

--Select * from [Covid Vaccine]
--order by 3,4
--Select * from [Death by Covid]
--order by 3,4
--Data I used for Portfolio
Select location,date,total_cases,new_cases,total_deaths, population 
from [Death by Covid]
order by 1,2

--Total Cases vs Total Deaths
--Shows the chances of death due to covid infection
Select location,date,total_cases,total_deaths,Round((total_deaths/total_cases)*100,2) As Percentage_of_Death 
from [Death by Covid]
Where location = 'India'
order by 1,2

--Total Cases vs Total Population
--Shows Percentage of populaion got infectecd
Select location,date,total_cases,population,Round((total_cases/population)*100,2) As Infection_Perentage 
from [Death by Covid]
Where location = 'India'
order by 1,2
-----Looking at Countries with highes infection rate
Select location,population,Max(total_cases) as Highest_inf_rate, Max(Round((total_cases/population)*100,2)) As Percent_of_Infection 
from [Death by Covid]
group by population,location
order by Percent_of_Infection Desc

-----Countries with highest death count per population
Select location,Max(cast (total_deaths as Int)) as TotalDeathCount 
from [Death by Covid]
where continent is not Null
group by location
order by TotalDeathCount Desc

---Total Death count by loaction
Select location,Max(cast (total_deaths as Int)) as TotalDeathCount 
from [Death by Covid]
where continent is  Null
group by location
order by TotalDeathCount Desc

------ Explore by Continent
--Display continent with highest death count per population
Select continent,Max(cast (total_deaths as Int)) as TotalDeathCount 
from [Death by Covid]
where continent is not Null
group by continent
order by TotalDeathCount Desc


---Global Numbers
Select sum(new_cases)as total_cases,sum(cast(new_deaths as int)) as total_deaths,Round((sum(cast(new_deaths as int))/sum(new_cases))*100,2) As Death_Percentage 
from [Death by Covid]
--Where location = 'India'
where continent is not null
--group by date
order by 1,2

---Looking at total population vs vaccinations

Select d.continent,d.location,d.date, d.population, v.new_vaccinations,
sum(cast(v.new_vaccinations as int)) over(partition by d.location order by d.location, d.date) as RollingPeopleVaccinated,
--(RollingPeopleVaccinated/v.population)*100
 from [Death by Covid] d
join [Covid Vaccine] v 
	on d.location =v.location and
	d.date= v.date
Where d.continent is not null
order by 2,3

--USE CTE
with PopvsVac(continent,location, date,population,new_vaccinations,RollingPeopleVaccinated)
as(
Select d.continent,d.location,d.date, d.population, v.new_vaccinations,
sum(cast(v.new_vaccinations as int)) over(partition by d.location order by d.location, d.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/v.population)*100
 from [Death by Covid] d
join [Covid Vaccine] v 
	on d.location =v.location and
	d.date= v.date
Where d.continent is not null
--order by 2,3
) select *, (RollingPeopleVaccinated/population)* 100 as Percentage_Vacc from PopvsVac

---Temp Table
Drop Table if exists #PopulationgotVaccinated
create table #PopulationgotVaccinated
(continent nvarchar(255),
location nvarchar(255), 
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into #PopulationgotVaccinated
Select d.continent,d.location,d.date, d.population, v.new_vaccinations,
sum(convert(int,v.new_vaccinations)) over(partition by d.location order by d.location, d.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/v.population)*100
 from [Death by Covid] d
join [Covid Vaccine] v 
	on d.location =v.location and
	d.date= v.date
Where d.continent is not null
--order by 2,3
select *, (RollingPeopleVaccinated/population)* 100 as Percentage_Vacc from #PopulationgotVaccinated

----Creating View to store data for visualization

create view PercentofpopulationVaccinated
as
Select d.continent,d.location,d.date, d.population, v.new_vaccinations,
sum(convert(int,v.new_vaccinations)) over(partition by d.location order by d.location, d.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/v.population)*100
 from [Death by Covid] d
join [Covid Vaccine] v 
	on d.location =v.location and
	d.date= v.date
Where d.continent is not null
--order by 2,3

Select * from PercentofpopulationVaccinated