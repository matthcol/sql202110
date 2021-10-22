-- les titres des films de l'acteur 285
select title
from movies where id in (
	select id_movie 
	from play
	where id_actor = 285);

-- les titres des films joués par Alec Baldwin
select title
from movies where id in (
	select id_movie 
	from play
	where id_actor = (
		select id
		from stars
		where name like 'Alec Baldwin'
	));

-- idem avec Steve McQueen
select title
from movies where id in (
	select id_movie 
	from play
	where id_actor in (
		select id
		from stars
		where name like 'Steve McQueen'
	));

-- titres, années des films, role joué, date de naissance d'un acteur :
--   1. Alec Baldwin
--   2. Steve McQueen
select title, year, role, birthdate
from movies where id in (
	select id_movie 
	from play
	where id_actor = (
		select id
		from stars
		where name like 'Alec Baldwin'
	));

-- attention à l'ambiguité
select * 
from play join stars on id_actor = id 
where name like 'Alec Baldwin';

-- idem (prefixer par nom de table)
select * 
from play join stars on play.id_actor = stars.id 
where stars.name like 'Alec Baldwin';

-- idem (renommage sans mot clé as)
select * 
from play p join stars s on p.id_actor = s.id 
where s.name like 'Alec Baldwin';

-- idem (renommage avec mot clé as)
select * 
from play as p join stars as s on p.id_actor = s.id 
where s.name like 'Alec Baldwin';

-- idem (inner facultatif)
select * 
from play p inner join stars s on p.id_actor = s.id 
where s.name like 'Alec Baldwin';

-- jointure pivot 
select *
from play p, stars s
where
	p.id_actor = s.id
	and s.name like 'Alec Baldwin';

select 
	m.*, s.*, p.role 
from 
	movies m
	join play p on m.id = p.id_movie
	join stars s on p.id_actor = s.id 
where s.name like 'Alec Baldwin';

select 
	m.title, m.year, p.role, s.name, s.birthdate
from 
	movies m
	join play p on m.id = p.id_movie
	join stars s on p.id_actor = s.id 
where s.name like 'Alec Baldwin';

select 
	m.title, m.year, p.role, s.name, s.birthdate
from 
	movies m
	join play p on m.id = p.id_movie
	join stars s on p.id_actor = s.id 
where s.name like 'Steve McQueen'
order by birthdate, year;

-- titres, années et réalisateur des films de 1984
select m.title, m.year, s.*
from movies m join stars s on m.id_director = s.id
where m.year = 1984
order by title;

-- films où DiCaprio a collaboré avec Martin Scorcese
select *
from 
	stars s_act
	join play p on s_act.id = p.id_actor
	join movies m on p.id_movie = m.id
	join stars s_dir on m.id_director = s_dir.id
where
	s_act.name like '% DiCaprio'
	and s_dir.name like 'Martin Scorsese'
order by m.year;

-- films de star wars avec leur réalisateur
select *
from movies m join stars s on m.id_director = s.id
where 
	m.title like 'Star Wars%'
	and m.title not like '%Deleted%'
order by year;

-- compter le nb de résultats de la requete précédente
-- = le nb de films stars wars ?
select count(*) as nb_movies
from movies m join stars s on m.id_director = s.id
where 
	m.title like 'Star Wars%'
	and m.title not like '%Deleted%';

-- nb de films star wars (hors bonus films)
select count(*) as nb_movies
from movies m 
where 
	m.title like 'Star Wars%'
	and m.title not like '%Deleted%';

select *
from movies m 
where 
	m.title like 'Star Wars%'
	and m.title not like '%Deleted%';

-- films de stars wars avec leur réalisateur (si connu)
select *
from movies m left join stars s on m.id_director = s.id
where 
	m.title like 'Star Wars%'
	and m.title not like '%Deleted%'
order by m.year;

select m.title, m.year, s.name
from movies m left join stars s on m.id_director = s.id
where 
	m.title like 'Star Wars%'
	and m.title not like '%Deleted%'
order by m.year;









