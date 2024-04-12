USE niab_analytic;
CREATE PROCEDURE niab_analytic.hydrate_by_film_api_actor(IN a_id_allocine INT ,IN a_actors TEXT)
BEGIN
	DECLARE v_name      VARCHAR(255);
	DECLARE v_separator VARCHAR(1);
    DECLARE v_start_pos INT;
    DECLARE v_end_pos   INT;
   
    SET v_separator = '|';
   
    SET v_start_pos = 1;
    WHILE v_start_pos > 0 AND v_start_pos <= LENGTH(a_actors) DO
        SET v_end_pos = LOCATE(v_separator, a_actors, v_start_pos);
        
        IF v_end_pos = 0 THEN
            SET v_end_pos = LENGTH(a_actors) + 1;
        END IF;
        
        SET v_name = SUBSTRING(a_actors, v_start_pos, v_end_pos - v_start_pos);
        
       	IF NOT EXISTS (SELECT 1 FROM persons WHERE name = v_name) THEN
			INSERT INTO persons (name) VALUES (v_name);
		END IF;
	
		IF NOT EXISTS (SELECT 1
		                 FROM movie_actor ma
		                 JOIN persons p ON p.id_person = ma.id_person
		                WHERE ma.id_allocine = a_id_allocine
		                  AND p.name = v_name) THEN
			INSERT INTO movie_actor VALUES (a_id_allocine, (SELECT id_person FROM persons WHERE name = v_name));
		END IF;
        
        SET v_start_pos = v_end_pos + 1;
    END WHILE;
END