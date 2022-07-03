#&&1
SELECT p.id_person, p.name, p.facebook_likes
FROM Actor as a, Person as p, Actor_Movie as am, Movie as m
WHERE p.id_person = a.id_actor AND a.id_actor = am.id_actor AND am.id_movie=m.id_movie AND m.country = 'Japan' AND m.year = 2019
GROUP BY p.id_person
ORDER BY p.facebook_likes desc, COUNT(am.id_movie) asc limit 1;

#&&2
SELECT a2.id_actor, p.name
FROM Person as p, Actor as a2
WHERE p.id_person = a2.id_actor 
AND a2.id_actor IN 
(
	SELECT a1.id_actor
	FROM Actor as a1, Actor_Movie as am, Movie as m
	WHERE a1.id_actor = am.id_actor 
	  AND am.id_movie = m.id_movie
	group by a1.id_actor
	HAVING COUNT(am.id_movie)>= 5
)
AND (SELECT max(z.score)
FROM (SELECT round(avg(m3.imdb_score), 2) as score FROM Movie as m3, Actor as a3, Actor_Movie as am3 
WHERE a3.id_actor = am3.id_actor AND am3.id_movie = m3.id_movie 
GROUP BY a3.id_actor
HAVING COUNT(m3.id_movie)>=5) as z) = (SELECT round(AVG(m4.imdb_score), 2) FROM Movie as m4, Actor_Movie as am4 WHERE a2.id_actor = am4.id_actor AND am4.id_movie = m4.id_movie );

#&&3
SELECT p.name, sum(m.movie_facebook_likes) as sum_likes
FROM Director as d, person as p, movie as m
where d.id_director=m.id_director and d.id_director=p.id_person and m.id_director=any(select m1.id_director from movie as m1 group by m1.id_director having count(m1.id_movie)=1)
and m.year=2019
group by p.name
order by sum_likes desc limit 3;

#&&4
SELECT a.id_actor, p.name, p.facebook_likes as likes
FROM Movie as m, Actor_Movie as am, Person as p, Actor as a, Producer as po, Producer_Movie as pm
WHERE a.id_actor=am.id_actor AND a.id_actor=p.id_person AND am.id_movie=m.id_movie 
AND a.id_actor=any (SELECT DISTINCT am1.id_actor from actor as a1, actor_movie as am1, movie as m1 where a1.id_actor=am1.id_actor and am1.id_movie=m1.id_movie and m1.id_movie=any(SELECT DISTINCT m2.id_movie from movie as m2 where m2.country='UK' or m2.country='USA' GROUP BY m2.id_movie)GROUP BY am1.id_actor)
GROUP BY a.id_actor
ORDER BY p.facebook_likes desc;

#&&5
SELECT DISTINCT p.name, COUNT(DISTINCT m.country) AS sum_participations 
FROM Person AS p, Actor_Movie AS am, Movie AS m, Director AS d 
WHERE p.id_person = d.id_director AND p.id_person = am.id_actor AND am.id_movie = m.id_movie AND p.id_person IN (SELECT am.id_actor FROM Actor_Movie AS am) AND p.id_person IN (SELECT d.id_director FROM Director AS d) 
AND EXISTS (SELECT p.name FROM Person WHERE p.name LIKE '%d%' OR p.name LIKE 'D%' OR p.name LIKE '%D%')
GROUP BY p.name
ORDER BY sum_participations DESC
LIMIT 6;