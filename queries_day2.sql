select * from stars
where birthdate between '01/01/1930' and '31/12/1939'
order by birthdate;

-- NB: datepart => extract pour les autres SGBD
select * from stars
where datepart(year,birthdate) between 1930 and 1939
order by birthdate;

select * from stars
where year(birthdate) between 1930 and 1939
order by birthdate;

select * from stars
where name like 'Clint%';

select * from stars
where birthdate = '31/05/1930';

select * from stars
where datepart(day, birthdate) between 2 and 12;

select * from stars
where birthdate = '09/06/1981'; -- 9 juin

set dateformat mdy; -- month day year

select * from stars
where birthdate = '09/06/1981'; -- 6 septembre

set dateformat dmy; -- day month year

select * from stars
where birthdate = '09/06/1981'; -- à nouveau 9 juin

select * from stars
where birthdate = '1981-06-09'; -- format ISO toujours OK

-- age d'une personne ?
select
	CURRENT_TIMESTAMP as f_current_timestamp,
	SYSDATETIME() as f_sysdatetime,
	getdate() as f_getdate, 
	convert(date, getdate()) as f_current_date,	-- current_date
	convert(time, getdate()) as f_current_time,	-- current_time
	datefromparts(2021,10,12) as f_datefromparts,
	DATETIMEFROMPARTS(2021,10,12,9,45,30,0) as f_datetimefromparts,
	TIMEFROMPARTS(9,45,30,0,0) as f_timefromparts;

-- stars avec leur age (au 31/12)
select 
	name,
	birthdate,
	year(birthdate) as birth_year,
	year(getdate()) as current_year,
	year(getdate()) - year(birthdate) as age
from stars
order by age desc;

-- films de moins de 10 ans
select 
	*,
	datepart(year, getdate()) - year as age  -- pour vérifier
from movies
where datepart(year, getdate()) - year < 10
order by year desc, title;

select 
	*,
	DATEDIFF(year, birthdate, getdate()) as age_years,
	DATEDIFF(day, birthdate, getdate()) as age_days,
	DATEADD(year, 21, birthdate) as date_21y,
	DATEADD(day, -2, birthdate) as birthdate_minus2days
from stars
where name like 'Clint Eastwood';

select 
	*,
	DATEFROMPARTS(year(birthdate), month(birthdate), 1) as debut_mois,
	EOMONTH(birthdate) as fin_mois
from stars
where name like 'Natalie Portman';

select 
	EOMONTH('2021-02-01'),
	EOMONTH('2020-02-01'),
	EOMONTH('2000-02-01'),
	EOMONTH('2100-02-01');


select
	name, 
	FORMAT(birthdate, 'dd/MM/yyyy'),
	FORMAT(birthdate, 'd', 'fr_FR'),
	FORMAT(birthdate, 'd', 'en_US')
from stars
where name like 'Natalie Portman';

select * from stars where birthdate is null;
select * from stars where deathdate is not null;

select 
	title, 
	year,
	coalesce(synopsis, 'No Summary') as synopsis
from movies
where year between 1963 and 1964;

-- Échec de la conversion de la date et/ou de l'heure à partir d'une chaîne de caractères.
select
	name,
	coalesce(birthdate, 'Unknown') as birthdate
from stars;

select
	name,
	coalesce(format(birthdate,'d', 'fr_FR'), 'Unknown') as birthdate,
	coalesce(convert(varchar, birthdate), 'Unknown') as birthdate2,
	coalesce(birthdate, deathdate, '2050-01-01') as a_date
from stars;

-- masquer une donnée (ici année 2020)
select 
	title,
	year,
	nullif(year, 2020) as year_except2020
from movies
where year > 2015;

-- films avec mention court métrage ou long métrage 
-- suivant la durée 30mn
select 
	title,
	year,
	duration,
	case
		when duration < 30 then 'court métrage'
		else 'long métrage'
	end as classification
from movies;

-- prénom ou nom unique de la star
select 
	substring(name, 1, charindex(' ', name)-1) as firstname
from stars
where charindex(' ',name) > 0;










