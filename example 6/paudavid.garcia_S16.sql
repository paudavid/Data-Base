#&&1

SELECT p.name, count(distinct am.id_actor) as Total_Actor
from Movie as m, person as p, director as d, actor_movie as am, actor as a, movie as m2
where d.id_director=m.id_director and m.id_director=p.id_person and a.id_actor=am.id_actor and am.id_movie=m.id_movie and m2.id_director=d.id_director
and am.id_actor=any(select distinct am2.id_actor from actor as a2, actor_movie as am2 where a2.id_actor=am2.id_actor and am2.id_movie=m.id_movie group by am2.id_actor)
group by p.name
order by SUM(distinct m2.budget) desc limit 5;

#&&2

SELECT m.title, m.duration
FROM Movie as m join Genre_movie as gm on m.id_movie = gm.id_movie
Group by m.id_movie
having COUNT(gm.id_genre) = 1
order by m.duration desc limit 1;

#&&3

SELECT p.name, COUNT(m.id_movie), AVG(m.imdb_score)
FROM Movie as m join Person as p on p.id_person = m.id_director
Group By m.id_director
having AVG(imdb_score) > 7 and COUNT(m.id_movie) > 15
order by COUNT(m.id_movie) desc, AVG(m.imdb_score) desc;

#&&4

SELECT distinct m.year, g.description, COUNT(distinct m.id_movie) as numMovie, g2.description, COUNT(distinct m2.id_movie) as numMovie2
FROM Movie as m, Genre_movie as gm, Genre as g, Genre as g2, Movie as m2, Genre_movie as gm2
WHERE gm.id_genre=g.id_genre and gm2.id_genre=g2.id_genre and m.year=m2.year and m.id_movie=gm.id_movie and m2.id_movie=gm2.id_movie
and g2.description= 'Comedy' and g.description= 'Drama'
Group by m.year
Having (m.year between 1986 and 2015) and numMovie < numMovie2;

#&&5

Select p.name, count(distinct m.id_movie) as movie_actor, count(distinct m2.id_movie) as movie_director
from movie as m, actor_movie as am, person as p, director as d, movie as m2, person as p2
where am.id_actor=p.id_person and d.id_director=p2.id_person and p2.id_person=p.id_person and m.id_movie=am.id_movie and m2.id_director=d.id_director
group by p.name
having movie_actor>movie_director
order by movie_director desc, movie_actor desc limit 5;





