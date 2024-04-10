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
 1 AS `id_allocine`,
 1 AS `title`,
 1 AS `release_year`,
 1 AS `original_title`,
 1 AS `genres`,
 1 AS `duration_m`,
 1 AS `synopsis`,
 1 AS `poster_link`,
 1 AS `release_date`,
 1 AS `societies`,
 1 AS `budget`,
 1 AS `nationality`,
 1 AS `directors`,
 1 AS `all_director_oscars`,
 1 AS `all_actor_oscars`,
 1 AS `actor_celebs`,
 1 AS `actor_celebs_by_year`,
 1 AS `vacances_automne`,
 1 AS `vacances_noel`,
 1 AS `vacances_hiver`,
 1 AS `vacances_printemps`,
 1 AS `vacances_ete`,
 1 AS `nb_zone_en_vacances`,
 1 AS `entries_mean_actor`,
 1 AS `entries_sum_actor`,
 1 AS `entries_mean_director`,
 1 AS `entries_sum_director`,
 1 AS `entries_mean_composer`,
 1 AS `entries_sum_composer`,
 1 AS `jpbox_copies`,
 1 AS `imdb_entries`,
 1 AS `imdb_us_entries`,
 1 AS `imdb_id`*/;
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
) ENGINE=InnoDB AUTO_INCREMENT=200 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `jpbox`
--

DROP TABLE IF EXISTS `jpbox`;
/*!50001 DROP VIEW IF EXISTS `jpbox`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `jpbox` AS SELECT 
 1 AS `id_allocine`,
 1 AS `copies`*/;
