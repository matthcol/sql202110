insert into franchises (name) values ('Star Wars');
insert into franchises (name) values ('Disney');
insert into franchises (name) values ('Disney');

select * from franchises;

update movies 
set id_franchise = 1
where title like 'Star Wars%'
	and title not like '%Deleted%';

select * 
from movies m join franchises f on m.id_franchise = f.id
where title like 'Star Wars%';

	and title not like '%Deleted%';