DROP DATABASE IF EXISTS Movies;
CREATE DATABASE Movies;
USE Movies;

DROP TABLE IF EXISTS producer_importacio;
DROP TABLE IF EXISTS movies_importacio;
DROP TABLE IF EXISTS languages_importacio;
DROP TABLE IF EXISTS genres_importacio;
DROP TABLE IF EXISTS genre_movie CASCADE;
DROP TABLE IF EXISTS actor_movie CASCADE;
DROP TABLE IF EXISTS genre CASCADE;
DROP TABLE IF EXISTS movie CASCADE;
DROP TABLE IF EXISTS actor CASCADE;
DROP TABLE IF EXISTS director CASCADE;
DROP TABLE IF EXISTS person CASCADE;
DROP TABLE IF EXISTS producer CASCADE;
DROP TABLE IF EXISTS producer_movie CASCADE;
DROP TABLE IF EXISTS language CASCADE;
DROP TABLE IF EXISTS language_movie CASCADE;


CREATE TABLE movies_importacio(
	color VARCHAR(511),
	director_name VARCHAR(511),
	num_cfr INT DEFAULT 0,
	duration INT,
	director_fl INT,
	actor_3_fl INT,
	actor_2_name VARCHAR(511),
	actor_1_fl INT,
	gross BIGINT,
	actor_1_name VARCHAR(511),
	movie_title VARCHAR(511),
	num_voted_users INT,
	cast_total_fl INT,
	actor_3_name VARCHAR(511),
	facenumber_in_poster INT,
	plot_keywords VARCHAR(511),
	movie_imdb_link VARCHAR(511),
	num_user_for_reviews INT,
	language_ VARCHAR(511),
	country VARCHAR(511),
	content_rating VARCHAR(511),
	budget BIGINT,
	title_year INT,
	actor_2_fl INT,
	imdb_score REAL,
	aspect_ratio REAL,
	movie_fl INT
);

CREATE TABLE genres_importacio(
	movie_title VARCHAR(511),
	genre VARCHAR(511)
);

CREATE TABLE producer_importacio(
	film varchar(255),
	producer varchar (255),
	country varchar(255)
);

CREATE TABLE language_importacio(
	film varchar(255),
    language varchar (255)
);



SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 'ON';



LOAD DATA LOCAL INFILE '/Users/Shared/movies_database_csv/movie_metadata.csv' INTO TABLE movies_importacio FIELDS TERMINATED BY ',' ENCLOSED BY '"' IGNORE 1 LINES;
LOAD DATA LOCAL INFILE '/Users/Shared/movies_database_csv/genres_metadata.csv' INTO TABLE genres_importacio FIELDS TERMINATED BY ',';
LOAD DATA LOCAL INFILE '/Users/Shared/movies_database_csv/producer_metadata.csv' INTO TABLE producer_importacio FIELDS TERMINATED BY ',';
LOAD DATA LOCAL INFILE '/Users/Shared/movies_database_csv/language_metadata.csv' INTO TABLE language_importacio FIELDS TERMINATED BY ',';

CREATE TABLE genre(
	id_genre int AUTO_increment,
	description VARCHAR(255),
	PRIMARY KEY (id_genre)
);


INSERT INTO genre(description)
SELECT DISTINCT genre FROM genres_importacio;



CREATE TABLE language (
	id_language int auto_increment,
    language varchar(255),
    primary key (id_language)
);

INSERT INTO language(language)
SELECT DISTINCT language FROM language_importacio;





CREATE TABLE producer(
	id_producer int AUTO_increment,
	name VARCHAR(255),
	country VARCHAR(255),
	PRIMARY KEY (id_producer)
);

INSERT INTO producer(name,country)
SELECT DISTINCT producer,country FROM producer_importacio;


CREATE TABLE person(
	id_person int AUTO_increment,
	name VARCHAR(255),
	facebook_likes INT,
	PRIMARY KEY (id_person)
);

CREATE TABLE director(
	id_director INT,
	PRIMARY KEY (id_director),
	FOREIGN KEY (id_director) REFERENCES person(id_person)
);

CREATE TABLE actor(
	id_actor INT,
	PRIMARY KEY (id_actor),
	FOREIGN KEY (id_actor) REFERENCES person(id_person)
);



INSERT INTO person (name,facebook_likes)
SELECT sq.a, MAX(sq.b) FROM (
SELECT DISTINCT director_name as a, director_fl as b FROM movies_importacio
WHERE director_name IS NOT NULL and  director_name NOT LIKE ''
UNION
SELECT DISTINCT actor_1_name as a, actor_1_fl as b FROM movies_importacio
WHERE actor_1_name IS NOT NULL and  actor_1_name NOT LIKE ''
UNION
SELECT DISTINCT actor_2_name as a, actor_2_fl as b FROM movies_importacio
WHERE actor_2_name IS NOT NULL and actor_2_name  NOT LIKE ''
UNION
SELECT DISTINCT actor_3_name as a, actor_3_fl as b FROM movies_importacio
WHERE actor_3_name IS NOT NULL and  actor_3_name NOT LIKE '') AS sq
GROUP BY sq.a;

