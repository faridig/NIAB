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
-- Table structure for table `ML`
--

DROP TABLE IF EXISTS `ML`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ML` (
  `title` varchar(255) NOT NULL,
  `release_year` smallint NOT NULL,
  `original_title` varchar(255) DEFAULT NULL,
  `genres` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `duration_m` smallint DEFAULT NULL,
  `public_rating` decimal(2,1) DEFAULT NULL,
  `vote_count` smallint DEFAULT NULL,
  `press_rating` decimal(2,1) DEFAULT NULL,
  `audience` varchar(100) DEFAULT NULL,
  `synopsis` text,
  `poster_link` varchar(255) DEFAULT NULL,
  `directors` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `actor_1` varchar(255) DEFAULT NULL,
  `actor_2` varchar(255) DEFAULT NULL,
  `actor_3` varchar(255) DEFAULT NULL,
  `youtube_views` mediumint DEFAULT NULL,
  `youtube_likes` mediumint DEFAULT NULL,
  `youtube_comments` mediumint DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

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
 1 AS `start3`,
 1 AS `youtube_views`,
 1 AS `youtube_likes`,
 1 AS `youtube_comments`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `genre`
--

DROP TABLE IF EXISTS `genre`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `genre` (
  `id_genre` smallint NOT NULL,
  `genre` varchar(100) NOT NULL,
  PRIMARY KEY (`id_genre`),
  UNIQUE KEY `genre_unique` (`genre`)
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
  `star` tinyint(1) NOT NULL DEFAULT '0',
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
  KEY `movie_genre_genre_FK` (`id_genre`),
  CONSTRAINT `movie_genre_genre_FK` FOREIGN KEY (`id_genre`) REFERENCES `genre` (`id_genre`) ON DELETE CASCADE,
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
) ENGINE=InnoDB AUTO_INCREMENT=1034 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pivot_film_api`
--

DROP TABLE IF EXISTS `pivot_film_api`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pivot_film_api` (
  `id` mediumint NOT NULL,
  `title` varchar(255) NOT NULL,
  `original_title` varchar(255) DEFAULT NULL,
  `genres` text,
  `duration_s` smallint DEFAULT NULL,
  `release_year` smallint NOT NULL,
  `rating` decimal(3,1) DEFAULT NULL,
  `vote_count` mediumint DEFAULT NULL,
  `metacritic_score` mediumint DEFAULT NULL,
  `audience` varchar(100) DEFAULT NULL,
  `synopsis` text,
  `poster_link` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `pivot_film_api_unique` (`title`,`release_year`)
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
/*!50001 VIEW `db_to_ml` AS select `m`.`title` AS `title`,`m`.`release_year` AS `release_year`,`m`.`original_title` AS `original_title`,(select group_concat(`g`.`genre` separator ', ') from (`movie_genre` `mg` join `genre` `g` on((`g`.`id_genre` = `mg`.`id_genre`))) where (`mg`.`id_allocine` = `m`.`id_allocine`)) AS `genres`,`m`.`duration_m` AS `duration_m`,`m`.`public_rating` AS `public_rating`,`m`.`vote_count` AS `vote_count`,`m`.`press_rating` AS `press_rating`,`m`.`audience` AS `audience`,`m`.`synopsis` AS `synopsis`,`m`.`poster_link` AS `poster_link`,(select group_concat(`p`.`name` separator ', ') from (`movie_director` `md` join `persons` `p` on((`p`.`id_person` = `md`.`id_person`))) where (`md`.`id_allocine` = `m`.`id_allocine`)) AS `directors`,(select `p`.`name` from (`movie_actor` `ma` join `persons` `p` on((`p`.`id_person` = `ma`.`id_person`))) where (`ma`.`id_allocine` = `m`.`id_allocine`) order by `p`.`oscars` desc,`ma`.`star` desc,`p`.`name` limit 1) AS `start1`,(select `p`.`name` from (`movie_actor` `ma` join `persons` `p` on((`p`.`id_person` = `ma`.`id_person`))) where (`ma`.`id_allocine` = `m`.`id_allocine`) order by `p`.`oscars` desc,`ma`.`star` desc,`p`.`name` limit 1,1) AS `start2`,(select `p`.`name` from (`movie_actor` `ma` join `persons` `p` on((`p`.`id_person` = `ma`.`id_person`))) where (`ma`.`id_allocine` = `m`.`id_allocine`) order by `p`.`oscars` desc,`ma`.`star` desc,`p`.`name` limit 2,1) AS `start3`,`m`.`youtube_views` AS `youtube_views`,`m`.`youtube_likes` AS `youtube_likes`,`m`.`youtube_comments` AS `youtube_comments` from `movies` `m` */;
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

-- Dump completed on 2024-04-02 16:20:06
