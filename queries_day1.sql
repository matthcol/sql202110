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

select 
	CEILING(duration / 60.0),
	FLOOR(duration / 60.0),
	ROUND(duration / 60.0, 2),
	duration / 60.0
from movies
order by duration desc;

-- titres et nb de caract�res des titres de films
-- LEN
select title, len(title) as title_length 
from movies
where  len(title) >= 100   -- title_length pas dispo ici
order by title_length desc;

-- NB: charindex renvoie 0 si non trouv�
select 
	lower(left(name, 5)) as name_first5,
	upper(right(name, 5)) as name_last5,
	SUBSTRING(name, 3, 5) as name_3to7,
	charindex(' ',name) as space_index,
	substring(name, 1, charindex(' ', name)-1) as firstname
from stars
where charindex(' ',name) > 0;

select concat(title, ' (', year, ')') as title_year
from movies;

-- stars qui s'appelle John
select * from stars 
where name like 'John %'
	or name like 'John';

-- les films Star Wars (titre, ann�e) tri�s par ann�e
select * from movies
where title like 'Star Wars%'
order by year;

-- idem en ne gardant que les films de la trilogie d'origine
select * from movies
where 
	title like 'Star Wars%'
	and genres not like '%Short%'
	and year <= 1983
order by year;

select top(3) * from movies
where 
	title like 'Star Wars%'
	and genres not like '%Short%'
order by year;











-- PB: + entre text et nombre ne marche pas
-- select title + ' (' + year + ')' as title_year
-- from movies;
-- solution : conversion explicite
-- NB: les autres ||
select title + ' (' + convert(varchar,year) + ')' as title_year
from movies;















