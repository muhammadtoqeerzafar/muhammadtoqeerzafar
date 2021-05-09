
/*Data exploration of Covid-19 data using SQL
Link to Dataset: https://ourworldindata.org/covid-deaths */

select *
from Portfolio_project..covid_deaths
order by 3,4



--select *
--from Portfolio_project..covid_vacc
--order by 3,4

Select Location, date, total_cases, new_cases, total_deaths, population
From Portfolio_project..covid_deaths
Where continent is not null 
order by 1,2

--looking at total cases vs total deaths in a country



Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage -- this will Show the likelihood of dying if someone contract covid in that country
From Portfolio_project..covid_deaths
Where location = 'Germany' --lets see only in Germany
and continent is not null  -- filtering continent is necessary otherwise while sorting or ordering, the top cases show up from Europ/Asia/africa rather than the countries
order by 1,2
-- several insights can be seen for example in the end of 2020 there's controlled death rate 

-- Now Total Cases vs Population
-- lets see what percentage of population infected with Covid

Select Location, date, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
From Portfolio_project..covid_deaths
Where location = 'Germany'
order by 1,2

-- Countries with Highest Infection Rate compared to Population 

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From Portfolio_project..covid_deaths
--Where location = 'Germany'
Group by Location, Population
order by PercentPopulationInfected desc


-- Countries with Highest Death Count per Population

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount --without casting in int, the results were not correct, possibly bcz some data is detected as string
From Portfolio_project..covid_deaths

Where continent is not null 
Group by Location
order by TotalDeathCount desc




-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From Portfolio_project..covid_deaths

Where continent is not null 
Group by continent
order by TotalDeathCount desc



-- GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From Portfolio_project..covid_deaths
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2



-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine
-- since vaccnation data is in different table which means we]re going to introduce JOINS

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From Portfolio_project..covid_deaths dea
Join Portfolio_project..covid_vacc vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3

