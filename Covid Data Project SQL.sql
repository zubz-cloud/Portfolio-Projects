Select *
From ProjectPortfolio..CovidDeaths$
where continent is not null
order by 3,4

--Select *
--From ProjectPortfolio..CovidVaccination$
--order by 3,4

Select location, date, total_cases, new_cases, total_deaths, population
From ProjectPortfolio..CovidDeaths$
order by 1,2

-- Looking at the Total Cases vs Total Deaths
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From ProjectPortfolio..CovidDeaths$
where location like '%bangladesh%'
order by 1,2
-- shows the likelihood of dying if you were Covid Positive in Bangladesh


-- Looking at the Total Cases vs Population
Select location, date,population, total_cases, (total_cases/population)*100 as DeathPercentage
From ProjectPortfolio..CovidDeaths$
where location like '%bangladesh%'
order by 1,2
-- Shows what Percentage of Population was Covid Positive


-- Looking at Countries with the highest infection rate compared to Population
Select location,population, max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as PercentofPopulationInfected
From ProjectPortfolio..CovidDeaths$
group by location,population
order by PercentofPopulationInfected desc


-- Showing Countries with Highest Death Count per Population
Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From ProjectPortfolio..CovidDeaths$
where continent is not null
group by location
order by TotalDeathCount desc


--LET'S BREAK THINGS DOWN BY CONTINENT
--Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
--From ProjectPortfolio..CovidDeaths$
--where continent is null
--group by location
--order by TotalDeathCount desc


-- Showing continents with the highest death counts
Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From ProjectPortfolio..CovidDeaths$
where continent is not null
group by continent
order by TotalDeathCount desc


-- Global Numbers

Select date,sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From ProjectPortfolio..CovidDeaths$
--where location like '%bangladesh%'
where continent is not null
group by date
order by 1,2

Select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From ProjectPortfolio..CovidDeaths$
--where location like '%bangladesh%'
where continent is not null
--group by date
order by 1,2




-- Looking at Total Population Vs Vaccinations with CTE (method 1)
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date)
as RollingCountofVacciation
From  ProjectPortfolio..CovidDeaths$ dea
Join  ProjectPortfolio..CovidVaccination$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac


---- Temp Table (method 2)

--Drop Table if exists #PercentPopulationVaccinated
--Create Table #PercentPopulationVaccinated
--(
--Continent nvarchar(255),
--Location nvarchar(255),
--Date datetime,
--Population numeric,
--New_vacciantions numeric,
--RollingPeopleVaccinated numeric,
--NewColumn numeric
--)

--Insert into #PercentPopulationVaccinated
--Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date)
--as RollingCountofVacciation
--From  ProjectPortfolio..CovidDeaths$ dea
--Join  ProjectPortfolio..CovidVaccination$ vac
--	on dea.location = vac.location
--	and dea.date = vac.date
--where dea.continent is not null
----order by 2,3
--Select *, (RollingPeopleVaccinated/Population)*100
--From #PercentPopulationVaccinated


-- Creating Views for Visualizations
Create View PopvsVac as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date)
as RollingCountofVacciation
From  ProjectPortfolio..CovidDeaths$ dea
Join  ProjectPortfolio..CovidVaccination$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3