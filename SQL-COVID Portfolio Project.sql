--USE PortfolioProjects

--SELECT *
--FROM PortfolioProjects..CovidDeaths
--ORDER BY 3,4

--SELECT *
--FROM PortfolioProjects..CovidVaccinations
--ORDER BY 3,4

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProjects..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1, 2

-- Looking at Total Cases vs Total Deaths

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProjects..CovidDeaths
WHERE location = 'India'
ORDER BY 1, 2

-- Looking at Total Cases vs population

SELECT location, date, population, total_cases, (total_cases/population)*100 as PercentagePopulationInfected
FROM PortfolioProjects..CovidDeaths
--WHERE location = 'India'
ORDER BY 1, 2

-- Looking at Countries with highest infection rate compared to population

SELECT location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentagePopulationInfected
FROM PortfolioProjects..CovidDeaths
--WHERE location = 'India'
GROUP BY location, population
ORDER BY PercentagePopulationInfected DESC

-- Looking at Countries with highest death count per population

SELECT location, MAX(CAST(total_deaths as int)) as TotalDeathCount
FROM PortfolioProjects..CovidDeaths
--WHERE location = 'India'
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC

-- Breaking the data by Continent
--Showing Continents with highest death counts

--SELECT location, MAX(CAST(total_deaths as int)) as TotalDeathCount
--FROM PortfolioProjects..CovidDeaths
----WHERE location = 'India'
--WHERE continent IS NULL
--GROUP BY location
--ORDER BY TotalDeathCount DESC

SELECT continent, MAX(CAST(total_deaths as int)) as TotalDeathCount
FROM PortfolioProjects..CovidDeaths
--WHERE location = 'India'
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC

-- GLOBAL NUMBERS

SELECT date, SUM(new_cases) as total_cases, SUM(CONVERT(int, new_deaths)) as total_deaths, SUM(CONVERT(int, new_deaths))/SUM(new_cases)*100 as DeathPercentage
FROM PortfolioProjects..CovidDeaths
-- WHERE location = 'India'
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1, 2

-- Overall death percentage

SELECT SUM(new_cases) as total_cases, SUM(CONVERT(int, new_deaths)) as total_deaths, SUM(CONVERT(int, new_deaths))/SUM(new_cases)*100 as DeathPercentage
FROM PortfolioProjects..CovidDeaths
-- WHERE location = 'India'
WHERE continent IS NOT NULL
--GROUP BY date
ORDER BY 1, 2

--  Looking at Total population vs Vaccinations
-- Use CTE

WITH PopVsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as int)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProjects..CovidDeaths as dea
JOIN PortfolioProjects..CovidVaccinations as vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3
)
SELECT *, (RollingPeopleVaccinated/Population)*100 as PercentPeopleVaccinated
FROM PopVsVac;


----WITH PopVsVacTest (Continent, Location, Population, New_Vaccinations, RollingPeopleVaccinated)
----AS
----(
----SELECT dea.continent, dea.location, dea.population, vac.new_vaccinations
----, SUM(CAST(vac.new_vaccinations as int)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
----FROM PortfolioProjects..CovidDeaths as dea
----JOIN PortfolioProjects..CovidVaccinations as vac
----	ON dea.location = vac.location
----	--AND dea.date = vac.date
----WHERE dea.continent IS NOT NULL
------ORDER BY 2,3
----)
----SELECT MAX((RollingPeopleVaccinated/Population)*100) as PercentPeopleVaccinated
----FROM PopVsVacTest
------GROUP BY Continent, Location, Population, New_Vaccinations, RollingPeopleVaccinated


-- Use TEMP Table

DROP TABLE if exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccination numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as int)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProjects..CovidDeaths as dea
JOIN PortfolioProjects..CovidVaccinations as vac
	ON dea.location = vac.location
	AND dea.date = vac.date
--WHERE dea.continent IS NOT NULL
--ORDER BY 2,3

SELECT *, (RollingPeopleVaccinated/Population)*100 as PercentPeopleVaccinated
FROM #PercentPopulationVaccinated;


-- Creating VIEW to store data for later visualization

CREATE VIEW PercentPopulationVaccinated
AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as int)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProjects..CovidDeaths as dea
JOIN PortfolioProjects..CovidVaccinations as vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3

SELECT * 
FROM PercentPopulationVaccinated

SELECT *
FROM PercentPopulationVaccinated