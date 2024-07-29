

select location,date,total_cases, new_cases, total_deaths,population
from PortfolioProject.dbo.CovidDeaths
order by 1,2

-- total_cases vs totals_deaths
select location,date,total_cases, total_deaths,(total_deaths/total_cases)*100 As death_percentage
from PortfolioProject.dbo.CovidDeaths
order by death_percentage desc

--total_cases vs population
select location,date,total_cases,population,(total_cases/population)*100 As case_percentage
from PortfolioProject.dbo.CovidDeaths
where location = 'italy'
order by case_percentage desc

select location, avg((total_cases/population)*100) as MediaCasixPop
FROM PortfolioProject.dbo.CovidDeaths

group by location
order by MediaCasixPop desc

select location, max((total_cases/population)*100) as MaxCasi
FROM PortfolioProject.dbo.CovidDeaths

group by location
order by MaxCasi desc

select location, max((total_deaths/total_cases)*100) as Maxmorte
FROM PortfolioProject.dbo.CovidDeaths
group by location
order by Maxmorte desc

select location, avg((total_deaths/total_cases)*100) as avgmorte
FROM PortfolioProject.dbo.CovidDeaths
group by location
order by avgmorte desc

select date, max(total_deaths) as MaxMorte
from PortfolioProject.dbo.CovidDeaths
where location = 'italy'
group by date
order by MaxMorte desc

Select continent, Max (cast(total_deaths as int)) as totdeathcounts
from PortfolioProject.dbo.CovidDeaths
where continent is not null
group by continent
order by totdeathcounts desc

--global numbers
--per data
SELECT date,sum(new_cases) as totalcases ,sum(cast(new_deaths as int)) as totdeaths, (sum(cast(new_deaths as int))/sum(new_cases)) * 100 as PercMorte
from PortfolioProject.dbo.CovidDeaths  
where continent is not null
group by date
order by totalcases desc

--totale
SELECT sum(new_cases) as totalcases ,sum(cast(new_deaths as int)) as totdeaths, (sum(cast(new_deaths as int))/sum(new_cases)) * 100 as PercMorte
from PortfolioProject.dbo.CovidDeaths  
where continent is not null
order by totalcases desc

--persone nel mondo vaccinate

With popvsvac(continent,location,date,population,new_vaccinations,rollingpeoplevaccinated)
as(
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,SUM(cast(vac.new_vaccinations as int)) OVER (partition by dea.location 
order by dea.location,dea.date) as rollingpeoplevaccinated
FROM PortfolioProject.dbo.CovidDeaths dea 
JOIN  PortfolioProject.dbo.CovidVaccinations vac 
ON dea.location = vac.location 
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)

Select *, (rollingpeoplevaccinated/population) * 100 as percvaccinated
from popvsvac

--Create view for visualization

CREATE view 
percentpopulationvaccinated as 
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,SUM(cast(vac.new_vaccinations as int)) OVER (partition by dea.location 
order by dea.location,dea.date) as rollingpeoplevaccinated
FROM PortfolioProject.dbo.CovidDeaths dea 
JOIN  PortfolioProject.dbo.CovidVaccinations vac 
ON dea.location = vac.location 
and dea.date = vac.date
where dea.continent is not null

SELECT * from percentpopulationvaccinated