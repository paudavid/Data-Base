
--1.
--#&&
SELECT id_usuari From Usuari, Ocupacio
WHERE usuari.id_ocupacio=ocupacio.id_ocupacio and (codi_postal = '94114') and (nom_ocupacio='programmer')
order by id_usuari;


--2. 
--#&&
SELECT titol FROM Pelicula, Pelicula_Genere, Genere 
WHERE (Pelicula.id_pelicula = Pelicula_Genere.id_pelicula) AND (Pelicula_Genere.id_genere = Genere.id_genere) AND (Pelicula.id_pelicula = ANY(SELECT id_pelicula FROM Usuari_Pelicula GROUP BY id_pelicula HAVING (AVG(estrelles) =  1))) AND (nom_genere = 'Western');



--3.
--#&&				   
SELECT de, a, count(id_usuari) from Usuari, RangEdat
WHERE usuari.id_rangEdat= rangedat.id_rangEdat
group by rangedat.id_rangedat order by count(id_usuari)DESC;



--4. 
--#&&
SELECT sexe, round(avg(estrelles),3) FROM Usuari_Pelicula, Usuari
WHERE usuari_pelicula.id_usuari=usuari.id_usuari
group by sexe;


--5.
--#&& 

SELECT titol, avg(estrelles) FROM Pelicula, Usuari_Pelicula, Usuari
WHERE usuari_pelicula.id_usuari=usuari.id_usuari and usuari_pelicula.id_pelicula = pelicula.id_pelicula and usuari_pelicula.id_pelicula = any(select id_usuari from Usuari_pelicula group by id_usuari having (sum(id_usuari)>2000) order by (round(avg(estrelles),3))desc)
group by pelicula.titol, pelicula.id_pelicula, usuari_pelicula.id_pelicula
having count(usuari_pelicula.id_usuari)>2000
order by avg(estrelles) desc
limit 5;








