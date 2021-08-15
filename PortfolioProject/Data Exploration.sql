-- Dataset source: https://ourworldindata.org/covid-deaths 

Select *
From CovidDeaths
Where continent is not null 
Order by 3,4

Select location, date, total_cases, new_cases, total_deaths, population
From CovidDeaths
Where continent is not null 
Order by 1,2

-- Total Cases vs Total Deaths
Select location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From CovidDeaths
Where continent is not null 
Order by 1,2

-- Total Cases vs population
Select location, date, population, total_cases,  (total_cases/population)*100 as PercentpopulationInfected
From CovidDeaths
Order by 1,2

-- Countries with Highest Infection Rate
Select location, population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentpopulationInfected
From CovidDeaths
Group by location, population
Order by PercentpopulationInfected desc

-- Countries with Highest Death Count
Select location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From CovidDeaths
Where continent is not null 
Group by location
Order by 2 desc

-- Showing contintents with the highest death count per population
Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From CovidDeaths
Where  continent <> '' and continent is not null  
Group by continent
Order by 2 desc

-- Looking at global numbers
Select SUM(new_cases) as TotalCases, SUM(cast(new_deaths as int)) as TotalDeaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From CovidDeaths
Where continent is not null 
Order by 1,2

-- Total population vs Vaccinations
-- Shows Percentage of population that has recieved at least one Covid Vaccine
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From CovidDeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
Order by 2,3

-- Using CTE to perform Calculation on Partition By in the previous query
With PopvsVac (Continent, location, Date, population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
)
Select *, (RollingPeopleVaccinated/population)*100
From PopvsVac
Go;


-- Using Temp Table to perform Calculation on Partition By in previous query
IF OBJECT_ID('VACCINATED_PERCENTAGE', 'U') IS NOT NULL 
BEGIN
	DROP Table VACCINATED_PERCENTAGE
END

Create Table VACCINATED_PERCENTAGE
(
	Continent nvarchar(255),
	location nvarchar(255),
	Date datetime,
	population numeric,
	New_vaccinations numeric,
	RollingPeopleVaccinated numeric
)

Insert into VACCINATED_PERCENTAGE
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date

Select *, (RollingPeopleVaccinated/population)*100
From VACCINATED_PERCENTAGE
go;

-- Creating view to store data for later visualizations
Create View PercentpopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From CovidDeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 