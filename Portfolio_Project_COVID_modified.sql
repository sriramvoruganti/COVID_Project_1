SELECT location , date , total_cases , new_cases ,total_deaths, population
FROM Portfolio_Project_1..coviddeaths
ORDER BY location , date

--TOTAL CASES VS TOTAL DEATHS

SELECT location , population, max(total_cases) as Highest_Cases , max((total_cases/population))*100 as PercentPopulatedInfected
FROM Portfolio_Project_1..coviddeaths
--where location like '%States%'
group by location , population 
order by 1,2

--Total cases vs Population
Select location , date , population , total_cases , (total_cases/population)*100  as PeopleInfected
from Portfolio_Project_1..coviddeaths
order by 1,2

--Countries with highest infected rate compared to Population
select location , population , max(total_cases) as maxcases , max((total_cases/population)) as Maxpeopleinfected
from Portfolio_Project_1..coviddeaths
group by location , population
order by Maxpeopleinfected desc

--Calculating the countries with highest deaths
select location , max(cast(total_deaths as int)) as Maxdeaths 
from Portfolio_Project_1..coviddeaths
--where continent is not null
Group by location 
order by  Maxdeaths desc


--Showing contintents with the highest death count per population
select continent , max(cast(total_deaths as int)) as max_deaths_per_continent
from Portfolio_Project_1..coviddeaths
where continent is not null
group by continent
order by max_deaths_per_continent desc



--GLOBAL numbers

Select location ,  max((total_deaths/total_cases))*100  as DeathPercentage
from Portfolio_Project_1..coviddeaths
Group by location
order by DeathPercentage desc


-- Judging the number of cases per location , we are excluding World , since it is not a location
Select location , sum(new_cases)
from Portfolio_Project_1..coviddeaths
where not location = 'World' 
Group by location
order by sum(new_cases) desc

--Joining coviddeaths and covidvacinnations
select  dea.location  , sum(cast(total_vaccinations as int))
from Portfolio_Project_1..coviddeaths dea
join Portfolio_Project_1..covidvaccinations vac
on dea.location = vac.location	and
 dea.date = vac.date
 group by dea.location
 --The reason we used order by 2,3 is that we wanted to focus on arranging the 2nd and 3rd columns of the given data , which is the columns of location and date



 select dea.location , vac.new_vaccinations
from Portfolio_Project_1..coviddeaths dea
join Portfolio_Project_1..covidvaccinations vac
on dea.location = vac.location	and
 dea.date = vac.date
 group by dea.location


 With PopvsVac ( continent , Location, date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From Portfolio_Project_1..coviddeaths dea
Join Portfolio_Project_1..covidvaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac



---TEMP TABLES


DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From Portfolio_Project_1..coviddeaths dea
Join Portfolio_Project_1..covidvaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 1,2

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated

SELECT*
FROM  PercentPopulationVaccinated