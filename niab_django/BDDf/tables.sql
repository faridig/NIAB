CREATE TABLE `genres` (
  `genre` varchar(150) NOT NULL,
  PRIMARY KEY (`genre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE `persons` (
  `id_person` mediumint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id_person`),
  UNIQUE KEY `persons_unique` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb3;

CREATE TABLE `movie_w0_actor` (
  `id_allocine` int NOT NULL,
  `id_person` mediumint NOT NULL,
  PRIMARY KEY (`id_allocine`,`id_person`),
  KEY `movies_wo_actors_persons_FK` (`id_person`),
  CONSTRAINT `movies_wo_actors_movies_w0_FK` FOREIGN KEY (`id_allocine`) REFERENCES `movies_w0` (`id_allocine`) ON DELETE CASCADE,
  CONSTRAINT `movies_wo_actors_persons_FK` FOREIGN KEY (`id_person`) REFERENCES `persons` (`id_person`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE `movie_w0_director` (
  `id_allocine` int NOT NULL,
  `id_person` mediumint NOT NULL,
  PRIMARY KEY (`id_allocine`,`id_person`),
  KEY `movies_w0_directors_persons_FK` (`id_person`),
  CONSTRAINT `movies_w0_directors_movies_w0_FK` FOREIGN KEY (`id_allocine`) REFERENCES `movies_w0` (`id_allocine`) ON DELETE CASCADE,
  CONSTRAINT `movies_w0_directors_persons_FK` FOREIGN KEY (`id_person`) REFERENCES `persons` (`id_person`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE `movie_w0_genre` (
  `id_allocine` int NOT NULL,
  `genre` varchar(150) NOT NULL,
  PRIMARY KEY (`id_allocine`,`genre`),
  KEY `movie_w0_genre_genres_FK` (`genre`),
  CONSTRAINT `movie_w0_genre_genres_FK` FOREIGN KEY (`genre`) REFERENCES `genres` (`genre`) ON DELETE CASCADE,
  CONSTRAINT `movie_w0_genre_movies_w0_FK` FOREIGN KEY (`id_allocine`) REFERENCES `movies_w0` (`id_allocine`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE `movie_w1_actor` (
  `id_allocine` int NOT NULL,
  `id_person` mediumint NOT NULL,
  PRIMARY KEY (`id_allocine`,`id_person`),
  KEY `movie_w1_actor_persons_FK` (`id_person`),
  CONSTRAINT `movie_w1_actor_movies_w1_FK` FOREIGN KEY (`id_allocine`) REFERENCES `movies_w1` (`id_allocine`) ON DELETE CASCADE,
  CONSTRAINT `movie_w1_actor_persons_FK` FOREIGN KEY (`id_person`) REFERENCES `persons` (`id_person`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE `movie_w1_director` (
  `id_allocine` int NOT NULL,
  `id_person` mediumint NOT NULL,
  PRIMARY KEY (`id_person`,`id_allocine`),
  KEY `movie_w1_director_movies_w1_FK` (`id_allocine`),
  CONSTRAINT `movie_w1_director_movies_w1_FK` FOREIGN KEY (`id_allocine`) REFERENCES `movies_w1` (`id_allocine`) ON DELETE CASCADE,
  CONSTRAINT `movie_w1_director_persons_FK` FOREIGN KEY (`id_person`) REFERENCES `persons` (`id_person`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE `movie_w1_genre` (
  `id_allocine` int NOT NULL,
  `genre` varchar(150) NOT NULL,
  PRIMARY KEY (`id_allocine`,`genre`),
  KEY `movie_w1_genre_genres_FK` (`genre`),
  CONSTRAINT `movie_w1_genre_genres_FK` FOREIGN KEY (`genre`) REFERENCES `genres` (`genre`) ON DELETE CASCADE,
  CONSTRAINT `movie_w1_genre_movies_w1_FK` FOREIGN KEY (`id_allocine`) REFERENCES `movies_w1` (`id_allocine`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
