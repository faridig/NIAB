 SELECT m.id, m.title, (SELECT ma.person_id
                  FROM movie_actor ma
                  JOIN persons p ON p.id = ma.person_id
                  WHERE ma.movie_id = m.id
                  ORDER BY p.oscars DESC, ma.star DESC
                  LIMIT 1) AS start1,
                  (SELECT ma.person_id
                  FROM movie_actor ma
                  JOIN persons p ON p.id = ma.person_id
                  WHERE ma.movie_id = m.id
                  ORDER BY p.oscars DESC, ma.star DESC
                  LIMIT 1 OFFSET 1) AS start2,
                  (SELECT ma.person_id
                  FROM movie_actor ma
                  JOIN persons p ON p.id = ma.person_id
                  WHERE ma.movie_id = m.id
                  ORDER BY p.oscars DESC, ma.star DESC
                  LIMIT 1 OFFSET 2) AS start3
 FROM movies m