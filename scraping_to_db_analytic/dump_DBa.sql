-- MySQL dump 10.13  Distrib 8.0.36, for Linux (x86_64)
--
-- Host: localhost    Database: niab_analytic
-- ------------------------------------------------------
-- Server version	8.0.36-0ubuntu0.22.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Temporary view structure for view `db_to_ml`
--

DROP TABLE IF EXISTS `db_to_ml`;
/*!50001 DROP VIEW IF EXISTS `db_to_ml`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `db_to_ml` AS SELECT 
 1 AS `title`,
 1 AS `release_year`,
 1 AS `original_title`,
 1 AS `genres`,
 1 AS `duration_m`,
 1 AS `public_rating`,
 1 AS `vote_count`,
 1 AS `press_rating`,
 1 AS `audience`,
 1 AS `synopsis`,
 1 AS `poster_link`,
 1 AS `directors`,
 1 AS `start1`,
 1 AS `start2`,
 1 AS `start3`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `genres`
--

DROP TABLE IF EXISTS `genres`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `genres` (
  `id_genre` smallint NOT NULL AUTO_INCREMENT,
  `genre` varchar(150) NOT NULL,
  PRIMARY KEY (`id_genre`),
  UNIQUE KEY `genres_unique` (`genre`)
) ENGINE=InnoDB AUTO_INCREMENT=173 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `log_pivot`
--

DROP TABLE IF EXISTS `log_pivot`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log_pivot` (
  `audit_time` datetime NOT NULL,
  `procedure` varchar(100) NOT NULL,
  `table_from` varchar(100) DEFAULT NULL,
  `table_to` varchar(100) DEFAULT NULL,
  `error` mediumint NOT NULL,
  `info` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  KEY `log_pivot_audit_time_IDX` (`audit_time`) USING BTREE,
  KEY `log_pivot_procedure_IDX` (`procedure`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `movie_actor`
--

DROP TABLE IF EXISTS `movie_actor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `movie_actor` (
  `id_allocine` mediumint NOT NULL,
  `id_person` mediumint NOT NULL,
  PRIMARY KEY (`id_allocine`,`id_person`),
  KEY `movie_actor_persons_FK` (`id_person`),
  CONSTRAINT `movie_actor_movies_FK` FOREIGN KEY (`id_allocine`) REFERENCES `movies` (`id_allocine`) ON DELETE CASCADE,
  CONSTRAINT `movie_actor_persons_FK` FOREIGN KEY (`id_person`) REFERENCES `persons` (`id_person`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `movie_director`
--

DROP TABLE IF EXISTS `movie_director`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `movie_director` (
  `id_allocine` mediumint NOT NULL,
  `id_person` mediumint NOT NULL,
  PRIMARY KEY (`id_allocine`,`id_person`),
  KEY `movie_director_persons_FK` (`id_person`),
  CONSTRAINT `movie_director_movies_FK` FOREIGN KEY (`id_allocine`) REFERENCES `movies` (`id_allocine`) ON DELETE CASCADE,
  CONSTRAINT `movie_director_persons_FK` FOREIGN KEY (`id_person`) REFERENCES `persons` (`id_person`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `movie_genre`
--

DROP TABLE IF EXISTS `movie_genre`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `movie_genre` (
  `id_allocine` mediumint NOT NULL,
  `id_genre` smallint NOT NULL,
  PRIMARY KEY (`id_allocine`,`id_genre`),
  KEY `movie_genre_genres_FK` (`id_genre`),
  CONSTRAINT `movie_genre_genres_FK` FOREIGN KEY (`id_genre`) REFERENCES `genres` (`id_genre`) ON DELETE CASCADE,
  CONSTRAINT `movie_genre_movies_FK` FOREIGN KEY (`id_allocine`) REFERENCES `movies` (`id_allocine`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `movies`
--

DROP TABLE IF EXISTS `movies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `movies` (
  `id_allocine` mediumint NOT NULL,
  `title` varchar(255) NOT NULL,
  `release_year` smallint NOT NULL,
  `original_title` varchar(255) DEFAULT NULL,
  `duration_m` smallint DEFAULT NULL,
  `public_rating` decimal(2,1) DEFAULT NULL,
  `vote_count` smallint DEFAULT NULL,
  `press_rating` decimal(2,1) DEFAULT NULL,
  `audience` varchar(100) DEFAULT NULL,
  `synopsis` text,
  `poster_link` varchar(255) DEFAULT NULL,
  `youtube_views` mediumint DEFAULT NULL,
  `youtube_likes` mediumint DEFAULT NULL,
  `youtube_comments` mediumint DEFAULT NULL,
  PRIMARY KEY (`id_allocine`),
  UNIQUE KEY `movies_unique` (`title`,`release_year`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `persons`
--

DROP TABLE IF EXISTS `persons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `persons` (
  `id_person` mediumint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `oscars` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id_person`),
  UNIQUE KEY `persons_unique` (`name`),
  KEY `persons_oscars_IDX` (`oscars`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=40317 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pivot_film_api`
--

DROP TABLE IF EXISTS `pivot_film_api`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pivot_film_api` (
  `casting` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `director` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `duration` double NOT NULL,
  `entries` double NOT NULL,
  `film_id` double NOT NULL,
  `genres` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `img_src` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `press_ratings` double NOT NULL,
  `release_date` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `societies` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `synopsis` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `title` varchar(255) NOT NULL,
  `viewers_ratings` double NOT NULL,
  PRIMARY KEY (`film_id`),
  UNIQUE KEY `pivot_film_api_unique` (`title`,`release_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pivot_imdb_most_popular_celebs`
--

DROP TABLE IF EXISTS `pivot_imdb_most_popular_celebs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pivot_imdb_most_popular_celebs` (
  `rank_celebrity` smallint NOT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`rank_celebrity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pivot_imdb_movies`
--

DROP TABLE IF EXISTS `pivot_imdb_movies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pivot_imdb_movies` (
  `movie_boxoffice` bigint DEFAULT NULL,
  `movie_budget` varchar(20) DEFAULT NULL,
  `movie_cast` text,
  `movie_categories` text,
  `movie_countries` text,
  `movie_director` text,
  `movie_id` varchar(20) DEFAULT NULL,
  `movie_imdb_metascore` tinyint DEFAULT NULL,
  `movie_imdb_nb_of_ratings` bigint DEFAULT NULL,
  `movie_imdb_popularity` mediumint DEFAULT NULL,
  `movie_imdb_rating` decimal(3,1) DEFAULT NULL,
  `movie_length` smallint DEFAULT NULL,
  `movie_original_title` varchar(255) DEFAULT NULL,
  `movie_production_companies` text,
  `movie_synopsis` text,
  `movie_title` varchar(255) DEFAULT NULL,
  `movie_url` varchar(255) DEFAULT NULL,
  `movie_us_boxoffice` bigint DEFAULT NULL,
  `release_year` smallint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pivot_oscars`
--

DROP TABLE IF EXISTS `pivot_oscars`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pivot_oscars` (
  `category` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `winner` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `year` smallint NOT NULL,
  PRIMARY KEY (`category`,`year`,`winner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping routines for database 'niab_analytic'
--
/*!50003 DROP PROCEDURE IF EXISTS `hydrate_by_film_api` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `hydrate_by_film_api`()
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
	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `hydrate_by_film_api_actor` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `hydrate_by_film_api_actor`(IN a_id_allocine INT ,IN a_actors TEXT)
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `hydrate_by_film_api_director` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `hydrate_by_film_api_director`(IN a_id_allocine INT ,IN a_directors TEXT)
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `hydrate_by_film_api_genre` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `hydrate_by_film_api_genre`(IN a_id_allocine INT ,IN a_genres TEXT)
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `hydrate_by_imdb_movies` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `hydrate_by_imdb_movies`()
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
	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `db_to_ml`
--

/*!50001 DROP VIEW IF EXISTS `db_to_ml`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `db_to_ml` AS select `m`.`title` AS `title`,`m`.`release_year` AS `release_year`,`m`.`original_title` AS `original_title`,(select group_concat(`g`.`genre` separator ', ') from (`movie_genre` `mg` join `genres` `g` on((`g`.`id_genre` = `mg`.`id_genre`))) where (`mg`.`id_allocine` = `m`.`id_allocine`)) AS `genres`,`m`.`duration_m` AS `duration_m`,`m`.`public_rating` AS `public_rating`,`m`.`vote_count` AS `vote_count`,`m`.`press_rating` AS `press_rating`,`m`.`audience` AS `audience`,`m`.`synopsis` AS `synopsis`,`m`.`poster_link` AS `poster_link`,(select group_concat(`p`.`name` separator ', ') from (`movie_director` `md` join `persons` `p` on((`p`.`id_person` = `md`.`id_person`))) where (`md`.`id_allocine` = `m`.`id_allocine`)) AS `directors`,(select `p`.`name` from (`movie_actor` `ma` join `persons` `p` on((`p`.`id_person` = `ma`.`id_person`))) where (`ma`.`id_allocine` = `m`.`id_allocine`) order by `p`.`oscars` desc,`p`.`name` limit 1) AS `start1`,(select `p`.`name` from (`movie_actor` `ma` join `persons` `p` on((`p`.`id_person` = `ma`.`id_person`))) where (`ma`.`id_allocine` = `m`.`id_allocine`) order by `p`.`oscars` desc,`p`.`name` limit 1,1) AS `start2`,(select `p`.`name` from (`movie_actor` `ma` join `persons` `p` on((`p`.`id_person` = `ma`.`id_person`))) where (`ma`.`id_allocine` = `m`.`id_allocine`) order by `p`.`oscars` desc,`p`.`name` limit 2,1) AS `start3` from `movies` `m` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-04-05 15:32:08
