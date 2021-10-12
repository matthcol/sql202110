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







