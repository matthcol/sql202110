-- les titres des films de l'acteur 285
select title
from movies where id in (
	select id_movie 
	from play
	where id_actor = 285);

-- les titres des films jou�s par Alec Baldwin
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

-- titres, ann�es des films, role jou�, date de naissance d'un acteur :
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

-- attention � l'ambiguit�
select * 
from play join stars on id_actor = id 
where name like 'Alec Baldwin';

-- idem (prefixer par nom de table)
select * 
from play join stars on play.id_actor = stars.id 
where stars.name like 'Alec Baldwin';

-- idem (renommage sans mot cl� as)
select * 
from play p join stars s on p.id_actor = s.id 
where s.name like 'Alec Baldwin';

-- idem (renommage avec mot cl� as)
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

-- titres, ann�es et r�alisateur des films de 1984
select m.title, m.year, s.*
from movies m join stars s on m.id_director = s.id
where m.year = 1984
order by title;

-- films o� DiCaprio a collabor� avec Martin Scorcese
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

-- films de star wars avec leur r�alisateur
select *
from movies m join stars s on m.id_director = s.id
where 
	m.title like 'Star Wars%'
	and m.title not like '%Deleted%'
order by year;

-- compter le nb de r�sultats de la requete pr�c�dente
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

-- films de stars wars avec leur r�alisateur (si connu)
select *
from movies m left join stars s on m.id_director = s.id
where 
	m.title like 'Star Wars%'
	and m.title not like '%Deleted%'
order by m.year;

-- idem avec projection des colonnes "int�ressantes"
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

-- fonctions d'agr�gations sur toute la table (ou traitement pr�c�dent)
select 
	-- title,  -- pas possible car pls valeurs � mettre sur 1 ligne
	string_agg(title, ', ') as titles,
	count(*) as nb_movies, 
	min(year) as first_year, max(year) as last_year,
	sum(duration) as total_duration
from movies m 
where 
	m.title like 'Star Wars%'
	and m.title not like '%Deleted%';


-- nb films par ann�e
select year, count(*) as nb_movies
from movies
group by year
order by year;

-- nb films par ann�e dans les ann�es 80
select year, count(*) as nb_movies	-- 4
from movies							-- 1
where year between 1980 and 1989    -- 2
group by year						-- 3
--order by year;
order by nb_movies desc;			-- 5

-- nb films par ann�e dans les ann�es 80 (cut � nb de films >= 20)
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


-- 1. nb films, 1ere ann�e, derni�re ann�e, dur�e totale par r�alisateurs
--	    a. par num�ro de r�alisateur 
--      b. par r�alisateur (au moins le nom, ...)
-- R�ponse 1.a
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

-- 2. compter le nb d'acteurs par star wars (y compris ceux sans acteurs)
-- 3. compter le nb de films jou�s par acteurs dans la franchise Star Wars
--			avec un cut � au moins 3 films







