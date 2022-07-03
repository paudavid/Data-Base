#&&0
Drop Database If Exists s1;
Create Database s1;
Use s1;

#&&1
DROP TABLE IF EXISTS user;
Create Table user (
id_client int not null,
name varchar(255),
surname varchar(255),
gender varchar(1),
birthday date check (birthday>='2002-01-01'), 
city varchar(255),
Unique (id_client)
);

Create table serie(
id_serie serial not null, 
name varchar(255),
seasons int,
unique (id_serie)
);

Create table favorite(
id_serie int, 
id_user int, 
since date
);


#&&2
Insert Into user (id_client, name, surname, gender, birthday, city)
Values (1356, 'albert', 'ferrando', 'm', '1998-05-02', 'vendrell'), (2237, 'jaume', 'campeny','m','1998-02-20', 'granollers' ),
(7, 'anna', 'noguer', 'f','1999-08-07','girona' ), (8769, 'josep', 'roig', 'm','1999-06-20','amposta'), (6969, 'kermit', 'frog', 'o','1969-12-12', 'deltebre');

Insert into serie(name, seasons)
Values ('Money Heist', 4), ('13 reasons why', 3), ('The man in the high castle', 4), ('Stanger Things', 3), ('Game of thrones', 8);

Insert into favorite (id_serie, id_user, since)
VALUE (1, 1356, str_to_date('4/2/2018', '%d/%m/%Y')),  (2, 2237, str_to_date('3/12/2017','%d/%m/%Y')), (3,7, str_to_date('4/4/2018', '%d/%m/%Y')), (4, 8769, str_to_date('1/1/19', '%d/%m/%Y')), (1, 8769, str_to_date('1/1/2019', '%d/%m/%Y')), (5, 6969, str_to_date('29/6/2018', '%d/%m/%Y'));

#&&3
Select * from serie;
Select * from user; 
Select * from favorite;