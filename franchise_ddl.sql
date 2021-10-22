drop table if exists franchises;

CREATE TABLE [franchises](
	[id] [int] NOT NULL 
		identity
		constraint pk_franchises primary key,
	[name] [varchar](250) NOT NULL
		constraint uniq_franchise_name unique
);

-- 1 film dans une franchise
-- sol 1 : table d'association ; 1 film dans plusieurs franchises
-- sol 2 : colonne extra dans la table movie

alter table movies add 
	id_franchise int NULL
		constraint fk_movies_franchise references franchises(id);


