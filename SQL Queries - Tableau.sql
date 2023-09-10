-- SQL QUERIES for VISUALIZATION

-- 1)
-- Overall death percentage

SELECT SUM(new_cases) as total_cases, SUM(CONVERT(int, new_deaths)) as total_deaths, SUM(CONVERT(int, new_deaths))/SUM(new_cases)*100 as DeathPercentage
FROM PortfolioProjects..CovidDeaths
-- WHERE location = 'India'
WHERE continent IS NOT NULL
--GROUP BY date
ORDER BY 1, 2

-- 2)
-- Total Death Count by Location, these data has been extracted as they are not included in above query
-- European Union is part of Europe

SELECT location, SUM(CAST(new_deaths as int)) as TotalDeathCount
FROM PortfolioProjects..CovidDeaths
--WHERE location = 'India'
WHERE continent IS NULL
AND location NOT IN ('World', 'European Union', 'International')
GROUP BY location
ORDER BY TotalDeathCount DESC


-- 3)
-- Looking at Countries with highest infection rate compared to population

SELECT location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentagePopulationInfected
FROM PortfolioProjects..CovidDeaths
--WHERE location = 'India'
GROUP BY location, population
ORDER BY PercentagePopulationInfected DESC


-- 4)
-- Looking at Countries with highest infection rate per day compared to population

SELECT location, population, date, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentagePopulationInfected
FROM PortfolioProjects..CovidDeaths
--WHERE location = 'India'
GROUP BY location, population, date
ORDER BY PercentagePopulationInfected DESC