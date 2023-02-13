 --Looking AT Total Cases vs Population (using USA as example)
  --Show what percentage OF the population have gotten covid
  
SELECT
  location,
  date,
  total_cases,
  population,
  (total_cases/population)*100 AS infected_percentage
FROM
  `PortfolioProject.CovidDeaths`
WHERE
  location = 'United States'
ORDER BY
  1,
  2


--Looking AT Total Cases vs Total Deaths 
--Shows likelyhood oF dying If you are affected BY COVID IN your country

SELECT
  location,
  date,
  total_cases,
  total_deaths,
  (total_deaths/total_cases)*100 AS death_percentage
FROM
  `PortfolioProject.CovidDeaths`
WHERE
  location = 'United States'
ORDER BY
  1,
  2


--Looking AT countries With highest infection rates compared To population

SELECT
  location,
  population,
  MAX(total_cases) AS highest_infection_count,
  MAX((total_cases/population))*100 AS infected_percentage
FROM
  `PortfolioProject.CovidDeaths`
GROUP BY
  location,
  population
ORDER BY
  infected_percentage DESC


--Showing countries with the highest death count and highest death percentage

SELECT
  location,
  population,
  MAX(total_deaths) AS highest_deaths_count,
  MAX((total_deaths/total_cases))*100 AS death_percentage
FROM
  `PortfolioProject.CovidDeaths`
WHERE
  continent IS NOT NULL
GROUP BY
  location,
  population
ORDER BY
  highest_deaths_count DESC
--ORDER BY death_percentage DESC


--Showing continents with the highest death count

SELECT
  location,
  MAX(total_deaths) AS total_deaths_count,
FROM
  `PortfolioProject.CovidDeaths`
WHERE
  continent IS NULL
  AND NOT location = 'World'
GROUP BY
  location
ORDER BY
  total_deaths_count DESC


--Total numbers OF cases, deaths AND percentage around the world

SELECT
  SUM(new_cases) AS cases,
  SUM(new_deaths) AS deaths,
  (SUM(new_deaths)/SUM(new_cases)) * 100 AS death_percentage
FROM
  `PortfolioProject.CovidDeaths`
WHERE
  continent IS NOT NULL
ORDER BY
  1,
  2


--Global numbers per day
  
SELECT
  date,
  SUM(new_cases) AS cases,
  SUM(new_deaths) AS deaths,
  (SUM(new_deaths)/SUM(new_cases)) * 100 AS death_percentage
FROM
  `PortfolioProject.CovidDeaths`
WHERE
  continent IS NOT NULL
GROUP BY
  date
ORDER BY
  1,
  2

--Looking At locations vs vaccinations

SELECT
  dea.continent, dea.location, dea.date, vac.new_vaccinations,
  SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS total_Vaccinations
FROM
  `PortfolioProject.CovidDeaths` AS dea
JOIN
  `PortfolioProject.CovidVaccinations` AS vac
ON
  dea.location = vac.location
  AND dea.date = vac.date
WHERE
  dea.continent IS NOT NULL
ORDER BY 2, 3


--Looking AT Populations vs Vaccination with CTE
  
WITH
  PopVsVacc AS (
  SELECT
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS total_vaccs
  FROM
    `PortfolioProject.CovidDeaths` AS dea
  JOIN
    `PortfolioProject.CovidVaccinations` AS vac
  ON
    dea.location = vac.location
    AND dea.date = vac.date
  WHERE
    dea.continent IS NOT NULL )
SELECT
  *,
  (total_vaccs/population) * 100 AS percentage_vaccinated
FROM
  PopVsVacc