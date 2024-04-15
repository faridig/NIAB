USE niab_analytic;
CREATE PROCEDURE niab_analytic.hydrate_by_film_api_genre(IN a_id_allocine INT ,IN a_genres TEXT)
BEGIN
	DECLARE v_genre     VARCHAR(150);
	DECLARE v_separator VARCHAR(1);
    DECLARE v_start_pos INT;
    DECLARE v_end_pos   INT;
   
    SET v_separator = '|';
   
    SET v_start_pos = 1;
    WHILE v_start_pos > 0 AND v_start_pos <= LENGTH(a_genres) DO
        SET v_end_pos = LOCATE(v_separator, a_genres, v_start_pos);
        
        IF v_end_pos = 0 THEN
            SET v_end_pos = LENGTH(a_genres) + 1;
        END IF;
        
        SET v_genre = SUBSTRING(a_genres, v_start_pos, v_end_pos - v_start_pos);
        
       	IF NOT EXISTS (SELECT 1 FROM genres WHERE genre = v_genre) THEN
			INSERT INTO genres (genre) VALUES (v_genre);
		END IF;
	
		IF NOT EXISTS (SELECT 1
		                 FROM movie_genre mg
		                 JOIN genres g ON g.id_genre = mg.id_genre
		                WHERE mg.id_allocine = a_id_allocine
		                  AND g.genre = v_genre) THEN
			INSERT INTO movie_genre VALUES (a_id_allocine, (SELECT id_genre FROM genres WHERE genre = v_genre));
		END IF;
        
        SET v_start_pos = v_end_pos + 1;
    END WHILE;
END