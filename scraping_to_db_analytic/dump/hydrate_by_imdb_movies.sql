USE niab_analytic;
CREATE PROCEDURE niab_analytic.hydrate_by_imdb_movies()
BEGIN
	DECLARE done INT DEFAULT 0;
	
	DECLARE v_table_from VARCHAR(100);
	DECLARE v_table_to   VARCHAR(100);
	DECLARE v_info       TEXT;
	
	DECLARE i_id_allocine     INT;
	DECLARE t_casting         TEXT;
	DECLARE t_director        TEXT;
	DECLARE i_duration        INT;
	DECLARE i_entries         INT;
	DECLARE v_film_id         VARCHAR(15);
    DECLARE t_genres          TEXT;
    DECLARE v_img_src         VARCHAR(255);
    DECLARE i_release_year    INT;
    DECLARE t_societies       TEXT;
    DECLARE t_synopsis        TEXT;
    DECLARE v_title           VARCHAR(255);
    DECLARE v_budget          VARCHAR(255);
    DECLARE t_nationality     TEXT;
    DECLARE i_us_entries      INT;
    DECLARE v_original_title  VARCHAR(255);
   
    DECLARE pivot_film_api CURSOR FOR 
        SELECT movie_cast, movie_director, movie_length, movie_boxoffice, movie_id,
			   release_year, movie_production_companies, movie_synopsis, movie_title, movie_budget,
			   movie_countries, movie_us_boxoffice, movie_original_title
          FROM pivot_imdb_movies;
         
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- erreur (générale)
-- 	DECLARE EXIT HANDLER FOR SQLEXCEPTION
--     BEGIN
--         INSERT INTO log_pivot
--              VALUES (SYSDATE(), "hydrate_by_imdb_movies", v_table_from, v_table_to, 99999, v_info);
--     END;
   
    -- alerte (générale)
    DECLARE EXIT HANDLER FOR SQLWARNING
	BEGIN
	    INSERT INTO log_pivot
	    VALUES (SYSDATE(), "hydrate_by_imdb_movies", v_table_from, v_table_to, 99998, v_info);
	END;

	-- clé dupliquée
    DECLARE EXIT HANDLER FOR 1062
    BEGIN
        INSERT INTO log_pivot
             VALUES (SYSDATE(), "hydrate_by_imdb_movies", v_table_from, v_table_to, 1062, v_info);
    END;

         
    
    INSERT INTO log_pivot
         VALUES (SYSDATE(), "hydrate_by_imdb_movies", NULL, NULL, 0, "START JOB");
   
    OPEN pivot_film_api;
   	SET v_table_from = "pivot_film_api";
    SET v_info = "INIT";

    read_loop: LOOP
	    
   		SET v_info = "read_loop";
	    FETCH pivot_film_api INTO t_casting, t_director, i_duration, i_entries, v_film_id,
								  i_release_year, t_societies, t_synopsis, v_title, v_budget,
								  t_nationality, i_us_entries, v_original_title;
	    IF done = 1 THEN
	   		LEAVE read_loop;
   		END IF;
   	
		
   		-- MOVIES
	    SET v_table_to = "movies";
	    SET v_info = CONCAT('id_imdb=', v_film_id);
	    IF EXISTS (SELECT 1 FROM movies WHERE LOWER(title) = LOWER(v_title) AND release_year = i_release_year) THEN
		    
		    -- on récupère un id_allocine qui ne soit pas dans la BDD allociné !
	    	INSERT INTO log_pivot
                 VALUES (SYSDATE(), "hydrate_by_imdb_movies", v_table_from, v_table_to, 200, v_info);
	    	SELECT id_allocine INTO i_id_allocine FROM movies WHERE LOWER(title) = LOWER(v_title) AND release_year = i_release_year;
	    	INSERT INTO log_pivot
                 VALUES (SYSDATE(), "hydrate_by_imdb_movies", v_table_from, v_table_to, 201, CONCAT('i_id_allocine=', i_id_allocine));
                
	    	UPDATE movies
	    	   SET imdb_id = v_film_id,
	    	       imdb_entries = i_entries,
	    	       imdb_us_entries = i_us_entries
	    	 WHERE id_allocine = i_id_allocine;
	                    
	        INSERT INTO log_pivot
                 VALUES (SYSDATE(), "hydrate_by_imdb_movies", v_table_from, v_table_to, 0, v_info);
                
	    ELSE
	    
	    	-- on récupère un id_allocine qui ne soit pas dans la BDD allociné !
	    	INSERT INTO log_pivot
                 VALUES (SYSDATE(), "hydrate_by_imdb_movies", v_table_from, v_table_to, 100, v_info);
		    SELECT IF(MAX(id_allocine) < 400000, 400000, MAX(id_allocine) + 1) INTO i_id_allocine FROM movies;
		    INSERT INTO log_pivot
                 VALUES (SYSDATE(), "hydrate_by_imdb_movies", v_table_from, v_table_to, 101, CONCAT('i_id_allocine=', i_id_allocine));
	    
	    	INSERT INTO movies (id_allocine, title, release_year, original_title, duration_m,
	                            public_rating, vote_count, press_rating, audience, synopsis,
	                            poster_link, release_date, societies, budget, nationality,
	                            entries, imdb_id, imdb_entries, imdb_us_entries)
	             VALUES (i_id_allocine, v_title, i_release_year, v_original_title, i_duration,
	                     NULL, NULL, NULL, NULL, t_synopsis,
	                     NULL, NULL, t_societies, v_budget, t_nationality,
	                     NULL, v_film_id, i_entries, i_us_entries);
	    
	    	INSERT INTO log_pivot
                 VALUES (SYSDATE(), "hydrate_by_imdb_movies", v_table_from, v_table_to, 1, v_info);
                
	    END IF;
	    
	   
	   	-- ACTORS
	    SET v_table_to = "persons+movie_actor";
	    SET v_info = CONCAT('id_allocine=', i_id_allocine,' / t_casting=', t_casting);
	    INSERT INTO log_pivot
                 VALUES (SYSDATE(), "hydrate_by_imdb_movies", v_table_from, v_table_to, 3, v_info);
	    CALL niab_analytic.hydrate_by_film_api_actor(i_id_allocine, t_casting);
	    
	   
	   	-- DIRECTORS
	    SET v_table_to = "persons+movie_director";
	    SET v_info = CONCAT('id_allocine=', i_id_allocine,' / t_director=', t_director);
	    INSERT INTO log_pivot
                 VALUES (SYSDATE(), "hydrate_by_imdb_movies", v_table_from, v_table_to, 4, v_info);
	    CALL niab_analytic.hydrate_by_film_api_director(i_id_allocine, t_director);
	   
	    
    END LOOP;

    CLOSE pivot_film_api;
    
    INSERT INTO log_pivot
         VALUES (SYSDATE(), "hydrate_by_imdb_movies", NULL, NULL, 0, "GOOD JOB");
   
    COMMIT;
	
END