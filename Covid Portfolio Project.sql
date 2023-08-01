Select *
From PortfolioProject..CovidDeaths
Order by 3,4


--Select *
--From PortfolioProject..CovidVaccination
--Order by 3,4

Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Order by 1,2

-- Looking at Total Cases vs Total Deaths
Select location, date, total_cases,total_deaths,
(CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0)) * 100 AS DeathPercentage
From PortfolioProject..CovidDeaths
Order by 1,2

-- Data for Russia
Select location, date, total_cases,total_deaths,
(CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0)) * 100 AS DeathPercentage
From PortfolioProject..CovidDeaths
Where location like 'Russia'
Order by 1,2

-- Total Cases vs Population
-- Shows what percentage og population got Covid
Select location, date, population, total_cases,
(CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0)) * 100 AS GetInfectPercentage
From PortfolioProject..CovidDeaths
-- Where location like 'Russia'
Order by 1,2

-- Looking at Contries with Highest Infection Rate compared by Population
SELECT location, population, MAX(CAST(total_cases AS float)) AS HighestInfectionCount,
(MAX(CAST(total_cases AS float)) / NULLIF(CAST(population AS float), 0)) * 100 AS PersentPopulationInfected
FROM PortfolioProject..CovidDeaths
GROUP BY location, Population
ORDER BY 4 DESC

-- Showing countries with Highest death Count per Population
SELECT location, MAX(CAST(total_deaths AS float)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
Where location NOT IN ('World', 'High income', 'Europe', 'Asia', 'North America', 'South America', 'Lower middle income', 'Upper middle income', 'European Union')
GROUP BY location
ORDER BY TotalDeathCount DESC

-- Showing continents with Highest death Count per Population
SELECT continent, MAX(CAST(total_deaths AS float)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
Where continent <> ' '
GROUP BY continent
ORDER BY TotalDeathCount DESC

-- Global numbers
Select date,
SUM(CAST(new_cases AS float)) as TotalCases,
SUM(CAST(new_deaths AS float)) as TotalDeaths,
CASE
WHEN SUM(CAST(new_cases AS float)) = 0 THEN 0
ELSE (SUM(CAST(new_deaths AS float))/SUM(CAST(new_cases as float))) * 100
END AS DeathPercentage
From PortfolioProject..CovidDeaths
Where location NOT IN ('World', 'High income', 'Europe', 'Asia', 'North America', 'South America', 'Lower middle income', 'Upper middle income', 'European Union')
Group by date
Order by date

-- Looking at Total Population vs Vaccination

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as 
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations AS float)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population) * 100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccination vac
  On dea.location = vac.location
  and dea.date = vac.date
Where dea.continent <> ' '
--Order by 2,3
)
SELECT *, (RollingPeopleVaccinated/Population) * 100
FROM PopvsVac
