CREATE DEFINER=`niabadmin`@`%` TRIGGER `movie_w0_hall_bi` BEFORE INSERT ON `movie_w0_hall` FOR EACH ROW BEGIN
    SET NEW.ticket_price = SELECT ticket_price FROM halls WHERE hall_name = NEW.hall_name;
END

CREATE DEFINER=`niabadmin`@`%` TRIGGER `movies_history_bi` BEFORE INSERT ON `movies_history` FOR EACH ROW BEGIN
    SET NEW.history_date = CURDATE();
END

CREATE DEFINER=`niabadmin`@`%` TRIGGER `movies_w0_bi` BEFORE INSERT ON `movies_w0` FOR EACH ROW BEGIN
    SET NEW.release_year = YEAR(NEW.release_date);
END

CREATE DEFINER=`niabadmin`@`%` TRIGGER `movies_w0_ai` AFTER INSERT ON `movies_w0` FOR EACH ROW BEGIN
    DECLARE i_id_allocine INT;
    DECLARE i_id_person   INT;
    DECLARE v_name        VARCHAR(255);
    DECLARE v_separator   VARCHAR(1);
    DECLARE v_start_pos   INT;
    DECLARE v_end_pos     INT;
    
    SET v_separator = '|';
    SET i_id_allocine = NEW.id_allocine;
    
    
    -- --------- --
    -- DIRECTORS --
    -- --------- --
    SET v_start_pos = 1;
    WHILE v_start_pos > 0 AND v_start_pos <= LENGTH(NEW.pivot_director) DO
        SET v_end_pos = LOCATE(v_separator, NEW.pivot_director, v_start_pos);
        
        IF v_end_pos = 0 THEN
            SET v_end_pos = LENGTH(NEW.pivot_director) + 1;
        END IF;
        
        SET v_name = SUBSTRING(NEW.pivot_director, v_start_pos, v_end_pos - v_start_pos);
        
       	INSERT INTO persons (name)
        SELECT v_name
        FROM dual
        WHERE NOT EXISTS (
            SELECT 1 FROM persons WHERE name = v_name
        );
       
       	SELECT id_person INTO i_id_person FROM persons WHERE name = v_name;
       
        INSERT INTO movie_w0_director (id_allocine, id_person)
        SELECT i_id_allocine, i_id_person
        FROM dual
        WHERE NOT EXISTS (
            SELECT 1 FROM movie_w0_director WHERE id_allocine = i_id_allocine AND id_person = i_id_person
        );
        
        SET v_start_pos = v_end_pos + 1;
    END WHILE;
    
    
    -- ------ --
    -- ACTORS --
    -- ------ --
   SET v_start_pos = 1;
    WHILE v_start_pos > 0 AND v_start_pos <= LENGTH(NEW.pivot_casting) DO
        SET v_end_pos = LOCATE(v_separator, NEW.pivot_casting, v_start_pos);
        
        IF v_end_pos = 0 THEN
            SET v_end_pos = LENGTH(NEW.pivot_casting) + 1;
        END IF;
        
        SET v_name = SUBSTRING(NEW.pivot_casting, v_start_pos, v_end_pos - v_start_pos);
        
       	INSERT INTO persons (name)
        SELECT v_name
        FROM dual
        WHERE NOT EXISTS (
            SELECT 1 FROM persons WHERE name = v_name
        );
       
       	SELECT id_person INTO i_id_person FROM persons WHERE name = v_name;
       
        INSERT INTO movie_w0_actor (id_allocine, id_person)
        SELECT i_id_allocine, i_id_person
        FROM dual
        WHERE NOT EXISTS (
            SELECT 1 FROM movie_w0_actor WHERE id_allocine = i_id_allocine AND id_person = i_id_person
        );
        
        SET v_start_pos = v_end_pos + 1;
    END WHILE;
    
    
    -- ------ --
    -- GENRES --
    -- ------ --
   SET v_start_pos = 1;
    WHILE v_start_pos > 0 AND v_start_pos <= LENGTH(NEW.pivot_genres) DO
        SET v_end_pos = LOCATE(v_separator, NEW.pivot_genres, v_start_pos);
        
        IF v_end_pos = 0 THEN
            SET v_end_pos = LENGTH(NEW.pivot_genres) + 1;
        END IF;
        
        SET v_name = SUBSTRING(NEW.pivot_genres, v_start_pos, v_end_pos - v_start_pos);
        
       	INSERT INTO genres (genre)
        SELECT v_name
        FROM dual
        WHERE NOT EXISTS (
            SELECT 1 FROM genres WHERE genre = v_name
        );

        INSERT INTO movie_w0_genre (id_allocine, genre)
        SELECT i_id_allocine, v_name
        FROM dual
        WHERE NOT EXISTS (
            SELECT 1 FROM movie_w0_genre WHERE id_allocine = i_id_allocine AND genre = v_name
        );
        
        SET v_start_pos = v_end_pos + 1;
    END WHILE;
END