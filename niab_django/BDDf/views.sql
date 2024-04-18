CREATE OR REPLACE
ALGORITHM = UNDEFINED VIEW `movies_actor_oscars` AS
  SELECT m.id_allocine, COUNT(1) all_actor_oscars
    FROM movies_w0 m
    JOIN movie_w0_actor ma ON ma.id_allocine = m.id_allocine 
    JOIN persons p ON p.id_person = ma.id_person 
    JOIN pred_oscars po ON po.winner = p.name
   WHERE po.year < m.release_year
GROUP BY m.id_allocine;

CREATE OR REPLACE
ALGORITHM = UNDEFINED VIEW `movies_director_oscars` AS
  SELECT m.id_allocine, COUNT(1) all_director_oscars
    FROM movies_w0 m 
    JOIN movie_w0_director md ON md.id_allocine = m.id_allocine
    JOIN persons p ON p.id_person = md.id_person 
    JOIN pred_oscars po ON po.winner = m.title 
   WHERE po.category IN ('Best Motion Picture of the Year',
                         'Best Picture',
                         'Best Achievement in Directing',
                         'Best Director')
GROUP BY m.id_allocine;

CREATE OR REPLACE
ALGORITHM = UNDEFINED VIEW `movies_rank_celebrity` AS
  SELECT m.id_allocine, SUM(101 - pimpc.rank_celebrity) actor_celebs
    FROM movies_w0 m 
    JOIN movie_w0_actor ma ON ma.id_allocine = m.id_allocine
    JOIN persons p ON p.id_person = ma.id_person
    JOIN pred_imdb_most_popular_celebs pimpc ON pimpc.name = p.name
GROUP BY m.id_allocine;

CREATE OR REPLACE
ALGORITHM = UNDEFINED VIEW `movies_rank_celebrity_by_year` AS
  SELECT m.id_allocine, SUM(31 - paad.rank_id) actor_celebs
    FROM movies_w0 m 
    JOIN movie_w0_actor ma ON ma.id_allocine = m.id_allocine
    JOIN persons p ON p.id_person = ma.id_person
    JOIN pred_actors_actresses_directors paad ON LOWER(paad.name) = LOWER(p.name)
                                              AND m.release_year >= paad.start_year
                                              AND m.release_year <= paad.stop_year
GROUP BY m.id_allocine;

CREATE OR REPLACE
ALGORITHM = UNDEFINED VIEW `movies_people` AS
  SELECT m.id_allocine,
  		 ROUND(AVG(CASE WHEN pp.role IN ('Acteur', 'Actrice') THEN pp.entries_mean ELSE 0 END), 0) entries_mean_actor,
  		 SUM(CASE WHEN pp.role IN ('Acteur', 'Actrice') THEN pp.entries_sum ELSE 0 END) entries_sum_actor,
  		 ROUND(AVG(CASE WHEN pp.role IN ('Réalisateur', 'Réalisatrice', 'Réalisaeur', 'Réalisateurs') THEN pp.entries_mean ELSE 0 END), 0) entries_mean_director,
  		 SUM(CASE WHEN pp.role IN ('Réalisateur', 'Réalisatrice', 'Réalisaeur', 'Réalisateurs') THEN pp.entries_sum ELSE 0 END) entries_sum_director,
  		 ROUND(AVG(CASE WHEN pp.role IN ('Compositeur') THEN pp.entries_mean ELSE 0 END), 0) entries_mean_composer,
   		 SUM(CASE WHEN pp.role IN ('Compositeur') THEN pp.entries_sum ELSE 0 END) entries_sum_composer
    FROM movies_w0 m 
    JOIN movie_w0_actor ma ON ma.id_allocine = m.id_allocine
    JOIN persons p ON p.id_person = ma.id_person
    JOIN pred_people pp ON pp.name = p.name
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
    FROM movies_w0 m 
    LEFT OUTER JOIN pred_vacances_francaise pvf ON m.release_date >= pvf.start_date
                                                AND m.release_date <= pvf.stop_date
GROUP BY m.id_allocine;

CREATE OR REPLACE
ALGORITHM = UNDEFINED VIEW `db_to_model` AS
SELECT m.id_allocine,
       m.title,
       (SELECT GROUP_CONCAT(mg.genre SEPARATOR ',')
          FROM movie_w0_genre mg
         WHERE mg.id_allocine = m.id_allocine
      ORDER BY mg.genre) AS genres,
       m.duration duration_m,
       m.synopsis,
       DATE_FORMAT(m.release_date, '%Y-%m-%d') release_date,
       m.societies,
       m.nationality,
       (SELECT GROUP_CONCAT(p.name SEPARATOR ',')
          FROM movie_w0_director md
          JOIN persons p ON p.id_person = md.id_person
         WHERE md.id_allocine = m.id_allocine
      ORDER BY p.name) AS directors,
       mdo.all_director_oscars,
       mao.all_actor_oscars,
       mrc.actor_celebs,
       mrcby.actor_celebs actor_celebs_by_year,
       mp.entries_mean_actor,
       mp.entries_sum_actor,
       mp.entries_mean_director,
       mp.entries_sum_director,
       mp.entries_mean_composer,
       mp.entries_sum_composer,
       m.copies jpbox_copies
  FROM movies_w0 m
  LEFT OUTER JOIN movies_director_oscars mdo ON mdo.id_allocine = m.id_allocine
  LEFT OUTER JOIN movies_actor_oscars mao ON mao.id_allocine = m.id_allocine
  LEFT OUTER JOIN movies_rank_celebrity mrc ON mrc.id_allocine = m.id_allocine
  LEFT OUTER JOIN movies_rank_celebrity_by_year mrcby ON mrcby.id_allocine = m.id_allocine
  LEFT OUTER JOIN movies_people mp ON mp.id_allocine = m.id_allocine
  LEFT OUTER JOIN movies_en_vacances mev ON mev.id_allocine = m.id_allocine;
  
