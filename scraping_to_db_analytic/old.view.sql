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
       ORDER BY p.oscars DESC, p.name) AS directors,
        (SELECT p.name
           FROM movie_actor ma
           JOIN persons p ON p.id_person = ma.id_person
          WHERE ma.id_allocine = m.id_allocine
       ORDER BY p.oscars DESC, p.name
          LIMIT 1) AS start1,
        (SELECT p.name
           FROM movie_actor ma
           JOIN persons p ON p.id_person = ma.id_person
          WHERE ma.id_allocine = m.id_allocine
       ORDER BY p.oscars DESC, p.name
          LIMIT 1 OFFSET 1) AS start2,
        (SELECT p.name
           FROM movie_actor ma
           JOIN persons p ON p.id_person = ma.id_person
          WHERE ma.id_allocine = m.id_allocine
       ORDER BY p.oscars DESC, p.name
          LIMIT 1 OFFSET 2) AS start3
   FROM movies m
   ;