INSERT INTO director
SELECT p.id_person FROM person as p
WHERE p.name IN(SELECT director_name FROM movies_importacio);

INSERT INTO actor
SELECT p.id_person FROM person as p
WHERE p.name IN(SELECT DISTINCT actor_1_name FROM movies_importacio
WHERE actor_1_name IS NOT NULL AND actor_1_name NOT LIKE ''
UNION
SELECT DISTINCT actor_2_name FROM movies_importacio
WHERE actor_2_name IS NOT NULL AND actor_2_name NOT LIKE ''
UNION
SELECT DISTINCT actor_3_name FROM movies_importacio
WHERE actor_3_name IS NOT NULL AND actor_3_name NOT LIKE '');


CREATE TABLE movie(
	id_movie INT AUTO_increment,
	title VARCHAR(511),
	id_director INT,
	year INT,
	duration INT,
	country VARCHAR(511),
	movie_facebook_likes INT,
	imdb_score REAL,
	gross BIGINT,
	budget BIGINT,
	PRIMARY KEY (id_movie),
	FOREIGN KEY (id_director) REFERENCES director(id_director)
);

INSERT INTO movie(title, id_director, year, duration, country,  movie_facebook_likes, imdb_score, gross, budget)
SELECT DISTINCT mi.movie_title, p.id_person, mi.title_year, mi.duration, mi.country, mi.movie_fl, mi.imdb_score, mi.gross, mi.budget
FROM movies_importacio as mi, person AS p
WHERE p.name = mi.director_name;

CREATE TABLE genre_movie(
	id_genre INT,
	id_movie INT,
	PRIMARY KEY (id_movie, id_genre),
	FOREIGN KEY (id_movie) REFERENCES movie(id_movie),
	FOREIGN KEY (id_genre) REFERENCES genre(id_genre)
);

INSERT INTO genre_movie
SELECT DISTINCT g.id_genre, m.id_movie FROM genre as g, movie as m, genres_importacio as gi
WHERE gi.genre = g.description AND gi.movie_title = m.title;





CREATE TABLE producer_movie(
	id_producer INT,
	id_movie INT,
	PRIMARY KEY (id_movie, id_producer),
	FOREIGN KEY (id_movie) REFERENCES movie(id_movie),
	FOREIGN KEY (id_producer) REFERENCES producer(id_producer)
);

INSERT INTO producer_movie
SELECT  DISTINCT p.id_producer, m.id_movie FROM producer as p, movie as m, producer_importacio as pi
WHERE pi.producer = p.name AND pi.film = m.title AND pi.country = p.country;




CREATE TABLE language_movie(
	id_language INT,
	id_movie INT,
	PRIMARY KEY (id_movie, id_language),
	FOREIGN KEY (id_movie) REFERENCES movie(id_movie),
	FOREIGN KEY (id_language) REFERENCES language(id_language)
);

INSERT INTO language_movie
SELECT  DISTINCT  l.id_language, m.id_movie FROM language as l, movie as m, language_importacio as li
WHERE li.film = m.title AND l.language = li.language;


CREATE TABLE actor_movie(
	id_actor INT,
	id_movie INT,
	PRIMARY KEY (id_movie, id_actor),
	FOREIGN KEY (id_movie) REFERENCES movie(id_movie),
	FOREIGN KEY (id_actor) REFERENCES actor(id_actor)
);

INSERT INTO actor_movie
SELECT DISTINCT p.id_person, m.id_movie FROM person as p, movies_importacio as mi, movie as m
WHERE actor_1_name IS NOT NULL
AND actor_1_name = p.name
AND title = movie_title AND actor_1_name NOT LIKE ''
UNION
SELECT DISTINCT p.id_person, m.id_movie FROM person as p, movies_importacio as mi, movie as m
WHERE actor_2_name IS NOT NULL
AND actor_2_name = p.name
AND title = movie_title AND actor_2_name NOT LIKE ''
UNION
SELECT DISTINCT p.id_person, m.id_movie FROM person as p, movies_importacio as mi, movie as m
WHERE actor_3_name IS NOT NULL
AND actor_3_name = p.name
AND title = movie_title AND actor_3_name NOT LIKE '';




DROP TABLE IF EXISTS movies_importacio;
DROP TABLE IF EXISTS genres_importacio;
DROP TABLE IF EXISTS producer_importacio;
DROP TABLE IF EXISTS language_importacio;