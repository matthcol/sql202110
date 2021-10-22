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






