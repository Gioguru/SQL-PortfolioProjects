SELECT *
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
order by 3,4


SELECT *
FROM PortfolioProject..CovidVaccinations
order by 3,4



SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
order by 1,2


Select count(total_deaths)
FROM PortfolioProject..CovidDeaths

-- WE look at Total Cases vs Total Deaths

SELECT Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
Where location LIKE '%states%'
order by 1,2

-- Looking at Total Cases vs Population

--This Code Shows What Percentage Of Population Got Covid

SELECT Location, date, total_cases,Population, (total_cases/Population)*100 as PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
-- Where location LIKE '%states%'
WHERE continent IS NOT NULL
order by 1,2


-- Sorting Countries with the Highest Infection Rate compared to Population

SELECT Location,Population,MAX(total_cases) as HighestInfectionCount, MAX((total_cases/Population))*100 as PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location,population
ORDER BY PercentPopulationInfected DESC



--Showing Countries with Highest Death Count per Population

SELECT continent,MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC

--LET'S BREAK THINGS DOWN BY CONTINENT


--Showing Continents with the highest death count per population


SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC


-- GLOBAL NUMBERS 

SELECT SUM(new_cases)as total_cases, SUM(cast(new_deaths as int)) as total_deaths, 
SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
--Where location LIKE '%states%'
WHERE continent is not null
--GROUP BY date
order by 1,2


--Looking at Total Population Vs Vaccinations

with PopvsVac (Continent, Location, Date, Population,New_Vaccinations, RollingPeopleVaccinated)
as
(

SELECT dea.continent, dea.location,dea.date,dea.population, vac.new_vaccinations
,SUM(cast(vac.new_vaccinations as int) ) OVER (Partition by dea.location order by dea.location, dea.date)
as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3
)
select *, (RollingPeopleVaccinated/Population)*100
from PopvsVac



--TEMP TABLE

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar (255),
Location nvarchar (255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)


INSERT INTO #PercentPopulationVaccinated
Select dea.continent, dea.location,dea.date,dea.population, vac.new_vaccinations
,SUM(cast(vac.new_vaccinations as int) ) OVER (Partition by dea.location order by dea.location, dea.date)
as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
--WHERE dea.continent IS NOT NULL
--ORDER BY 2,3
	
select *, (RollingPeopleVaccinated/Population)*100
from #PercentPopulationVaccinated


--Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location,dea.date,dea.population, vac.new_vaccinations
,SUM(cast(vac.new_vaccinations as int) ) OVER (Partition by dea.location order by dea.location, dea.date)
as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3

SELECT *
FROM PercentPopulationVaccinated