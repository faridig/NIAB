CREATE DEFINER=`niabadmin`@`%` PROCEDURE `niab_functional`.`before_scrap_w0`()
BEGIN

    -- On insert dans l'historique les valeurs de WEEK1
	INSERT INTO movies_history (id_allocine,title,img_src,release_date,release_year,duration,pivot_genres,synopsis,nationality,distributor,budget,pivot_director,pivot_casting,public_rating,vote_count,press_rating,audience,societies,copies,pred_entries,true_entries)
         SELECT * FROM movies_w1;
	INSERT INTO movie_history_actor
         SELECT * FROM movie_w1_actor;
	INSERT INTO movie_history_director
         SELECT * FROM movie_w1_director;
	INSERT INTO movie_history_genre
         SELECT * FROM movie_w1_genre;
	INSERT INTO movie_history_hall
         SELECT * FROM movie_w1_hall;

    -- On vide WEEK1
	DELETE FROM movies_w1;

    -- On insert dans WEEK1 les valeurs de WEEK0
	INSERT INTO movies_w1
         SELECT * FROM movies_w0;
	INSERT INTO movie_w1_actor
         SELECT * FROM movie_w0_actor;
	INSERT INTO movie_w1_director
         SELECT * FROM movie_w0_director;
	INSERT INTO movie_w1_genre
         SELECT * FROM movie_w0_genre;
	INSERT INTO movie_w1_hall
         SELECT * FROM movie_w0_hall;

    -- On vide WEEK0 pour recevoir les informations du scrapeur WEEK0
	DELETE FROM movies_w0;

END
