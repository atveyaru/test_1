
/*

Schema - SEOTLT_TEST
Workspace - SEOTLT
Login - ADMIN
password - _S3otlt1

-- админка 1
http://45.141.77.95:7070/apex/apex_admin
-- админка 2
http://45.141.77.95:7070/apex
-- ссылка на тестовое задание
http://45.141.77.95:7070/apex/f?p=103

*/

-- damp (каток, запускать под SEOTLT_TEST)

begin execute immediate ('drop sequence RECID_S'); exception when others then null; end;
/

begin execute immediate ('drop trigger ST_CARS_insert'); exception when others then null; end;
/

begin execute immediate ('drop trigger ST_PROPRIETOR_insert'); exception when others then null; end;
/

begin execute immediate ('drop table ST_PROPRIETOR'); exception when others then null; end;
/

begin execute immediate ('drop table ST_CARS'); exception when others then null; end;
/

create sequence RECID_S
 minvalue 1
 maxvalue 999999999999999999999999999
 start with 1000
 increment by 1
 cache 20;  
/

create table ST_CARS
(
  recid  NUMBER NOT NULL,
  car_name  VARCHAR2(50),
  car_vin  VARCHAR2(50),
  car_family  VARCHAR2(50),
  comments  VARCHAR2(200),
  change  VARCHAR2(2)
);
alter table ST_CARS add constraint PK_ST_CARS primary key (recid) using index;
comment on table ST_CARS is 'Автомобили';
comment on column ST_CARS.recid is 'Уникальный ключ';
comment on column ST_CARS.car_name is 'Название автомобиля';
comment on column ST_CARS.car_vin is 'Вин автомобиля';
comment on column ST_CARS.car_family is 'Семейство автомобиля';
comment on column ST_CARS.change is 'Автомобиль на замене';
comment on column ST_CARS.comments is 'Коментарии к автомобилю';

create table ST_PROPRIETOR
(
  recid  NUMBER NOT NULL,
  cars_id NUMBER,
  fio  VARCHAR2(100),
  address  VARCHAR2(200)
);
alter table ST_PROPRIETOR add constraint PK_PROPRIETOR primary key (recid) using index;
alter table ST_PROPRIETOR add constraint FK_CARS$PROPRIETOR foreign key (cars_id) references ST_CARS(recid);
comment on table ST_PROPRIETOR is 'Владелец';
comment on column ST_PROPRIETOR.recid is 'Уникальный ключ';
comment on column ST_PROPRIETOR.cars_id is 'код а/м';
comment on column ST_PROPRIETOR.fio is 'ФИО владельца';
comment on column ST_PROPRIETOR.address is 'Адрес владельца';

create trigger ST_CARS_insert 
  before insert on ST_CARS
  for each row
begin
  select RECID_S.nextval into :new.recid from dual;
end;
/

create trigger ST_PROPRIETOR_insert 
  before insert on ST_PROPRIETOR
  for each row
begin
  select RECID_S.nextval into :new.recid from dual;
end;
/

insert into ST_CARS (CAR_NAME, CAR_VIN, CAR_FAMILY, COMMENTS, CHANGE)
select 'Нива' as CAR_NAME, '123' as CAR_VIN, 'внедорожник' as CAR_FAMILY, 'Комментарий' as COMMENTS, '0' as CHANGE from dual
union all
select 'калина', '456', 'лифтбек',  'Свежий комментарий', '1' from dual
union all
select 'приора', '789', 'седан', 'Новый комментарий', '0' from dual
union all
select 'веста', '001', 'универсал', 'Старый комментарий', '0' from dual;

commit;

insert into ST_PROPRIETOR (fio, address, cars_id)
select 'Кара Марск' as fio, 'Самара' as address, 1001 as st_cars_id from dual
union all
select 'Алетра Стараг', 'Кинель', 1001 from dual
union all
select 'Хама Баша', 'Сургут', 1002 from dual
union all
select 'Игната Боли', 'Питер', 1003 from dual

commit;

select * from ST_CARS;
select * from ST_PROPRIETOR;

commit;