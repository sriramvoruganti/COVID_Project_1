--looking at total cases vs total deaths
--shows the likelihood of dying if you contracct covid in your country
select location , date , total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from Portfolio_Project_1..Covid_Deaths$
Where location like '%chad%'
order by 1,2


--Looking at total cases vs population
--shows % of population who got covid
select location , date , total_cases,population,(total_deaths/population)*100 as DeathPercentage
from Portfolio_Project_1..Covid_Deaths$
Where location like '%afghanistan%'
order by 1,2


-- LET'S BREAK THINGS DOWN BY CONTINENT
select location ,max(cast(total_deaths as int)) as totaldeathcount
from Portfolio_Project_1..Covid_Deaths$
WHERE continent is not null
Group by location
order by totaldeathcount desc


--Showing continents with highest death count per population

select continent ,max(cast(total_deaths as int)) as totaldeathcount
from Portfolio_Project_1..Covid_Deaths$
WHERE continent is not null
Group by continent
order by totaldeathcount desc

--GLOBAL NUMBERS

select  sum(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths , SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
--,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from Portfolio_Project_1..Covid_Deaths$
--Where location like '%chad%'
WHERE continent is not null
--Group by date
order by 1,2

-- LOOKING AT TOTAL POPULATION VS VACCINATIONS
select dea.continent , dea.location , dea.date , dea.population, vac.new_vaccinations , SUM(convert(int,vac.new_vaccinations)) over (Partition by dea.location order by dea.location , dea.date)


from Portfolio_Project_1..Covid_Deaths$ dea
join Portfolio_Project_1..Covid_Vaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3



--Use CTE
with popvsvac (continent , location , date , population , RollingPeopleVaccinated)

--Countries with Highest Infection Rate compared to Population
select location  ,population ,max(total_cases) as HighestInfectionCount,max(total_cases/population)*100 as PercentPopulationInfected
from Portfolio_Project_1..Covid_Deaths$
--Where location like '%chad%'
Group by location , population
order by PercentPopulationInfected desc

--Showing a counties with highest Death count per population
select location ,max(cast(total_deaths as int)) as totaldeathcount
from Portfolio_Project_1..Covid_Deaths$
WHERE continent is not null
Group by location 
order by totaldeathcount desc