SET character_set_client = @saved_cs_client;

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
  `release_date` date DEFAULT NULL,
  `societies` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `budget` varchar(255) DEFAULT NULL,
  `nationality` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `entries` bigint DEFAULT NULL,
  `imdb_id` varchar(15) DEFAULT NULL,
  `imdb_entries` bigint DEFAULT NULL,
  `imdb_us_entries` bigint DEFAULT NULL,
  PRIMARY KEY (`id_allocine`),
  UNIQUE KEY `movies_unique` (`title`,`release_year`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `movies_actor_oscars`
--

DROP TABLE IF EXISTS `movies_actor_oscars`;
/*!50001 DROP VIEW IF EXISTS `movies_actor_oscars`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `movies_actor_oscars` AS SELECT 
 1 AS `id_allocine`,
 1 AS `all_actor_oscars`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `movies_director_oscars`
--

DROP TABLE IF EXISTS `movies_director_oscars`;
/*!50001 DROP VIEW IF EXISTS `movies_director_oscars`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `movies_director_oscars` AS SELECT 
 1 AS `id_allocine`,
 1 AS `all_director_oscars`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `movies_en_vacances`
--

DROP TABLE IF EXISTS `movies_en_vacances`;
/*!50001 DROP VIEW IF EXISTS `movies_en_vacances`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `movies_en_vacances` AS SELECT 
 1 AS `id_allocine`,
 1 AS `vacances_automne`,
 1 AS `vacances_noel`,
 1 AS `vacances_hiver`,
 1 AS `vacances_printemps`,
 1 AS `vacances_ete`,
 1 AS `nb_zone_en_vacances`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `movies_people`
--

DROP TABLE IF EXISTS `movies_people`;
/*!50001 DROP VIEW IF EXISTS `movies_people`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `movies_people` AS SELECT 
 1 AS `id_allocine`,
 1 AS `entries_mean_actor`,
 1 AS `entries_sum_actor`,
 1 AS `entries_mean_director`,
 1 AS `entries_sum_director`,
 1 AS `entries_mean_composer`,
 1 AS `entries_sum_composer`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `movies_rank_celebrity`
--

DROP TABLE IF EXISTS `movies_rank_celebrity`;
/*!50001 DROP VIEW IF EXISTS `movies_rank_celebrity`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `movies_rank_celebrity` AS SELECT 
 1 AS `id_allocine`,
 1 AS `actor_celebs`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `movies_rank_celebrity_by_year`
--

DROP TABLE IF EXISTS `movies_rank_celebrity_by_year`;
/*!50001 DROP VIEW IF EXISTS `movies_rank_celebrity_by_year`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `movies_rank_celebrity_by_year` AS SELECT 
 1 AS `id_allocine`,
 1 AS `actor_celebs`*/;
SET character_set_client = @saved_cs_client;

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
) ENGINE=InnoDB AUTO_INCREMENT=134150 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pivot_actors_actresses_directors`
--

DROP TABLE IF EXISTS `pivot_actors_actresses_directors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pivot_actors_actresses_directors` (
  `role` varchar(100) DEFAULT NULL,
  `start_year` smallint DEFAULT NULL,
  `stop_year` smallint DEFAULT NULL,
  `rank_id` tinyint DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
  `release_date` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `societies` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `synopsis` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `title` varchar(255) NOT NULL,
  `budget` varchar(255) DEFAULT NULL,
  `nationality` varchar(255) DEFAULT NULL,
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
-- Table structure for table `pivot_jpbox`
--

DROP TABLE IF EXISTS `pivot_jpbox`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pivot_jpbox` (
  `jp_copies` smallint DEFAULT NULL,
  `jp_director` varchar(255) DEFAULT NULL,
  `jp_distributors` varchar(255) DEFAULT NULL,
  `jp_duration` smallint DEFAULT NULL,
  `jp_genres` varchar(255) DEFAULT NULL,
  `jp_nationality` varchar(255) DEFAULT NULL,
  `jp_release` date DEFAULT NULL,
  `jp_title` varchar(255) DEFAULT NULL
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
-- Table structure for table `pivot_people`
--

DROP TABLE IF EXISTS `pivot_people`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pivot_people` (
  `entries_mean` bigint DEFAULT NULL,
  `entries_sum` bigint DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `person_id` mediumint DEFAULT NULL,
  `role` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pivot_vacances_francaise`
--

DROP TABLE IF EXISTS `pivot_vacances_francaise`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pivot_vacances_francaise` (
  `zone` varchar(6) NOT NULL,
  `vacances` varchar(100) NOT NULL,
  `start_date` date NOT NULL,
  `stop_date` date NOT NULL,
  KEY `pivot_vacances_francaise_start_date_IDX` (`start_date`) USING BTREE,
  KEY `pivot_vacances_francaise_stop_date_IDX` (`stop_date`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

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
/*!50001 VIEW `db_to_ml` AS select `m`.`id_allocine` AS `id_allocine`,`m`.`title` AS `title`,`m`.`release_year` AS `release_year`,`m`.`original_title` AS `original_title`,(select group_concat(`g`.`genre` separator ',') from (`movie_genre` `mg` join `genres` `g` on((`g`.`id_genre` = `mg`.`id_genre`))) where (`mg`.`id_allocine` = `m`.`id_allocine`)) AS `genres`,`m`.`duration_m` AS `duration_m`,`m`.`synopsis` AS `synopsis`,`m`.`poster_link` AS `poster_link`,`m`.`release_date` AS `release_date`,`m`.`societies` AS `societies`,`m`.`budget` AS `budget`,`m`.`nationality` AS `nationality`,(select group_concat(`p`.`name` separator ',') from (`movie_director` `md` join `persons` `p` on((`p`.`id_person` = `md`.`id_person`))) where (`md`.`id_allocine` = `m`.`id_allocine`)) AS `directors`,`mdo`.`all_director_oscars` AS `all_director_oscars`,`mao`.`all_actor_oscars` AS `all_actor_oscars`,`mrc`.`actor_celebs` AS `actor_celebs`,`mrcby`.`actor_celebs` AS `actor_celebs_by_year`,`mev`.`vacances_automne` AS `vacances_automne`,`mev`.`vacances_noel` AS `vacances_noel`,`mev`.`vacances_hiver` AS `vacances_hiver`,`mev`.`vacances_printemps` AS `vacances_printemps`,`mev`.`vacances_ete` AS `vacances_ete`,`mev`.`nb_zone_en_vacances` AS `nb_zone_en_vacances`,`mp`.`entries_mean_actor` AS `entries_mean_actor`,`mp`.`entries_sum_actor` AS `entries_sum_actor`,`mp`.`entries_mean_director` AS `entries_mean_director`,`mp`.`entries_sum_director` AS `entries_sum_director`,`mp`.`entries_mean_composer` AS `entries_mean_composer`,`mp`.`entries_sum_composer` AS `entries_sum_composer`,`j`.`copies` AS `jpbox_copies`,`m`.`imdb_entries` AS `imdb_entries`,`m`.`imdb_us_entries` AS `imdb_us_entries`,`m`.`imdb_id` AS `imdb_id` from (((((((`movies` `m` left join `movies_director_oscars` `mdo` on((`mdo`.`id_allocine` = `m`.`id_allocine`))) left join `movies_actor_oscars` `mao` on((`mao`.`id_allocine` = `m`.`id_allocine`))) left join `movies_rank_celebrity` `mrc` on((`mrc`.`id_allocine` = `m`.`id_allocine`))) left join `movies_rank_celebrity_by_year` `mrcby` on((`mrcby`.`id_allocine` = `m`.`id_allocine`))) left join `movies_people` `mp` on((`mp`.`id_allocine` = `m`.`id_allocine`))) left join `jpbox` `j` on((`j`.`id_allocine` = `m`.`id_allocine`))) left join `movies_en_vacances` `mev` on((`mev`.`id_allocine` = `m`.`id_allocine`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `jpbox`
--

/*!50001 DROP VIEW IF EXISTS `jpbox`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `jpbox` AS select `m`.`id_allocine` AS `id_allocine`,`pj`.`jp_copies` AS `copies` from (`movies` `m` join `pivot_jpbox` `pj` on(((lower(`pj`.`jp_title`) = lower(`m`.`title`)) and (`pj`.`jp_release` = `m`.`release_date`)))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `movies_actor_oscars`
--

/*!50001 DROP VIEW IF EXISTS `movies_actor_oscars`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `movies_actor_oscars` AS select `m`.`id_allocine` AS `id_allocine`,count(1) AS `all_actor_oscars` from (((`movies` `m` join `movie_actor` `ma` on((`ma`.`id_allocine` = `m`.`id_allocine`))) join `persons` `p` on((`p`.`id_person` = `ma`.`id_person`))) join `pivot_oscars` `po` on((`po`.`winner` = `p`.`name`))) where (`po`.`year` < `m`.`release_year`) group by `m`.`id_allocine` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `movies_director_oscars`
--

/*!50001 DROP VIEW IF EXISTS `movies_director_oscars`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `movies_director_oscars` AS select `m`.`id_allocine` AS `id_allocine`,count(1) AS `all_director_oscars` from (((`movies` `m` join `movie_director` `md` on((`md`.`id_allocine` = `m`.`id_allocine`))) join `persons` `p` on((`p`.`id_person` = `md`.`id_person`))) join `pivot_oscars` `po` on((`po`.`winner` = `m`.`title`))) where (`po`.`category` in ('Best Motion Picture of the Year','Best Picture','Best Achievement in Directing','Best Director')) group by `m`.`id_allocine` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `movies_en_vacances`
--

/*!50001 DROP VIEW IF EXISTS `movies_en_vacances`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `movies_en_vacances` AS select `m`.`id_allocine` AS `id_allocine`,sum((case when (`pvf`.`vacances` = 'vacances d\'Automne') then 1 else 0 end)) AS `vacances_automne`,sum((case when (`pvf`.`vacances` = 'vacances de Noël') then 1 else 0 end)) AS `vacances_noel`,sum((case when (`pvf`.`vacances` = 'vacances d\'Hiver') then 1 else 0 end)) AS `vacances_hiver`,sum((case when (`pvf`.`vacances` = 'vacances de Printemps') then 1 else 0 end)) AS `vacances_printemps`,sum((case when (`pvf`.`vacances` = 'vacances d\'Été') then 1 else 0 end)) AS `vacances_ete`,count(`pvf`.`zone`) AS `nb_zone_en_vacances` from (`movies` `m` left join `pivot_vacances_francaise` `pvf` on(((`m`.`release_date` >= `pvf`.`start_date`) and (`m`.`release_date` <= `pvf`.`stop_date`)))) group by `m`.`id_allocine` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `movies_people`
--

/*!50001 DROP VIEW IF EXISTS `movies_people`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `movies_people` AS select `m`.`id_allocine` AS `id_allocine`,round(avg((case when (`pp`.`role` in ('Acteur','Actrice')) then `pp`.`entries_mean` else 0 end)),0) AS `entries_mean_actor`,sum((case when (`pp`.`role` in ('Acteur','Actrice')) then `pp`.`entries_sum` else 0 end)) AS `entries_sum_actor`,round(avg((case when (`pp`.`role` in ('Réalisateur','Réalisatrice','Réalisaeur','Réalisateurs')) then `pp`.`entries_mean` else 0 end)),0) AS `entries_mean_director`,sum((case when (`pp`.`role` in ('Réalisateur','Réalisatrice','Réalisaeur','Réalisateurs')) then `pp`.`entries_sum` else 0 end)) AS `entries_sum_director`,round(avg((case when (`pp`.`role` = 'Compositeur') then `pp`.`entries_mean` else 0 end)),0) AS `entries_mean_composer`,sum((case when (`pp`.`role` = 'Compositeur') then `pp`.`entries_sum` else 0 end)) AS `entries_sum_composer` from (((`movies` `m` join `movie_actor` `ma` on((`ma`.`id_allocine` = `m`.`id_allocine`))) join `persons` `p` on((`p`.`id_person` = `ma`.`id_person`))) join `pivot_people` `pp` on((`pp`.`name` = `p`.`name`))) group by `m`.`id_allocine` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `movies_rank_celebrity`
--

/*!50001 DROP VIEW IF EXISTS `movies_rank_celebrity`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `movies_rank_celebrity` AS select `m`.`id_allocine` AS `id_allocine`,sum((101 - `pimpc`.`rank_celebrity`)) AS `actor_celebs` from (((`movies` `m` join `movie_actor` `ma` on((`ma`.`id_allocine` = `m`.`id_allocine`))) join `persons` `p` on((`p`.`id_person` = `ma`.`id_person`))) join `pivot_imdb_most_popular_celebs` `pimpc` on((`pimpc`.`name` = `p`.`name`))) group by `m`.`id_allocine` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `movies_rank_celebrity_by_year`
--

/*!50001 DROP VIEW IF EXISTS `movies_rank_celebrity_by_year`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `movies_rank_celebrity_by_year` AS select `m`.`id_allocine` AS `id_allocine`,sum((31 - `paad`.`rank_id`)) AS `actor_celebs` from (((`movies` `m` join `movie_actor` `ma` on((`ma`.`id_allocine` = `m`.`id_allocine`))) join `persons` `p` on((`p`.`id_person` = `ma`.`id_person`))) join `pivot_actors_actresses_directors` `paad` on(((`paad`.`name` = `p`.`name`) and (`m`.`release_year` >= `paad`.`start_year`) and (`m`.`release_year` <= `paad`.`stop_year`)))) group by `m`.`id_allocine` */;
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

-- Dump completed on 2024-04-10 16:25:58
