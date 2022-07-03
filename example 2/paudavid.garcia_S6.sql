-- Database: Sessio6

-- DROP DATABASE "Sessio6";



DROP TABLE IF EXISTS Taula_Actor CASCADE;
CREATE TABLE Taula_Actor(
	id_actor SERIAL,
	name VARCHAR(255),
	fb_likes INTEGER,
	PRIMARY KEY (id_actor)
);

DROP TABLE IF EXISTS Taula_Movie CASCADE;
CREATE TABLE Taula_Movie(
	id_movie SERIAL,
	title VARCHAR(255),
	duration INTEGER,
	PRIMARY KEY (id_movie)
);

DROP TABLE IF EXISTS Taula_plays CASCADE;
CREATE TABLE Taula_plays(
	id_actor SERIAL,
	id_movie SERIAL,
	is_main_character boolean,
	PRIMARY KEY (id_actor, id_movie),
	FOREIGN KEY (id_actor) REFERENCES Taula_Actor (id_actor),
	FOREIGN KEY (id_movie) REFERENCES Taula_Movie (id_movie)
);

DROP TABLE IF EXISTS Taula_Importacio;
CREATE TABLE Taula_Importacio(
	title VARCHAR(255),
	duration INTEGER,
	name VARCHAR(255),
	fb_likes INTEGER,
	is_main_character boolean
);

Copy Taula_Importacio From 'D:\movie.csv' DELIMITER AS ';' csv header;

INSERT INTO Taula_Actor (name, fb_likes)
SELECT DISTINCT name, fb_likes
FROM Taula_Importacio;


INSERT INTO Taula_Movie (title, duration) 
SELECT distinct  title, duration
FROM Taula_Importacio
group by title, duration;


INSERT INTO Taula_Plays (id_actor, id_movie, is_main_character) 
SELECT Taula_Actor.id_actor, Taula_Movie.id_movie, Taula_Importacio.is_main_character
FROM Taula_Actor NATURAL JOIN Taula_Movie NATURAL JOIN Taula_Importacio;

--SELECT name, title, is_main_character from Taula_Importacio where name='Julie Walters' and title='Brave' and is_main_character='false';

--SeLECT distinct * from Taula_movie;
--SELECT distinct * from Taula_actor;
--SELECT distinct * from Taula_plays;


