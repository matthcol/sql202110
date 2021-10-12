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
	name, -- pour vérifier le résultat
	case
		when charindex(' ',name) > 0 
			then substring(name, 1, charindex(' ', name)-1) 
		else name
	end as firstname
from stars
where  name like 'Mado%';

select
	name, -- pour vérifier le résultat
	case
		when name like '% %' 
			then substring(name, 1, charindex(' ', name)-1) 
		else name
	end as firstname
from stars
where  name like 'Mado%';

-- film: Star Wars: Episode VI - Return of the Jedi
select * from movies
where 
	title like 'Star Wars%Return%'
	and title not like '%Deleted%';
-- Réalisateur de ce film : id_director = 549658
select * from stars
where id = 549658;

-- acteurs qui ont joués 'James Bond'
select * from play
where role like 'James Bond'
order by id_actor;

-- élimine les doublons
select distinct id_actor, role
from play
where role like 'James Bond'
order by id_actor;
-- les acteurs :
select * from stars
where id in (112,125,549,1096,184092,185819,493872);

-- Mise à jour des données : insert, update, delete
insert into movies (title, year) 
	values ('Star Wars: Episode I - The Phantom Menace', 1999);
-- 1 ligne ajoutée avec id 12771923

insert into movies (title, year, duration) 
	values ('Star Wars: Episode II - Attack of the Clones', 2002, 142);
-- 1 ligne ajoutée avec id 12771924

-- oubli d'une valeur non null
-- Impossible d'insérer la valeur NULL dans la colonne 'year', table 'dbmovie.dbo.movies'. Cette colonne n'accepte pas les valeurs NULL. Échec de INSERT.
insert into movies (title) 
	values ('Star Wars: Episode III - Revenge of the Sith');

-- donnée du mauvais type (conversion implicite impossible)
-- Échec de la conversion de la valeur varchar 'deux mille cinq' en type de données smallint.
insert into movies (title, year) 
	values ('Star Wars: Episode III - Revenge of the Sith', 'deux mille cinq');

-- Échec de la conversion de la date et/ou de l'heure à partir d'une chaîne de caractères.
insert into stars (name, birthdate) values ('John Doe', '2021-02-29');

-- texte de 316 caractères
select len('Star Wars: Episode III - Revenge of the Sith________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________');

-- texte trop grand :
-- Les données de chaîne ou binaires seraient tronquées dans la table 'dbmovie.dbo.movies', colonne 'title'. Valeur tronquée : 'Star Wars: Episode III - Revenge of the Sith________________________________________________________'.
insert into movies (title, year) 
	values ('Star Wars: Episode III - Revenge of the Sith________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________', 
			2005);

select top 10 * from stars; -- pas de star d'id 5
-- L'instruction INSERT est en conflit avec la contrainte FOREIGN KEY "FK_MOVIES_DIRECTOR". Le conflit s'est produit dans la base de données "dbmovie", table "dbo.stars", column 'id'.
insert into movies (title, year, id_director) 
	values ('Star Wars: Episode III - Revenge of the Sith', 2005, 5);

select * from stars where name like 'George Lucas'; -- id 184
insert into movies (title, year, id_director) 
	values ('Star Wars: Episode III - Revenge of the Sith', 2005, 184);


select * from movies where title like 'Star Wars%' order by year;

-- Le réglage de la containte identity interdit de fourmir la valeur
-- Impossible d'insérer une valeur explicite dans la colonne identité de la table 'stars' quand IDENTITY_INSERT est défini à OFF.
insert into stars (id, name) values (1, 'John Doe');

SET IDENTITY_INSERT stars ON
-- Violation de la contrainte PRIMARY KEY « pk_stars ». Impossible d'insérer une clé en double dans l'objet « dbo.stars ». Valeur de clé dupliquée : (1).
insert into stars (id, name) values (1, 'John Doe');
-- Les valeurs DEFAULT et NULL ne sont pas autorisées comme valeurs d'identité explicites.
insert into stars (id, name) values (NULL, 'John Doe');

-- force id avec valeur nouvelle : ok
insert into stars (id, name) values (5, 'John Doe');

select top 3 * from stars order by id desc; -- max : 11749101
insert into stars (id, name) values (11749300, 'Jane Doe'); -- ok

SET IDENTITY_INSERT stars OFF
insert into stars (name) values ('Zach Braff');
select top 3 * from stars order by id desc; -- 11749301 
-- le generateur d'Id s'est réaligné

-- supprimer ler dernier Zach Braff (il était déjà dans la base)
select * from stars where name like 'Zach Braff';

-- L'instruction DELETE est en conflit avec la contrainte REFERENCE "FK_PLAY_ACTOR". Le conflit s'est produit dans la base de données "dbmovie", table "dbo.play", column 'id_actor'.
delete from stars;

-- L'instruction DELETE est en conflit avec la contrainte REFERENCE "FK_PLAY_ACTOR". Le conflit s'est produit dans la base de données "dbmovie", table "dbo.play", column 'id_actor'.
delete from stars where name like 'Zach Braff';

-- OK
delete from stars where id = 11749301;
select * from stars where name like 'Zach Braff'; -- ok 1 seul a été supprimé

-- ménage dans les stars wars
select * from movies where title like 'Star Wars%' order by year;
-- supprimer les doublons
delete from movies where id in (12771930, 12771931);
-- suprimer les bonus
delete from movies where id = 8924990; -- nok : movie référencé dans play
select * from play where id_movie = 8924990;
delete from play where id_movie = 8924990; 
delete from movies where id = 8924990; -- ok maintenant

select * from movies where title like 'Star Wars%' order by year;

-- modification
update movies set duration = 136 where id = 12771923;
select * from movies where title like 'Star Wars%' order by year;

select * from movies where poster_uri is not null;
-- le film 54215 est un vrac
update movies 
set genres = synopsis, synopsis = poster_uri, poster_uri = genres
where id = 54215;
select * from movies where id = 54215; 






































