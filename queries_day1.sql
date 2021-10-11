create database dbmovie;

select * from movies;
select * from MOVIES;
select * from dbmovie.dbo.movies;

select * from stars;

-- projection

-- les titres et ann�es des films
select title, year from movies;

-- les noms des stars
select name from stars;

-- selection (pr�dicat)

-- films de 1980 i.e films de l'ann�e 1980
select * from movies where year = 1980;

-- films de plus de 100mn
select * from movies where duration >= 100;
select * from movies where duration > 100;

-- titre, ann�e et dur�e des films de plus de 100mn
select title, year, duration 
from movies 
where duration >= 100;

select title, year, duration 
from movies 
where duration < 10;

-- les films de 1980 et de plus de 100mn
select * from movies
where year = 1980 and duration >= 100;

-- les films de plus de 3H ou de l'ann�e 1997
select * 
from movies
where 
	year = 1997 
	or duration >= 180;

-- pr�dicat diff�rent + tri
select * from movies
where year <> 1990
order by year;

select * from movies
where year != 1990
order by year desc;

-- films des 80s, tri�s par titre d�croissant
select * from movies
where year between 1980 and  1989
order by title desc;

-- films de dur�e non renseign�e

-- Wrong idea
-- select * from movies
-- where duration = NULL; -- pr�dicat tt le temps faux

select * from movies
where duration is NULL;

-- films avec un poster
select * from movies
where poster_uri is not null;

-- le(s) film(s) Titanic
select * from movies
where title = 'Titanic';

-- select * from movies
-- where title = "Titanic"; -- interpret Titanic as a column

-- films contenant le mot Ugly
select * from movies
where title like '%Ugly%';

-- comparaison insensible � la casse (CI)
-- d�pend du r�glage du classement (collation)
-- French_CI_AS
--    - CI : Case Insensitive (oppos� CS)
--    - AS : Accent Sensitive
select * from movies
where title like '%ugly%';

select * from stars where name like '%�%';

-- film pas de guerre
select * from movies where not (genres like '%war%');
select * from movies where genres not like '%war%';

-- motif simple : % et _ 
select * from movies where title like '_ita%';  -- 1 r�sultat
select * from movies where title like '%ita%';  -- 6 r�sultats

-- motif : regexp
-- ex: 1 chiffre au d�but du titre
select * from movies where title like '[0-9]%';

-- stars dont le nom commen�ant par Z ou W
select * from stars where name like '[ZW]%';

-- films de 1986 et 1990, tri�s par ann�e puis par titre
select * from movies 
where year in (1986, 1990)
order by year desc, title;

-- projection : colonne calul�e
select 
	title, 
	year,
	-- (duration / 60.0) * 100 as duration_hour1,
	-- (duration / 60) * 100 as duration_hour2,
	duration / 60.0 as duration_hour1,
	duration / 60 as duration_hour2,
	duration % 60 as duration_minutes
from movies
order by duration_hour2 desc, duration_minutes desc;

-- films de dur�e 2H � 5% pr�s
select 120*5/100; -- de 114 � 126

select * from movies 
where (duration/60.0) between (2*0.95) and (2*1.05);

select * from movies 
where duration between (120*0.95) and (120*1.05)
order by duration;

select * from movies
where abs(duration - 120) <= 120 * 0.05
order by duration;







