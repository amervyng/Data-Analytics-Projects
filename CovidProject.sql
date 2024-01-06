Select *
From [PortFolio Project 1]..CovidDeaths
WHERE continent is NOT NULL
Order by 3,4

--Select *
--From [PortFolio Project 1]..CovidVaccinations
--Order by 3,4

--Select Data to Use

Select location,date,total_cases,new_cases,total_deaths,population
From [PortFolio Project 1]..CovidDeaths
WHERE continent is NOT NULL
Order By 1,2

--Looking at Total Cases vs Total Deaths

Select location,date,total_cases,total_deaths,(total_deaths / total_cases) * 100 as DeathPercentage
From [PortFolio Project 1]..CovidDeaths
WHERE continent is NOT NULL
WHERE location like '%india%'
Order By 1,2

--Looking at Total Cases vs Population
--show what percentage of Population got Covid

Select location,date,population,total_cases,(total_cases / population) * 100 as CovidaffectedPercentage
From [PortFolio Project 1]..CovidDeaths
WHERE continent is NOT NULL
--WHERE location like '%india%'
Order By 1,2

--Looking at Countries with Highest Infection Rate compared to Population

Select location,population,MAX(total_cases) as HighestInfectionCount,MAX((total_cases / population)) * 100 as PercentPopulationInfected
From [PortFolio Project 1]..CovidDeaths
--WHERE location like '%india%'
Group By location,population
WHERE continent is NOT NULL
Order By PercentPopulationInfected Desc

--Showing Countries with Highest Death Count Per Population

Select location,MAX(cast(total_deaths as int)) as TotalDeathCount
From [PortFolio Project 1]..CovidDeaths
WHERE continent is NOT NULL
--WHERE location like '%india%'
Group By location,population
Order By TotalDeathCount Desc

--Breaking This by Continent


Select continent,MAX(cast(total_deaths as int)) as TotalDeathCount
From [PortFolio Project 1]..CovidDeaths
WHERE continent is not NULL
--WHERE location like '%india%'
Group By continent
Order By TotalDeathCount Desc

--Showing Continents With Higher Death Count per Population

Select continent,MAX(cast(total_deaths as int)) as TotalDeathCount
From [PortFolio Project 1]..CovidDeaths
WHERE continent is not null
--WHERE location like '%india%'
Group By continent
Order By TotalDeathCount Desc

--Global Numbers


Select date,SUM(new_cases) as TotalCases,SUM(CAST(new_deaths as int)),SUM(CAST(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From [PortFolio Project 1]..CovidDeaths
WHERE continent is NOT NULL
--WHERE location like '%india%'
Group by date
Order By 1,2


Select SUM(new_cases) as TotalCases,SUM(CAST(new_deaths as int)),SUM(CAST(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From [PortFolio Project 1]..CovidDeaths
WHERE continent is NOT NULL
--WHERE location like '%india%'
--Group by date
Order By 1,2


--Looking at Total Population Vs Vaccinations

select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations,sum(convert(int,vac.new_vaccinations)) over (Partition by
dea.location order by dea.location,dea.date) as PeopleVaccinated
--(PeopleVaccinated / population)*100
from [PortFolio Project 1]..CovidDeaths dea
Join [PortFolio Project 1]..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3


--USE CTE

With PopvsVac (continent,location,date,population,new_vaccinations,PeopleVaccinated )
as
(
select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations,sum(convert(int,vac.new_vaccinations)) over (Partition by
dea.location order by dea.location,dea.date) as PeopleVaccinated
from [PortFolio Project 1]..CovidDeaths dea
Join [PortFolio Project 1]..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (PeopleVaccinated/population)*100 
from PopvsVac



--Temp tables
DROP TABLE IF EXISTS #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
continent nvarchar(250),location nvarchar(250),Date datetime,Population numeric,new_vaccinations numeric,PeopleVaccinated numeric
)


Insert into #PercentPopulationVaccinated
select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations,sum(convert(int,vac.new_vaccinations)) over (Partition by
dea.location order by dea.location,dea.date) as PeopleVaccinated
from [PortFolio Project 1]..CovidDeaths dea
Join [PortFolio Project 1]..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

Select *,(PeopleVaccinated / Population)*100
FROM #PercentPopulationVaccinated


--Creating View to store Data For later Visualization

Create View PercentPopulationsVaccinated as
select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations,sum(convert(int,vac.new_vaccinations)) over (Partition by
dea.location order by dea.location,dea.date) as PeopleVaccinated
from [PortFolio Project 1]..CovidDeaths dea
Join [PortFolio Project 1]..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select *
From PercentPopulationVaccinated