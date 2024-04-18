select mw.title, mw.pred_entries, mw.true_entries, group_concat(p1.name separator ',') directors, group_concat(p2.name separator ',') actors, group_concat(mwg.genre separator ',') genres
from movies_w0 mw
join movie_w0_director mwd on mwd.id_allocine = mw.id_allocine 
join persons p1 on p1.id_person = mwd.id_person 
join movie_w0_actor mwa on mwa.id_allocine = mw.id_allocine 
join persons p2 on p2.id_person = mwa.id_person 
join movie_w0_genre mwg on mwg.id_allocine = mw.id_allocine 
group by mw.title, mw.pred_entries, mw.true_entries

select mw.title, mw.pred_entries, mw.true_entries, group_concat(p1.name separator ',') directors, group_concat(p2.name separator ',') actors, group_concat(mwg.genre separator ',') genres
from movies_w1 mw
join movie_w1_director mwd on mwd.id_allocine = mw.id_allocine 
join persons p1 on p1.id_person = mwd.id_person 
join movie_w1_actor mwa on mwa.id_allocine = mw.id_allocine 
join persons p2 on p2.id_person = mwa.id_person 
join movie_w1_genre mwg on mwg.id_allocine = mw.id_allocine 
group by mw.title, mw.pred_entries, mw.true_entries

select mw.title, mw.history_date, mw.pred_entries, mw.true_entries, group_concat(p1.name separator ',') directors, group_concat(p2.name separator ',') actors, group_concat(mwg.genre separator ',') genres
from movies_history mw
join movie_history_director mwd on mwd.id_allocine = mw.id_allocine 
join persons p1 on p1.id_person = mwd.id_person 
join movie_history_actor mwa on mwa.id_allocine = mw.id_allocine 
join persons p2 on p2.id_person = mwa.id_person 
join movie_history_genre mwg on mwg.id_allocine = mw.id_allocine 
group by mw.title, mw.history_date, mw.pred_entries, mw.true_entries



delete from movies_history

INSERT INTO niab_functional.movies_w0 (id_allocine,title,img_src,release_date,release_year,duration,pivot_genres,synopsis,nationality,distributor,budget,pivot_director,pivot_casting,public_rating,vote_count,press_rating,audience,societies,copies,pred_entries,true_entries) VALUES
	 (303942,'S.O.S. Fantômes : La Menace de glace','https://fr.web.img5.acsta.net/c_310_420/pictures/24/02/23/09/52/1147009.jpg','2024-04-10',2024,116,'Action|Aventure|Fantastique','La famille Spengler revient là où tout a commencé, l''emblématique caserne de pompiers de New York. Ils vont alors devoir faire équipe avec les membres originels de S.O.S. Fantômes, qui ont mis en place un laboratoire de recherche top secret pour faire passer la chasse aux fantômes à la vitesse supérieure. Lorsque la découverte d''un ancien artefact libère une armée de fantômes qui répand une menace de glace sur la ville, les deux équipes S.O.S. Fantômes doivent unir leurs forces pour protéger leur maison et sauver le monde d''une seconde ère glaciaire.','U.S.A.','Sony Pictures Releasing France',NULL,'Gil Kenan','Paul Rudd|Carrie Coon|Finn Wolfhard|Mckenna Grace|Kumail Nanjiani|Patton Oswalt|Celeste O’Connor|Logan Kim',NULL,NULL,NULL,NULL,'Sony Pictures|Sony Pictures Releasing France',670,673385,NULL),
	 (312488,'Nous, les Leroy','https://fr.web.img4.acsta.net/c_310_420/pictures/24/01/18/11/58/1341073.jpg','2024-04-10',2024,103,'Comédie','Sandrine Leroy annonce à son mari Christophe qu’elle veut divorcer. Leurs enfants ont bientôt l’âge de quitter la maison. Dans une opération de la dernière chance aussi audacieuse qu’invraisemblable, Christophe organise un week-end pour sauver son mariage : un voyage passant par les endroits clés de l’histoire de leur famille. Un voyage qui ne va pas être de tout repos…','France','Apollo Films / TF1 Studio',NULL,'Florent Bernard','Charlotte Gainsbourg|José Garcia|Lily Aubry|Hadrien Heaulmé|Louisa Baruk|Lyes Salem|Luis Rego|Sébastien Chassagne',NULL,NULL,NULL,NULL,'Newen|Nolita Cinema|TF1 Studio|Apollo Films|TF1 Films Production|Apollo Films / TF1 Studio',414,283572,NULL);
