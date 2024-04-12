USE niab_analytic;
CREATE PROCEDURE niab_analytic.hydrate_by_film_api_director(IN a_id_allocine INT ,IN a_directors TEXT)
BEGIN
	DECLARE v_name      VARCHAR(255);
	DECLARE v_separator VARCHAR(1);
    DECLARE v_start_pos INT;
    DECLARE v_end_pos   INT;
   
    SET v_separator = '|';
   
    SET v_start_pos = 1;
    WHILE v_start_pos > 0 AND v_start_pos <= LENGTH(a_directors) DO
        SET v_end_pos = LOCATE(v_separator, a_directors, v_start_pos);
        
        IF v_end_pos = 0 THEN
            SET v_end_pos = LENGTH(a_directors) + 1;
        END IF;
        
        SET v_name = SUBSTRING(a_directors, v_start_pos, v_end_pos - v_start_pos);
        
       	IF NOT EXISTS (SELECT 1 FROM persons WHERE name = v_name) THEN
			INSERT INTO persons (name) VALUES (v_name);
		END IF;
	
		IF NOT EXISTS (SELECT 1
		                 FROM movie_director md
		                 JOIN persons p ON p.id_person = md.id_person
		                WHERE md.id_allocine = a_id_allocine
		                  AND p.name = v_name) THEN
			INSERT INTO movie_director VALUES (a_id_allocine, (SELECT id_person FROM persons WHERE name = v_name));
		END IF;
        
        SET v_start_pos = v_end_pos + 1;
    END WHILE;
END