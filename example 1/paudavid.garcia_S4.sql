-- Database: Sessio3

-- DROP DATABASE "Sessio3";

DROP TABLE IF EXISTS Import;
CREATE TABLE Import(
	Id 	INTEGER,
	First_name VARCHAR(255),
	Last_name VARCHAR (255),
	Email VARCHAR (255),
	Gender char (1),
	IPv4 cidr,
	Credit_Card serial8,
	Date_transaction date,
	IBAN VARCHAR (255),
	IPv6 cidr,
	Amount_Money VARCHAR(255), 
	Time_transaction time,
	Password_transaction VARCHAR(255),
	Currency_code char(3),
	Was_ok boolean, 
	Company_name VARCHAR(255),
	Department VARCHAR (255),
	Salary money,
	MAC macaddr
);

COPY Import FROM 'D:\Lab4.csv' DELIMITER AS ',' csv header;


--SELECT * from Import;


DROP TABLE IF EXISTS Taula_Persona;
CREATE TABLE Taula_Persona(
	id INTEGER,
	First_name VARCHAR(255),
	Last_name VARCHAR(255),
	email VARCHAR(255),
	gender char(1),
	salary money	
);

INSERT INTO Taula_Persona (id, First_name, Last_name, email, gender, salary) 
SELECT id, lower(First_name), lower(Last_name), email, gender, salary
from Import;

--SELECT * from Taula_Persona;


DROP TABLE IF EXISTS Taula_Connexió;
CREATE TABLE Taula_Connexió(
	id INTEGER,
	IPv4 cidr,
	IPv6 cidr,
	MAC macaddr
);

INSERT INTO Taula_Connexió (id, IPv4, IPv6, MAC)
SELECT id, IPv4, IPv6, MAC from Import;

--SELECT * from Taula_Connexió;

DROP TABLE IF EXISTS Taula_Transacció;
CREATE TABLE Taula_Transacció(
	id INTEGER,
	Date_transaction date,
	IBAN VARCHAR (255),
	Amount_Money VARCHAR (255),
	Time_transaction time,
	Password_transaction VARCHAR(255),
	Was_ok boolean,
	Credit_Card serial8,
	Currency_code char(3),
	CheckSum VARCHAR (255)
);

INSERT INTO Taula_Transacció (id , Date_transaction, IBAN, Amount_Money, Time_transaction, Password_transaction, Was_ok, Credit_Card, Currency_code, CheckSum)
SELECT id , Date_transaction, IBAN, Amount_Money, Time_transaction, translate (Password_transaction, 'abcdefghijklmnñopqrstuvwxyzABCDEFGHIJKLMNÑOPQRSTUVWXYZ', 'ABCDEFGHIJKLMNÑOPQRSTUVWXYZabcdefghijklmnñopqrstuvwxyz'), Was_ok, Credit_Card, Currency_code, MD5(concat(IBAN, Currency_Code)) 
from Import;



DROP TABLE IF EXISTS Taula_Treball;
CREATE TABLE Taula_Treball(
	id INTEGER,
	Company_name VARCHAR(255),
	Department VARCHAR (255),
	Num_department INTEGER
);

INSERT INTO Taula_Treball (id, Company_name, Department, Num_department)
SELECT id, Company_name, Department, char_length(department)
FROM Import;

SELECT * from Taula_Transacció;

--SELECT * from Taula_Treball;
------------
-- Exercici 2:
																		   
-- Quin comportament té aquest tipus de dades?																		  
-- Quan vam crear un tipus serial no cal ingressar un valor, donat que és un "camp autoincrement", és a dir, s'insereix automàticament prenent l'últim valor com a referència. 
																		   
-- Per quin aspecte vist a teoria creieu que pot servir?
-- Crec que pot ser útil per l'assignació de "Primary Keys" donat que mai es pot repetir (no ho fa), no pot valer null (sempre comença en 1) i permet identificar inequívocament qualsevol registre d'una taula (infinit nombres per infinites taules).																		   
																		  
																		   
-- Com és que per l'exercici 1 no necessitàvem aquest tipus de dades però ara si?																		   
-- És mes necessari en l'exercici 2, que en l'exercici 1 atès que en l'exercici 2 representa que anem rellendando la taula de noms sense cap ordre, el codi seria molt més extens si també tinguéssim afegir manualment el id. És a dir, la funció serial és molt útil quan volem fer un llistat.						
																		 