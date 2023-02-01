--Looking at Total_death Vs Total_cases 

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From ProtoProject1.dbo.CovidDeaths as pcd
Where location Like '%Russia%'
Order by 1,2 DESC



--Looking at Total_cases Vs Population

Select location, date, total_cases, population, (total_cases/population)*100 as CasesPercentage
From ProtoProject1.dbo.CovidDeaths as pcd
--Where location Like '%states%'
Order by 1,2 


--Looking at the Countries with highest inflection rate compare to population

Select location, Max(total_cases)as Max_Inflected, population, Max((total_cases/population))*100 as Max_Cases_Percent
From ProtoProject1.dbo.CovidDeaths as pcd
Group by location,population
Order by  Max_Cases_Percent DESC


--Looking at Highest Total death per population

Select location, Max(cast(total_deaths as int))as Max_Totaldeath
From ProtoProject1.dbo.CovidDeaths as pcd
Where continent is not null
Group by location
Order by Max_Totaldeath DESC



--Looking at Highest Total death per Continent

Select continent, Max(cast(total_deaths as int))as Max_Totaldeath
From ProtoProject1.dbo.CovidDeaths as pcd
where continent is Not Null 
Group by continent
Order by Max_Totaldeath DESC



--Looking for Globlal numbers of casses and deathes

Select date, Sum(new_cases) as TotalCases, Sum(cast(new_deaths as float)) as TotalDeaths, 
Sum(cast(new_deaths as float))/Sum(new_cases)*100 as GlobalDeaths_perctage_perCases
from ProtoProject1.dbo.CovidDeaths
Where continent Is not Null
Group by date 
order by 1


--Over All CASES / DEATHS 

Select  Sum(new_cases) as TotalCases, Sum(cast(new_deaths as float)) as TotalDeaths, 
Sum(cast(new_deaths as float))/Sum(new_cases)*100 as GlobalDeaths_perctage_perCases
from ProtoProject1.dbo.CovidDeaths
Where continent Is not Null



-- Looking at Total population vs Vaccintations 

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations ,
Sum(cast(vac.new_vaccinations as int)) Over(partition by dea.location order by dea.location , dea.date) as Total_vac 
from ProtoProject1.dbo.CovidDeaths as dea
join ProtoProject1.dbo.CovidVac as vac on dea.location= vac.location and dea.date = vac.date
Where dea.continent is not null 
Order by 2,3



--CTE POP VS VAC

With PopvsVac (continent, location, date, population, new_vaccinations ,Total_vac)
as (
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations ,
Sum(cast(vac.new_vaccinations as int)) Over(partition by dea.location order by dea.location,dea.date) as Total_vac 
from ProtoProject1.dbo.CovidDeaths as dea
join ProtoProject1.dbo.CovidVac as vac on dea.location= vac.location and dea.date = vac.date
Where dea.continent is not null 
--Order by 2,3
)
Select *, (Total_vac/population)*100 as Total_vacpercentage
from PopvsVac


--Temp Table
Drop Table if exists #Total_Pop_VacPercentage
Create table #Total_Pop_VacPercentage
(continent nvarchar(255), location nvarchar(255), date datetime,  population numeric, 
new_vaccinations numeric,Total_vac numeric)

insert into #Total_Pop_VacPercentage
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations ,
Sum(cast(vac.new_vaccinations as int)) Over(partition by dea.location order by dea.location,dea.date) as Total_vac 
from ProtoProject1.dbo.CovidDeaths as dea
join ProtoProject1.dbo.CovidVac as vac on dea.location= vac.location and dea.date = vac.date
Where dea.continent is not null 
Order by 2,3
Select *, (Total_vac/population)*100 as Total_vacpercentage
from #Total_Pop_VacPercentage


--Create View for Visualization later on 
Create View Total_Pop_VacPercentage as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations ,
Sum(cast(vac.new_vaccinations as int)) Over(partition by dea.location order by dea.location,dea.date) as Total_vac 
from ProtoProject1.dbo.CovidDeaths as dea
join ProtoProject1.dbo.CovidVac as vac on dea.location= vac.location and dea.date = vac.date
Where dea.continent is not null

Select* 
From Total_Pop_VacPercentage

