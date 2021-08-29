use portfolioproject;
select * from covid_death
where continent is not null
order by 3,4;
UPDATE covid_death
SET continent = NULL
WHERE continent like '';

select * from covid_vaccine
order by 3,4;

-- selecting the data to use
select Location, date, total_cases, new_cases, total_deaths, population
from covid_death
order by 1,2;

-- looking at total cases vs total death what percantage of cases dies
-- shows liklihood of dying if you contact covid in your country
select Location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from covid_death
where location like 'Estonia'
order by 1,2;

-- looking at total cases vs population what percentage of population got covid
select Location, date,population,(total_cases/population)*100 as PercentPopulationInfected
from covid_death
where location like 'Estonia'
order by 1,2;

-- finding countries that have highest infection rate compared to population
select Location, date,population,max(total_cases) as highest_infection_count,max((total_cases/population)*100) as PercentPopulationInfected
from covid_death
-- where location like 'Estonia'
group by Location,population
order by PercentPopulationInfected desc;

-- lets get continents information
select continent, max(total_deaths) as total_death_count
from covid_death
where continent is not null
group by continent
order by total_death_count desc;


-- finding countries with highst death count rate compared to population
select Location, max(total_deaths) as total_death_count
from covid_death
where continent is not null
group by Location
order by total_death_count desc;

-- lets get location information
select Location, max(total_deaths) as total_death_count
from covid_death
where continent is null
group by Location
order by total_death_count desc;

-- lets get continents information
-- cotinents highst death count
select continent, max(total_deaths) as total_death_count
from covid_death
where continent is not null
group by continent
order by total_death_count desc;

-- global numbers

select sum(new_cases) as total_cases,sum(new_deaths) as total_deathes,sum(new_deaths)/sum(new_cases)*100 as DeathPercentage-- total_deaths,(total_deaths/total_cases)*100 as DeathPercantage
from covid_death
-- where location like 'Estonia'
where continent is not null
-- group by date
order by 1,2;

-- vaccine data
select * from covid_vaccine
order by 3,4;

-- Looking at Total population vs vaccinations
select dea.continent,dea.location, dea.date,dea.population,vac.new_vaccinations
, sum(vac.new_vaccinations) over(partition by dea.location order by dea. location,
dea.date) as RoolingPeopleVaccinated,
(RoolingPeopleVaccinated/dea.population)*100
from covid_death dea
left outer join  covid_vaccine vac
    on dea.location= vac.location
	and dea.date=vac.date
where dea.continent is not null
order by 2,3;
-- making CTE

with PopvsVac(continent,location, date,population,new_vaccinations,RoolingPeopleVaccinated)
as
(
select dea.continent,dea.location, dea.date,dea.population,vac.new_vaccinations
, sum(vac.new_vaccinations) over(partition by dea.location order by dea. location,
dea.date) as RoolingPeopleVaccinated
from covid_death dea
left outer join  covid_vaccine vac
    on dea.location= vac.location
	and dea.date=vac.date
where dea.continent is not null
)
select *,( RoolingPeopleVaccinated/population)*100
from popvsvac;


-- temp table
drop table if exists PercentPopulationVaccinated;
create table PercentPopulationVaccinated
(
continent varchar(255),
location varchar (255),
date date,
population int,
new_vaccinations int,
RoolingPeopleVaccinated int
);

insert into PercentPopulationVaccinated
select dea.continent,dea.location, dea.date,dea.population,vac.new_vaccinations
, sum(vac.new_vaccinations) over(partition by dea.location order by dea. location,
dea.date) as RoolingPeopleVaccinated
from covid_death dea
left outer join  covid_vaccine vac
    on dea.location= vac.location
	and dea.date=vac.date
where dea.continent is not null;

select *,( RoolingPeopleVaccinated/population)*100
from PercentPopulationVaccinated;


-- creating view to store data for later visualizations
create view PercentagePopulationVaccinated as
select dea.continent,dea.location, dea.date,dea.population,vac.new_vaccinations
, sum(vac.new_vaccinations) over(partition by dea.location order by dea. location,
dea.date) as RoolingPeopleVaccinated
from covid_death dea
left outer join  covid_vaccine vac
    on dea.location= vac.location
	and dea.date=vac.date
where dea.continent is not null;