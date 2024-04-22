CREATE TABLE IF NOT EXISTS `genres` (
  `genre` varchar(150) NOT NULL,
  PRIMARY KEY (`genre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `persons` (
  `id_person` mediumint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id_person`),
  UNIQUE KEY `persons_unique` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `movie_w0_actor` (
  `id_allocine` int NOT NULL,
  `id_person` mediumint NOT NULL,
  PRIMARY KEY (`id_allocine`,`id_person`),
  KEY `movies_wo_actors_persons_FK` (`id_person`),
  CONSTRAINT `movies_wo_actors_movies_w0_FK` FOREIGN KEY (`id_allocine`) REFERENCES `movies_w0` (`id_allocine`) ON DELETE CASCADE,
  CONSTRAINT `movies_wo_actors_persons_FK` FOREIGN KEY (`id_person`) REFERENCES `persons` (`id_person`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `movie_w0_director` (
  `id_allocine` int NOT NULL,
  `id_person` mediumint NOT NULL,
  PRIMARY KEY (`id_allocine`,`id_person`),
  KEY `movies_w0_directors_persons_FK` (`id_person`),
  CONSTRAINT `movies_w0_directors_movies_w0_FK` FOREIGN KEY (`id_allocine`) REFERENCES `movies_w0` (`id_allocine`) ON DELETE CASCADE,
  CONSTRAINT `movies_w0_directors_persons_FK` FOREIGN KEY (`id_person`) REFERENCES `persons` (`id_person`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `movie_w0_genre` (
  `id_allocine` int NOT NULL,
  `genre` varchar(150) NOT NULL,
  PRIMARY KEY (`id_allocine`,`genre`),
  KEY `movie_w0_genre_genres_FK` (`genre`),
  CONSTRAINT `movie_w0_genre_genres_FK` FOREIGN KEY (`genre`) REFERENCES `genres` (`genre`) ON DELETE CASCADE,
  CONSTRAINT `movie_w0_genre_movies_w0_FK` FOREIGN KEY (`id_allocine`) REFERENCES `movies_w0` (`id_allocine`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `movie_w1_actor` (
  `id_allocine` int NOT NULL,
  `id_person` mediumint NOT NULL,
  PRIMARY KEY (`id_allocine`,`id_person`),
  KEY `movie_w1_actor_persons_FK` (`id_person`),
  CONSTRAINT `movie_w1_actor_movies_w1_FK` FOREIGN KEY (`id_allocine`) REFERENCES `movies_w1` (`id_allocine`) ON DELETE CASCADE,
  CONSTRAINT `movie_w1_actor_persons_FK` FOREIGN KEY (`id_person`) REFERENCES `persons` (`id_person`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `movie_w1_director` (
  `id_allocine` int NOT NULL,
  `id_person` mediumint NOT NULL,
  PRIMARY KEY (`id_person`,`id_allocine`),
  KEY `movie_w1_director_movies_w1_FK` (`id_allocine`),
  CONSTRAINT `movie_w1_director_movies_w1_FK` FOREIGN KEY (`id_allocine`) REFERENCES `movies_w1` (`id_allocine`) ON DELETE CASCADE,
  CONSTRAINT `movie_w1_director_persons_FK` FOREIGN KEY (`id_person`) REFERENCES `persons` (`id_person`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `movie_w1_genre` (
  `id_allocine` int NOT NULL,
  `genre` varchar(150) NOT NULL,
  PRIMARY KEY (`id_allocine`,`genre`),
  KEY `movie_w1_genre_genres_FK` (`genre`),
  CONSTRAINT `movie_w1_genre_genres_FK` FOREIGN KEY (`genre`) REFERENCES `genres` (`genre`) ON DELETE CASCADE,
  CONSTRAINT `movie_w1_genre_movies_w1_FK` FOREIGN KEY (`id_allocine`) REFERENCES `movies_w1` (`id_allocine`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

DROP TABLE IF EXISTS `pred_vacances_francaise`;
CREATE TABLE IF NOT EXISTS `pred_vacances_francaise` (
  `zone` varchar(6) NOT NULL,
  `vacances` varchar(100) NOT NULL,
  `start_date` date NOT NULL,
  `stop_date` date NOT NULL,
  KEY `pivot_vacances_francaise_start_date_IDX` (`start_date`) USING BTREE,
  KEY `pivot_vacances_francaise_stop_date_IDX` (`stop_date`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `pred_oscars`;
CREATE TABLE IF NOT EXISTS `pred_oscars` (
  `category` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `winner` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `year` smallint NOT NULL,
  PRIMARY KEY (`category`,`year`,`winner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `pred_people`;
CREATE TABLE IF NOT EXISTS `pred_people` (
  `entries_mean` bigint DEFAULT NULL,
  `entries_sum` bigint DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `person_id` mediumint DEFAULT NULL,
  `role` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `pred_actors_actresses_directors`;
CREATE TABLE IF NOT EXISTS `pred_actors_actresses_directors` (
  `role` varchar(100) DEFAULT NULL,
  `start_year` smallint DEFAULT NULL,
  `stop_year` smallint DEFAULT NULL,
  `rank_id` tinyint DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `pred_imdb_most_popular_celebs`;
CREATE TABLE IF NOT EXISTS `pred_imdb_most_popular_celebs` (
  `rank_celebrity` smallint NOT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`rank_celebrity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `movie_w0_hall` (
  `id_allocine` int NOT NULL,
  `hall_name` varchar(255) NOT NULL,
  `ticket_price` decimal(5,2) DEFAULT NULL,
  PRIMARY KEY (`id_allocine`,`hall_name`),
  KEY `movie_w0_hall_halls_FK` (`hall_name`),
  CONSTRAINT `movie_w0_hall_halls_FK` FOREIGN KEY (`hall_name`) REFERENCES `halls` (`hall_name`) ON DELETE CASCADE,
  CONSTRAINT `movie_w0_hall_movies_w0_FK` FOREIGN KEY (`id_allocine`) REFERENCES `movies_w0` (`id_allocine`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `movie_w1_hall` (
  `id_allocine` int NOT NULL,
  `hall_name` varchar(255) NOT NULL,
  PRIMARY KEY (`id_allocine`,`hall_name`),
  `ticket_price` decimal(5,2) DEFAULT NULL,
  KEY `movie_w1_hall_halls_FK` (`hall_name`),
  CONSTRAINT `movie_w1_hall_halls_FK` FOREIGN KEY (`hall_name`) REFERENCES `halls` (`hall_name`) ON DELETE CASCADE,
  CONSTRAINT `movie_w1_hall_movies_w1_FK` FOREIGN KEY (`id_allocine`) REFERENCES `movies_w1` (`id_allocine`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `movie_history_actor` (
  `id_allocine` int NOT NULL,
  `id_person` mediumint NOT NULL,
  PRIMARY KEY (`id_allocine`,`id_person`),
  KEY `movie_history_actor_persons_FK` (`id_person`),
  CONSTRAINT `movie_history_actor_movies_history_FK` FOREIGN KEY (`id_allocine`) REFERENCES `movies_history` (`id_allocine`) ON DELETE CASCADE,
  CONSTRAINT `movie_history_actor_persons_FK` FOREIGN KEY (`id_person`) REFERENCES `persons` (`id_person`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `movie_history_director` (
  `id_allocine` int NOT NULL,
  `id_person` mediumint NOT NULL,
  PRIMARY KEY (`id_allocine`,`id_person`),
  KEY `movie_history_director_persons_FK` (`id_person`),
  CONSTRAINT `movie_history_director_movies_history_FK` FOREIGN KEY (`id_allocine`) REFERENCES `movies_history` (`id_allocine`) ON DELETE CASCADE,
  CONSTRAINT `movie_history_director_persons_FK` FOREIGN KEY (`id_person`) REFERENCES `persons` (`id_person`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `movie_history_genre` (
  `id_allocine` int NOT NULL,
  `genre` varchar(150) NOT NULL,
  PRIMARY KEY (`id_allocine`,`genre`),
  KEY `movie_history_genre_genres_FK` (`genre`),
  CONSTRAINT `movie_history_genre_genres_FK` FOREIGN KEY (`genre`) REFERENCES `genres` (`genre`) ON DELETE CASCADE,
  CONSTRAINT `movie_history_genre_movies_history_FK` FOREIGN KEY (`id_allocine`) REFERENCES `movies_history` (`id_allocine`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE IF NOT EXISTS `movie_history_hall` (
  `id_allocine` int NOT NULL,
  `hall_name` varchar(255) NOT NULL,
  `ticket_price` decimal(5,2) DEFAULT NULL,
  PRIMARY KEY (`id_allocine`,`hall_name`),
  KEY `movie_history_hall_halls_FK` (`hall_name`),
  CONSTRAINT `movie_history_hall_halls_FK` FOREIGN KEY (`hall_name`) REFERENCES `halls` (`hall_name`) ON DELETE CASCADE,
  CONSTRAINT `movie_history_hall_movies_history_FK` FOREIGN KEY (`id_allocine`) REFERENCES `movies_history` (`id_allocine`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
