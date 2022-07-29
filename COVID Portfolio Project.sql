


Select * 
From [Portfolio Project]..CovidDeaths
ORDER BY 3,4

--

--Select Data that we are going to be  using

Select Location, date, total_cases, new_cases, total_deaths,population 
From [Portfolio Project]..CovidDeaths
ORDER BY 1,2

-- total cases vs total deaths 
Select location, date, total_cases, total_deaths, Round((total_deaths/total_cases)*100,2) AS percentagedeaths
From [Portfolio Project]..CovidDeaths
Where location like '%india%'
ORDER BY 1,2

--total cases vs population 
Select location, date, total_cases, population, Round((total_cases/population)*100,2) AS infectionPercentage
From [Portfolio Project]..CovidDeaths
Where location like '%canada%'
ORDER BY 5 desc

--countries with infection rate
Select location, population, MAX(total_cases)as HighestInfectionCount, Round(MAX((total_cases/population))*100,2) AS infectionPercentage
From [Portfolio Project]..CovidDeaths
--Where location like '%canada%'
GROUP BY population, Location
ORDER BY 4 desc

--Countries with highest death count per population

Select location, population, MAX(Cast( total_deaths as int))as HighestDeathCount
From [Portfolio Project]..CovidDeaths
--Where location like '%canada%'
Where continent is not Null
GROUP BY population, Location
 
ORDER BY HighestDeathCount desc

-- by continents

Select Location,  MAX(Cast( total_deaths as int))as HighestDeathCount
From [Portfolio Project]..CovidDeaths
--Where location like '%canada%'
Where continent is Null
GROUP BY location 
ORDER BY HighestDeathCount desc

-- Showing the continents with highest deaths per population
Select Continent,  MAX(Cast( total_deaths as int))as HighestDeathCount
From [Portfolio Project]..CovidDeaths
--Where location like '%canada%'
Where continent is not Null
GROUP BY Continent 
ORDER BY HighestDeathCount desc


-- Global Numbers


Select  date, SUM(New_cases) as totalCases, sum(cast (new_deaths as bigint))as TotalDeaths, (sum(cast (new_deaths as int))/sum(new_cases ))*100 as DeathPercentage
From [Portfolio Project]..CovidDeaths
Where continent is not Null
Group BY date
ORDER BY 1,2

--WWorldwide death %age
Select  SUM(New_cases) as totalCases, sum(cast (new_deaths as bigint))as TotalDeaths, (sum(cast (new_deaths as int))/sum(new_cases ))*100 as DeathPercentage
From [Portfolio Project]..CovidDeaths
Where continent is not Null
--Group BY date
ORDER BY 1,2


Select * 
From [Portfolio Project]..CovidDeaths dea
Join [Portfolio Project]..CovidVaccinations vac
	ON dea.location=vac.location
	AND dea.date=vac.date


-- new vacc by continent
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From [Portfolio Project]..CovidDeaths dea
Join [Portfolio Project]..CovidVaccinations vac
	ON dea.location=vac.location
	AND dea.date=vac.date
WHERE dea.continent is not null
Order BY 1,2,3

--rolling sum
	
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(convert(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.Location, dea.Date) as cummulativeVaccCount
From [Portfolio Project]..CovidDeaths dea
Join [Portfolio Project]..CovidVaccinations vac
	ON dea.location=vac.location
	AND dea.date=vac.date
WHERE dea.continent is not null
Order BY 2,3

With PopvsVac (Continent, Location, Date, population, new_vaccinations,cummulativeVaccCount)
as (
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(convert(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.Location, dea.Date) as cummulativeVaccCount
From [Portfolio Project]..CovidDeaths dea
Join [Portfolio Project]..CovidVaccinations vac
	ON dea.location=vac.location
	AND dea.date=vac.date
WHERE dea.continent is not null
--Order BY 2,3
)

Select *, cummulativeVaccCount/population*100
From PopvsVac


--Creating view to use later
CREATE VIEW PercentPopulationVacc as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(convert(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.Location, dea.Date) as cummulativeVaccCount
From [Portfolio Project]..CovidDeaths dea
Join [Portfolio Project]..CovidVaccinations vac
	ON dea.location=vac.location
	AND dea.date=vac.date
WHERE dea.continent is not null
--Order BY 2,3

select * from PercentPopulationVacc

