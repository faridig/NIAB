CREATE OR REPLACE
ALGORITHM = UNDEFINED VIEW `movies_actor_oscars` AS
  SELECT m.id_allocine, COUNT(1) all_actor_oscars
    FROM movies m 
    JOIN movie_actor ma ON ma.id_allocine = m.id_allocine 
    JOIN persons p ON p.id_person = ma.id_person 
    JOIN pivot_oscars po ON po.winner = p.name
   WHERE po.year < m.release_year
GROUP BY m.id_allocine;

CREATE OR REPLACE
ALGORITHM = UNDEFINED VIEW `movies_director_oscars` AS
  SELECT m.id_allocine, COUNT(1) all_director_oscars
    FROM movies m 
    JOIN movie_director md ON md.id_allocine = m.id_allocine
    JOIN persons p ON p.id_person = md.id_person 
    JOIN pivot_oscars po ON po.winner = m.title 
   WHERE po.category IN ('Best Motion Picture of the Year',
                         'Best Picture',
                         'Best Achievement in Directing',
                         'Best Director')
GROUP BY m.id_allocine;

CREATE OR REPLACE
ALGORITHM = UNDEFINED VIEW `movies_rank_celebrity` AS
  SELECT m.id_allocine, SUM(101 - pimpc.rank_celebrity) actor_celebs
    FROM movies m 
    JOIN movie_actor ma ON ma.id_allocine = m.id_allocine
    JOIN persons p ON p.id_person = ma.id_person
    JOIN pivot_imdb_most_popular_celebs pimpc ON pimpc.name = p.name
GROUP BY m.id_allocine;

CREATE OR REPLACE
ALGORITHM = UNDEFINED VIEW `movies_rank_celebrity_by_year` AS
  SELECT m.id_allocine, SUM(31 - paad.rank_id) actor_celebs
    FROM movies m 
    JOIN movie_actor ma ON ma.id_allocine = m.id_allocine
    JOIN persons p ON p.id_person = ma.id_person
    JOIN pivot_actors_actresses_directors paad ON LOWER(paad.name) = LOWER(p.name)
                                              AND m.release_year >= paad.start_year
                                              AND m.release_year <= paad.stop_year
GROUP BY m.id_allocine;

CREATE OR REPLACE
ALGORITHM = UNDEFINED VIEW `jpbox` AS
  SELECT m.id_allocine, pj.jp_copies copies
    FROM movies m
    JOIN pivot_jpbox pj ON LOWER(pj.jp_title) = LOWER(m.title)
                       AND pj.jp_release  = m.release_date;

CREATE OR REPLACE
ALGORITHM = UNDEFINED VIEW `movies_people` AS
  SELECT m.id_allocine,
  		 ROUND(AVG(CASE WHEN pp.role IN ('Acteur', 'Actrice') THEN pp.entries_mean ELSE 0 END), 0) entries_mean_actor,
  		 SUM(CASE WHEN pp.role IN ('Acteur', 'Actrice') THEN pp.entries_sum ELSE 0 END) entries_sum_actor,
  		 ROUND(AVG(CASE WHEN pp.role IN ('Réalisateur', 'Réalisatrice', 'Réalisaeur', 'Réalisateurs') THEN pp.entries_mean ELSE 0 END), 0) entries_mean_director,
  		 SUM(CASE WHEN pp.role IN ('Réalisateur', 'Réalisatrice', 'Réalisaeur', 'Réalisateurs') THEN pp.entries_sum ELSE 0 END) entries_sum_director,
  		 ROUND(AVG(CASE WHEN pp.role IN ('Compositeur') THEN pp.entries_mean ELSE 0 END), 0) entries_mean_composer,
   		 SUM(CASE WHEN pp.role IN ('Compositeur') THEN pp.entries_sum ELSE 0 END) entries_sum_composer
    FROM movies m 
    JOIN movie_actor ma ON ma.id_allocine = m.id_allocine
    JOIN persons p ON p.id_person = ma.id_person
    JOIN pivot_people pp ON pp.name = p.name
GROUP BY m.id_allocine;

CREATE OR REPLACE
ALGORITHM = UNDEFINED VIEW `movies_en_vacances` AS
  SELECT m.id_allocine,
         SUM(CASE WHEN pvf.vacances = "vacances d'Automne" THEN 1 ELSE 0 END) vacances_automne,
         SUM(CASE WHEN pvf.vacances = "vacances de Noël" THEN 1 ELSE 0 END) vacances_noel,
         SUM(CASE WHEN pvf.vacances = "vacances d'Hiver" THEN 1 ELSE 0 END) vacances_hiver,
         SUM(CASE WHEN pvf.vacances = "vacances de Printemps" THEN 1 ELSE 0 END) vacances_printemps,
         SUM(CASE WHEN pvf.vacances = "vacances d'Été" THEN 1 ELSE 0 END) vacances_ete,
         COUNT(pvf.zone) nb_zone_en_vacances
    FROM movies m 
    LEFT OUTER JOIN pivot_vacances_francaise pvf ON m.release_date >= pvf.start_date
                                                AND m.release_date <= pvf.stop_date
GROUP BY m.id_allocine;

CREATE OR REPLACE
ALGORITHM = UNDEFINED VIEW `db_to_ml` AS
SELECT m.id_allocine,
       m.title,
       m.release_year,
       m.original_title,
       (SELECT GROUP_CONCAT(g.genre SEPARATOR ',')
          FROM movie_genre mg
          JOIN genres g ON g.id_genre = mg.id_genre
         WHERE mg.id_allocine = m.id_allocine
      ORDER BY g.genre) AS genres,
       m.duration_m,
       m.synopsis,
       m.poster_link,
       m.release_date,
       m.societies,
       m.budget,
       m.nationality,
       (SELECT GROUP_CONCAT(p.name SEPARATOR ',')
          FROM movie_director md
          JOIN persons p ON p.id_person = md.id_person
         WHERE md.id_allocine = m.id_allocine
      ORDER BY p.name) AS directors,
       mdo.all_director_oscars,
       mao.all_actor_oscars,
       mrc.actor_celebs,
       mrcby.actor_celebs actor_celebs_by_year,
       mev.vacances_automne,
       mev.vacances_noel,
       mev.vacances_hiver,
       mev.vacances_printemps,
       mev.vacances_ete,
       mev.nb_zone_en_vacances,
       mp.entries_mean_actor,
       mp.entries_sum_actor,
       mp.entries_mean_director,
       mp.entries_sum_director,
       mp.entries_mean_composer,
       mp.entries_sum_composer,
       j.copies jpbox_copies,
       m.imdb_entries,
       m.imdb_us_entries,
       m.imdb_id,
       m.entries
  FROM movies m
  LEFT OUTER JOIN movies_director_oscars mdo ON mdo.id_allocine = m.id_allocine
  LEFT OUTER JOIN movies_actor_oscars mao ON mao.id_allocine = m.id_allocine
  LEFT OUTER JOIN movies_rank_celebrity mrc ON mrc.id_allocine = m.id_allocine
  LEFT OUTER JOIN movies_rank_celebrity_by_year mrcby ON mrcby.id_allocine = m.id_allocine
  LEFT OUTER JOIN movies_people mp ON mp.id_allocine = m.id_allocine
  LEFT OUTER JOIN jpbox j ON j.id_allocine = m.id_allocine
  LEFT OUTER JOIN movies_en_vacances mev ON mev.id_allocine = m.id_allocine;
