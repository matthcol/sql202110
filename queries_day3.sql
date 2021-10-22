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

-- idem avec projection des colonnes "intéressantes"
select m.title, m.year, s.name
from movies m left join stars s on m.id_director = s.id
where 
	m.title like 'Star Wars%'
	and m.title not like '%Deleted%'
order by m.year;

-- idem avec right join
select * -- m.title, m.year, s.name
from stars s right join movies m on m.id_director = s.id
where 
	m.title like 'Star Wars%'
	and m.title not like '%Deleted%'
order by m.year;



-- casting des films stars wars
-- 1. en jointure interne
-- 2. en jointure externe (garder tous les star wars)
select *
from
	movies m
	join play p on m.id = p.id_movie
	join stars s on p.id_actor = s.id
where 
	m.title like 'Star Wars%'
	and m.title not like '%Deleted%'
order by m.title;

select *
from
	movies m
	left join play p on m.id = p.id_movie
	left join stars s on p.id_actor = s.id
where 
	m.title like 'Star Wars%'
	and m.title not like '%Deleted%'
order by m.title;

-- fonctions d'agrégations sur toute la table (ou traitement précédent)
select 
	-- title,  -- pas possible car pls valeurs à mettre sur 1 ligne
	string_agg(title, ', ') as titles,
	count(*) as nb_movies, 
	min(year) as first_year, max(year) as last_year,
	sum(duration) as total_duration
from movies m 
where 
	m.title like 'Star Wars%'
	and m.title not like '%Deleted%';


-- nb films par année
select year, count(*) as nb_movies
from movies
group by year
order by year;

-- nb films par année dans les années 80
select year, count(*) as nb_movies	-- 4
from movies							-- 1
where year between 1980 and 1989    -- 2
group by year						-- 3
--order by year;
order by nb_movies desc;			-- 5

-- nb films par année dans les années 80 (cut à nb de films >= 20)
select year, count(*) as nb_movies	-- 5
from movies							-- 1
where year between 1980 and 1989    -- 2
group by year						-- 3
having count(*) >= 20				-- 4
order by nb_movies desc;			-- 6

select * 
from (select year, count(*) as nb_movies	-- 4
	from movies							-- 1
	where year between 1980 and 1989    -- 2
	group by year) nb_movies_by_year
where nb_movies >= 20
order by nb_movies desc;


-- 1. nb films, 1ere année, dernière année, durée totale par réalisateurs
--	    a. par numéro de réalisateur 
--      b. par réalisateur (au moins le nom, ...)
-- Réponse 1.a
select 
	id_director, 
	count(*) as nb_movies, 
	min(year) as first_year, 
	max(year) as last_year, 
	sum(duration) as total_duration
from movies
where id_director is not null -- enlever le groupe avec tous les films sans real
group by id_director
order by count(*) desc;

-- Réponse 1.b
select 
	s.id, s.name,
	count(*) as nb_movies, 
	min(m.year) as first_year, 
	max(m.year) as last_year, 
	sum(m.duration) as total_duration
from movies m join stars s on m.id_director = s.id
group by s.id, s.name
order by count(*) desc;

-- 2. compter le nb d'acteurs par star wars (y compris ceux sans acteurs)
select 
	m.title, m.year, 
	count(p.id_actor) as nb_actor
from
	movies m
	left join play p on m.id = p.id_movie
where 
	m.title like 'Star Wars%'
	and m.title not like '%Deleted%'
group by m.id, m.title, m.year
order by m.year;


-- 3. compter le nb de films joués par acteurs dans la franchise Star Wars
--			avec un cut à au moins 3 films
-- NB : enquete intermédiaire
select s.*, m.*, p.*
from
	movies m
	join play p on m.id = p.id_movie
	join stars s on p.id_actor = s.id
where
	m.title like 'Star Wars%'
	and m.title not like '%Deleted%'
order by s.id, s.name;

-- nb: essayer d'utiliser first_value pour eviter la redondance sur p.role
select 
	s.id, s.name,
	count(m.id) as nb_movies,
	string_agg(p.role, ', ') as roles
from
	movies m
	join play p on m.id = p.id_movie
	join stars s on p.id_actor = s.id
where
	m.title like 'Star Wars%'
	and m.title not like '%Deleted%'
group by s.id, s.name
having count(m.id) >= 3
order by nb_movies desc;

-- prendre le 1er role joué dans la franchise (chronologie de tournage)
select 
	s.id, s.name,
	count(ma.id) as nb_movies,
	ma.first_role,
	string_agg(ma.role, ', ') as roles
from
	( select 
		*,
		first_value(p.role) over (
		partition by p.id_actor 
		order by m.year) as first_role
	  from movies m 
		join play p on m.id = p.id_movie
	  where
		m.title like 'Star Wars%'
		and m.title not like '%Deleted%') ma
	join stars s on ma.id_actor = s.id
group by s.id, s.name, ma.first_role
having count(ma.id) >= 2
order by nb_movies desc;

-- idem avec with
with ma as ( 
	select 
		*,
		first_value(p.role) over (
		partition by p.id_actor 
		order by m.year) as first_role
	  from movies m 
		join play p on m.id = p.id_movie
	  where
		m.title like 'Star Wars%'
		and m.title not like '%Deleted%')
select 
	s.id, s.name,
	count(ma.id) as nb_movies,
	ma.first_role,
	string_agg(ma.role, ', ') as roles
from ma	
	join stars s on ma.id_actor = s.id
group by s.id, s.name, ma.first_role
having count(ma.id) >= 2
order by nb_movies desc;


-- fonctions analytiques (fenetrages)
select
	rank() over (order by duration desc) as rank_d,
	rank() over (partition by year order by duration desc) as rank_yd,
	year, title, duration 
from movies 
order by year desc, duration desc;
-- order by duration desc;

-- sous requetes dépendantes avec exists / not exists
select * from stars s
where exists (select * from movies m where m.id_director = s.id);

-- Exo super bonus :
-- acteurs ayant joué avec tous ces réalisateurs : Eastwood, Scorcese, Spielberg, Tarantino 
-- acteurs ayant joué dans tous les star wars







