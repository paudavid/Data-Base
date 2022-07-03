#&&1

CREATE USER 'admin'@'localhost';

GRANT SELECT(id_movie, id_director, imdb_score, gross, budget, title, year, country, movie_facebook_likes) ON Movie TO 'admin'@'localhost';
GRANT SELECT ON Person TO 'admin'@'localhost';
GRANT SELECT ON Producer_Movie TO 'admin'@'localhost';
GRANT SELECT ON Actor_Movie TO 'admin'@'localhost';
GRANT CREATE VIEW ON Movie TO 'admin'@'localhost';
GRANT CREATE VIEW ON Person TO 'admin'@'localhost';
GRANT CREATE VIEW ON Producer_Movie TO 'admin'@'localhost';
GRANT CREATE VIEW ON Actor_Movie TO 'admin'@'localhost';

#&&2
Create or replace view director_data as Select d.id_director, p.name, SUM(m.imdb_score), m.budget, m.gross
FROM Person as p JOIN Director as d on p.id_person=d.id_director join Movie as m ON m.id_director=d.id_director
group by d.id_director;

#&&3
Create or replace view worst_movies as Select m.title, m.year, m.country, m.imdb_score, count(distinct pm.id_producer)
From movie as m join producer_movie as pm on m.id_movie=pm.id_movie join Producer as p on pm.id_producer=p.id_producer
group by m.id_movie
having imdb_score <= all(select imdb_score from Movie)
order by m.imdb_score asc;


#&&4
Create or replace view actor_data as Select am.id_actor, p.name, Avg(m.imdb_score) as avg_imdb_score, avg(m.gross) as avg_gross, avg(m.budget) as avg_budget
From Person as p join actor_movie as am on p.id_person=am.id_actor join movie as m on am.id_movie=m.id_movie
where m.movie_facebook_likes<p.facebook_likes
group by am.id_actor
having m.movie_facebook_likes< p.facebook_likes;

#&&5
Create user 'guest'@'localhost';
GRANT SHOW VIEW ON director_data  TO 'guest'@'localhost';
GRANT SHOW VIEW ON worst_movies TO 'guest'@'localhost';
GRANT SHOW VIEW ON actor_data TO 'guest'@'localhost';

