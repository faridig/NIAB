USE niab_analytic;
CREATE PROCEDURE niab_analytic.hydrate_by_film_api()
BEGIN
	DECLARE done INT DEFAULT 0;
	
	DECLARE v_table_from VARCHAR(100);
	DECLARE v_table_to   VARCHAR(100);
	DECLARE v_info       TEXT;

	DECLARE t_casting         TEXT;
	DECLARE t_director        TEXT;
	DECLARE i_duration        INT;
	DECLARE i_entries         INT;
	DECLARE i_film_id         INT;
    DECLARE t_genres          TEXT;
    DECLARE v_img_src         VARCHAR(255);
    DECLARE i_press_ratings   INT;
    DECLARE i_release_date    VARCHAR(30);
    DECLARE t_societies       TEXT;
    DECLARE t_synopsis        TEXT;
    DECLARE v_title           VARCHAR(255);
    DECLARE i_viewers_ratings INT;
   
    DECLARE pivot_film_api CURSOR FOR 
        SELECT casting, director, duration, entries, film_id,
			   genres, img_src, press_ratings, release_date, societies,
			   synopsis, title, viewers_ratings
          FROM pivot_film_api;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- erreur (générale)
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        INSERT INTO log_pivot
             VALUES (SYSDATE(), "hydrate_by_film_api", v_table_from, v_table_to, 99999, v_info);
    END;
   
    -- alerte (générale)
    DECLARE EXIT HANDLER FOR SQLWARNING
	BEGIN
	    INSERT INTO log_pivot
	    VALUES (SYSDATE(), "hydrate_by_film_api", v_table_from, v_table_to, 99998, v_info);
	END;

	-- clé dupliquée
    DECLARE EXIT HANDLER FOR 1062
    BEGIN
        INSERT INTO log_pivot
             VALUES (SYSDATE(), "hydrate_by_film_api", v_table_from, v_table_to, 1062, v_info);
    END;

         
    
    INSERT INTO log_pivot
         VALUES (SYSDATE(), "hydrate_by_film_api", NULL, NULL, 0, "START JOB");
   
    OPEN pivot_film_api;
   	SET v_table_from = "pivot_film_api";
    SET v_info = "INIT";

    read_loop: LOOP
	    
   		SET v_info = "read_loop";
	    FETCH pivot_film_api INTO t_casting, t_director, i_duration, i_entries, i_film_id,
	                              t_genres, v_img_src, i_press_ratings, i_release_date, t_societies,
	                              t_synopsis, v_title, i_viewers_ratings;
	    IF done = 1 THEN
	   		LEAVE read_loop;
   		END IF;
		
   		-- MOVIES
	    SET v_table_to = "movies";
	    SET v_info = CONCAT('id_allocine=', i_film_id);
	    IF NOT EXISTS (SELECT 1 FROM movies WHERE id_allocine = i_film_id) THEN
		    INSERT INTO movies (id_allocine, title, release_year, original_title, duration_m,
	                            public_rating, vote_count, press_rating, audience, synopsis,
	                            poster_link)
	             VALUES (i_film_id, v_title, SUBSTRING(i_release_date, CHAR_LENGTH(i_release_date) - 3), NULL, i_duration,
	                     i_viewers_ratings, NULL, i_press_ratings, NULL, t_synopsis,
	                     v_img_src);
	        INSERT INTO log_pivot
                 VALUES (SYSDATE(), "hydrate_by_film_api", v_table_from, v_table_to, 0, v_info);
	    ELSE
	    	INSERT INTO log_pivot
                 VALUES (SYSDATE(), "hydrate_by_film_api", v_table_from, v_table_to, 1, v_info);
	    END IF;
	    
	   
	   	-- GENRES
	    SET v_table_to = "genres+movie_genre";
	    SET v_info = CONCAT('id_allocine=', i_film_id,' / t_genres=', t_genres);
	    INSERT INTO log_pivot
                 VALUES (SYSDATE(), "hydrate_by_film_api", v_table_from, v_table_to, 2, v_info);
	    CALL niab_analytic.hydrate_by_film_api_genre(i_film_id, t_genres);
	    
	   
	   	-- ACTORS
	    SET v_table_to = "persons+movie_actor";
	    SET v_info = CONCAT('id_allocine=', i_film_id,' / t_casting=', t_casting);
	    INSERT INTO log_pivot
                 VALUES (SYSDATE(), "hydrate_by_film_api", v_table_from, v_table_to, 3, v_info);
	    CALL niab_analytic.hydrate_by_film_api_actor(i_film_id, t_casting);
	    
	   
	   	-- DIRECTORS
	    SET v_table_to = "persons+movie_director";
	    SET v_info = CONCAT('id_allocine=', i_film_id,' / t_director=', t_director);
	    INSERT INTO log_pivot
                 VALUES (SYSDATE(), "hydrate_by_film_api", v_table_from, v_table_to, 4, v_info);
	    CALL niab_analytic.hydrate_by_film_api_director(i_film_id, t_director);
	   
	    
    END LOOP;

    CLOSE pivot_film_api;
    
    INSERT INTO log_pivot
         VALUES (SYSDATE(), "hydrate_by_film_api", NULL, NULL, 0, "GOOD JOB");
   
    COMMIT;
	
END