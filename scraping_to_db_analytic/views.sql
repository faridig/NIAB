CREATE OR REPLACE
ALGORITHM = UNDEFINED VIEW `movies_actor_oscars` AS
  SELECT m.id_allocine, COUNT(1) all_actor_oscars
    FROM movies m 
    JOIN movie_actor ma ON ma.id_allocine = m.id_allocine 
    JOIN persons p ON p.id_person = ma.id_person 
    JOIN pivot_oscars po ON LOWER(po.winner) = LOWER(p.name )
   WHERE po.year < m.release_year
GROUP BY m.id_allocine;

CREATE OR REPLACE
ALGORITHM = UNDEFINED VIEW `movies_director_oscars` AS
  SELECT m.id_allocine, COUNT(1) all_director_oscars
    FROM movies m 
    JOIN movie_director md ON md.id_allocine = m.id_allocine
    JOIN persons p ON p.id_person = md.id_person 
    JOIN pivot_oscars po ON LOWER(po.winner) = LOWER(m.title) 
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
    JOIN pivot_imdb_most_popular_celebs pimpc ON LOWER(pimpc.name) = LOWER(p.name)
GROUP BY m.id_allocine

CREATE OR REPLACE
ALGORITHM = UNDEFINED VIEW `db_to_ml` AS
SELECT m.title,
       m.release_year,
       m.original_title,
       (SELECT GROUP_CONCAT(g.genre SEPARATOR ', ')
          FROM movie_genre mg
          JOIN genres g ON g.id_genre = mg.id_genre
         WHERE mg.id_allocine = m.id_allocine
      ORDER BY g.genre) AS genres,
       m.duration_m,
       m.public_rating,
       m.vote_count,
       m.press_rating,
       m.audience,
       m.synopsis,
       m.poster_link,
       (SELECT GROUP_CONCAT(p.name SEPARATOR ', ')
          FROM movie_director md
          JOIN persons p ON p.id_person = md.id_person
         WHERE md.id_allocine = m.id_allocine
      ORDER BY p.name) AS directors,
       mdo.all_director_oscars,
       mao.all_actor_oscars,
       mrc.actor_celebs
  FROM movies m
  LEFT OUTER JOIN movies_director_oscars mdo ON mdo.id_allocine = m.id_allocine
  LEFT OUTER JOIN movies_actor_oscars mao ON mao.id_allocine = m.id_allocine
  LEFT OUTER JOIN movies_rank_celebrity mrc ON mrc.id_allocine = m.id_allocine;