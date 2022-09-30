Select * 
From portfolioProject..CovidDeaths
where location is not null
order by 3,4


Select location, date, total_cases, new_cases, total_deaths, population
From portfolioProject..CovidDeaths
Order by 1,2

-- Total cases vs Total Deaths

Select location, date, total_cases, total_deaths, Round((total_deaths/total_cases)*100,2)as DeathPercentage
From portfolioProject..CovidDeaths
where location like 'Pakistan'
Order by 1,2

  --Total cases vs Population

 Select location, date, population, total_cases, Round((total_cases/population)*100,2) as InfectedPercentage
From portfolioProject..CovidDeaths
Where location like 'Pakistan'
Order by 1,2

--Countries with highest Infection Rate compared to their population

Select location, population, MAX(total_cases) as HighestInfectionCount, Round(MAX((total_cases/population))*100,2)
as PercentagePopulationInfected
From portfolioProject..CovidDeaths
--where location like 'Pakistan'
Group by location, population
Order by PercentagePopulationInfected desc

-- Countries with highest death count per population

Select location, MAX(CAST(total_deaths as int)) as TotalDeathCount
From portfolioProject..CovidDeaths
where continent is not null
Group by location
Order by TotalDeathCount desc

-- DeathCount Per Continent

Select continent, MAX(CAST(total_deaths as int)) as TotalDeathCount
From portfolioProject..CovidDeaths
where continent is not null
Group by continent 
Order by TotalDeathCount desc

--Continents with highest Death Count

Select continent, MAX(CAST(total_deaths as int)) as TotalDeathCount
From portfolioProject..CovidDeaths
where continent is not null
Group by continent
Order by TotalDeathCount desc

-- Global Numbers

Select date, SUM (new_cases) as TotalCases , SUM(new_deaths) as TotalDeaths, SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage 
From portfolioProject..CovidDeaths
where continent is not null
Group by date
Order by 1,2

--Total Population vs Total Vaccination

Select  dea.continent, dea.location, dea.date,dea.population,vac.new_vaccinations
from portfolioProject..CovidDeaths dea
join portfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not NULL
order by 2,3


Select  dea.continent, dea.location, dea.date,dea.population,vac.new_vaccinations,
SUM (CONVERT (int, vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from portfolioProject..CovidDeaths dea
join portfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not NULL
order by 2,3

Select  dea.continent, dea.location, dea.date,dea.population,vac.new_vaccinations,
SUM (CONVERT (int, vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated

from portfolioProject..CovidDeaths dea
join portfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not NULL
order by 2,3

-- CTE

with PopvsVac (continent,location,date,population,new_vaccinated, RollingPeopleVaccinated)
as (
select dea.continent, dea.location, dea.date,dea.population,vac.new_vaccinations,
SUM (Convert (int, vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from portfolioProject..CovidDeaths dea
join portfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not NULL
) 
select * , (RollingPeopleVaccinated/population)*100
from PopvsVac

--TEMP TABLE
Create table #PercentPopulationVaccinated
(Continent nvarchar(255), Location nvarchar(255), Population numeric, Date datetime, New_Vaccination numeric, RollingPeopleVaccinated numeric)
Insert into #PercentPopulationVaccinated

select dea.continent, dea.location, dea.date,dea.population,vac.new_vaccinations,
SUM (Convert (int, vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from portfolioProject..CovidDeaths dea
join portfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not NULL

select * , (RollingPeopleVaccinated/Population)*100
from #PercentPopulationVaccinated



