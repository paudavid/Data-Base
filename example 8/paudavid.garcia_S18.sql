#&&0

Use lsZon; 

#&&1

DELIMITER $$
Drop procedure if exists getId $$

Create procedure getId(in id_card_in varchar(255), out id_person1 int)
begin
    select id_person into id_person1 from persona where id_card_in = id_card limit 1;
    if id_person1 IS NULL then 
        set id_person1 = -1;
    end if;
end $$
delimiter ;

#&&2

Call lsZon.getId("f324A", @result);

#&&3

SELECT @result;

#&&4

DELIMITER $$
Drop procedure if exists masterControlBadge $$
Create procedure masterControlBadge(in id_person_in int, out wasFound int)
begin
	declare acabat int default 0;
    declare temps datetime;
    declare temps2 datetime;
    declare auxiliar int default 0;
    declare auxiliar2 int default 0;
    Declare cur1 cursor for select access_in from Timer;
    Declare cur2 cursor for select access_out from Timer;
    Declare continue handler for not found set acabat=1;
open cur1;
	buscador:loop
		fetch cur1 into temps;
        if acabat=1 then
            leave buscador;
        end if;
    end loop buscador;
    set acabat = 0;
	if TIMEDIFF(now(), temps)> "08:00:00" then
		open cur2;
			buscador2:loop
				fetch cur2 into temps2;
				if acabat=1 then
					leave buscador2;
				end if;
			end loop buscador2;
			if TIMEDIFF(temps, temps2)> "00:00:00" or ((select access_out from timer) is null) then
				insert into timer(access_in, id_person) values (now(), id_person_in);
				update timer set access_out="2000-01-01 00:00:00" where id_person = id_person_in and access_in = temps;
				insert into oficina(id_person, access_in) values (id_person_in, now());
				set wasFound = 0;
			end if;
			if TIMEDIFF(temps, temps2)< "00:00:00" then
				insert into timer(access_in, id_person) values (now(), id_person_in);
				insert into oficina(id_person, access_in) values (id_person_in, now());
				set wasFound = 1;
			end if;
		set auxiliar = 1;
    end if;
    if auxiliar = 0 then
		if TIMEDIFF(now(), temps)< "00:00:20" then
			delete from oficina where id_person=id_person_in;
			insert into magatzem(id_person, access_in) values (id_person_in, now());
            set wasFound = 2;
		end if;
		if TIMEDIFF(now(), temps)> "00:00:20" then
			if ((select id_person from Oficina) is not null) or ((select id_person from Magatzem) is not null) then
				update timer set access_out=now() where id_person = id_person_in and access_in = temps;
				if (select id_person from magatzem) is not null then
					delete from magatzem where id_person = id_person_in;
				end if;
				if (select id_person from oficina) is not null then
					delete From oficina where id_person = id_person_in;
				end if;
				set wasFound = 3;
                set auxiliar2=1;
			end if;
			if ((select id_person from oficina) is null) and ((select id_person from magatzem) is null) and (auxiliar2=0) then
				insert into oficina(id_person, access_in) values (id_person_in, now());
				insert into timer(access_in, id_person) values (now(), id_person_in);
				set wasFound = 1;
			end if;
		end if;
	end if;
end $$
delimiter ;

#&&5

CALL lsZon.masterControlBadge(1, @result);

#&&6

SELECT @result;