CREATE OR REPLACE
ALGORITHM = UNDEFINED VIEW `w0_directors` AS
  SELECT mw.id_allocine, GROUP_CONCAT(p.name SEPARATOR ',') directors
    FROM movies_w0 mw 
    LEFT OUTER JOIN movie_w0_director mwd ON mwd.id_allocine = mw.id_allocine
    LEFT OUTER JOIN persons p ON p.id_person = mwd.id_person
GROUP BY mw.id_allocine;

CREATE OR REPLACE
ALGORITHM = UNDEFINED VIEW `w1_directors` AS
  SELECT mw.id_allocine, GROUP_CONCAT(p.name SEPARATOR ',') directors
    FROM movies_w1 mw 
    LEFT OUTER JOIN movie_w1_director mwd ON mwd.id_allocine = mw.id_allocine
    LEFT OUTER JOIN persons p ON p.id_person = mwd.id_person
GROUP BY mw.id_allocine;

CREATE OR REPLACE
ALGORITHM = UNDEFINED VIEW `w0_actors` AS
  SELECT mw.id_allocine, GROUP_CONCAT(p.name SEPARATOR ',') actors
    FROM movies_w0 mw 
    LEFT OUTER JOIN movie_w0_actor mwd ON mwd.id_allocine = mw.id_allocine
    LEFT OUTER JOIN persons p ON p.id_person = mwd.id_person
GROUP BY mw.id_allocine;

CREATE OR REPLACE
ALGORITHM = UNDEFINED VIEW `w1_actors` AS
  SELECT mw.id_allocine, GROUP_CONCAT(p.name SEPARATOR ',') actors
    FROM movies_w1 mw 
    LEFT OUTER JOIN movie_w1_actor mwd ON mwd.id_allocine = mw.id_allocine
    LEFT OUTER JOIN persons p ON p.id_person = mwd.id_person
GROUP BY mw.id_allocine;

CREATE OR REPLACE
ALGORITHM = UNDEFINED VIEW `w0_genres` AS
  SELECT mw.id_allocine, GROUP_CONCAT(g.genre SEPARATOR ',') genres
    FROM movies_w0 mw 
    LEFT OUTER JOIN movie_w0_genre mwd ON mwd.id_allocine = mw.id_allocine
    LEFT OUTER JOIN genres g ON g.genre = mwd.genre
GROUP BY mw.id_allocine;

CREATE OR REPLACE
ALGORITHM = UNDEFINED VIEW `w1_genres` AS
  SELECT mw.id_allocine, GROUP_CONCAT(g.genre SEPARATOR ',') genres
    FROM movies_w1 mw 
    LEFT OUTER JOIN movie_w1_genre mwd ON mwd.id_allocine = mw.id_allocine
    LEFT OUTER JOIN genres g ON g.genre = mwd.genre
GROUP BY mw.id_allocine;

CREATE OR REPLACE
ALGORITHM = UNDEFINED VIEW `w0_halls` AS
  SELECT mw.id_allocine, GROUP_CONCAT(mwh.hall_name SEPARATOR ',') halls
    FROM movies_w0 mw
    LEFT OUTER JOIN movie_w0_hall mwh ON mwh.id_allocine = mw.id_allocine
GROUP BY mw.id_allocine;

CREATE OR REPLACE
ALGORITHM = UNDEFINED VIEW `w1_halls` AS
  SELECT mw.id_allocine, GROUP_CONCAT(mwh.hall_name SEPARATOR ',') halls
    FROM movies_w1 mw
    LEFT OUTER JOIN movie_w0_hall mwh ON mwh.id_allocine = mw.id_allocine
GROUP BY mw.id_allocine;

CREATE OR REPLACE
ALGORITHM = UNDEFINED VIEW `w0_movies` AS
  SELECT mw.id_allocine, mw.title, mw.img_src, wd.directors, wa.actors,
         wg.genres, wh.halls, mw.pred_entries
    FROM movies_w0 mw
    LEFT OUTER JOIN w0_directors wd ON wd.id_allocine = mw.id_allocine
    LEFT OUTER JOIN w0_actors wa ON wa.id_allocine = mw.id_allocine
    LEFT OUTER JOIN w0_genres wg ON wg.id_allocine = mw.id_allocine
    LEFT OUTER JOIN w0_halls wh ON wh.id_allocine = mw.id_allocine
GROUP BY mw.id_allocine;

CREATE OR REPLACE
ALGORITHM = UNDEFINED VIEW `w0_movies` AS
  SELECT mw.id_allocine, mw.pred_entries, mw.title, mw.img_src, wd.directors,
         wa.actors, wg.genres, wh.halls
    FROM movies_w0 mw
    LEFT OUTER JOIN w0_directors wd ON wd.id_allocine = mw.id_allocine
    LEFT OUTER JOIN w0_actors wa ON wa.id_allocine = mw.id_allocine
    LEFT OUTER JOIN w0_genres wg ON wg.id_allocine = mw.id_allocine
    LEFT OUTER JOIN w0_halls wh ON wh.id_allocine = mw.id_allocine
GROUP BY mw.id_allocine;