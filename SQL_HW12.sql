DROP DATABASE IF EXISTS tours;
CREATE DATABASE IF NOT EXISTS tours;
-- -- Command + slash / -- hotkey for the comment
USE tours;

-- -----------------------------------------------------
-- Table client
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS client (
  client_id INT NOT NULL PRIMARY KEY auto_increment,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  phone VARCHAR(20) NOT NULL UNIQUE,
  email varchar(100) NOT NULL UNIQUE,
  note VARCHAR(255) DEFAULT NULL,
  status ENUM('new', 'repeated', 'VIP') DEFAULT 'new'
  );
  -- изменение таблицы
ALTER TABLE client
ADD address VARCHAR(255) NULL;

INSERT INTO client (first_name, last_name, phone, email) 
VALUES ('Valentina','Rossi','375295888878', 'valentina@mail.ru'),
('Jorje','Rossi','375298888889', 'jorje@mail.ru'),
('Lucia','Smith','375298888890', 'lucia@mail.ru'),
('Sam','Ivanov','375298888881', 'sam@mail.ru'),
('Bella','Petrov','375298883889', 'bella@mail.ru'),
('Jack','Pink','375298888878', 'jack@mail.ru'),
('Marie','Mouth','375294988889', 'mariee@mail.ru'),
('Ted%','Grizz','375293888889', 'ted@mail.ru'),
('Ruth','Lazlo','375298858889', 'ruth@mail.ru'),
('Victor','Herr','375296888889', 'victor@mail.ru'),
('Thomas','Mann','375298788889', 'thomas@mail.ru'),
('Ninon', 'De Lanclo', '33098765446', 'ninon@paris.fr');

SELECT * FROM client;
-- -----------------------------------------------------
-- Table city
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS city (
    city_id INT NOT NULL PRIMARY KEY auto_increment,
    name VARCHAR(50) NOT NULL,
    postal_code VARCHAR(15) NOT NULL unique,
    region VARCHAR(50) NOT NULL,
    details VARCHAR (255) NULL    
);

INSERT INTO city (name, postal_code, region) 
VALUES ('Minsk','225000','Minsk region'),
('Brest','225001','Brest region'),
('Gomel','225002','Gomel region'),
('Pinsk','225003','Brest region'),
('Nyasvizh','225004','Minsk region');

SELECT * FROM city;
-- -----------------------------------------------------
-- Table operator
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS operator (
    operator_id INT NOT NULL PRIMARY KEY auto_increment,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    operator_code VARCHAR(15) NOT NULL unique,
    email varchar(100) NOT NULL UNIQUE,
    phone VARCHAR(20) NOT NULL UNIQUE
);

INSERT INTO operator (first_name, last_name, operator_code, email, phone) 
VALUES ('Elena','Smith','OP4889','375296888329', 'elenafb@mail.ru'),
('Misha','Taz','OX7865','37529519320','mishafb@mail.ru'),
('Kate','Bush','KL1023','375291284329','katefb@mail.ru'),
('Alex','Mir','MN5679','375291284586','alexfb@mail.ru'),
('Marie','Curie','BY5432', '375291210320', 'mariefb@mail.ru');

SELECT * FROM operator;

-- -----------------------------------------------------
-- Table trip
-- -----------------------------------------------------
drop table if exists trip;

CREATE TABLE IF NOT EXISTS trip (
	trip_id INT NOT NULL PRIMARY KEY auto_increment,
    description VARCHAR(255) NULL UNIQUE,
    price DECIMAL (5,0) NOT NULL,
    start_date DATE,
    end_date DATE,
    duration INT,
    category ENUM ('love', 'sights', 'extreme'), #checkhere create a new table called 'category'
    max_capacity int,
    available_seats int null,
    city_id INT,
    operator_id INT,
    FOREIGN KEY (city_id) REFERENCES city(city_id), #check here
    FOREIGN KEY (operator_id) REFERENCES operator(operator_id) #check here
    );
    
INSERT INTO trip (description, price, category, max_capacity, city_id, operator_id, start_date) 
VALUES ('Weekend tour',35,'sights', 20, 1, 1, '2025-09-08'),
('Romantic tour',28,'love', 20, 2, 1, '2025-09-28'),
('Extreme tour',90,'extreme', NULL, 3, 2, '2025-07-04'),
('Photoshop tour',200,'sights', 10, 4, 4, '2025-01-29'),
('Culinary tour',350,'sights', 7, 5, 5, '2025-10-08');

SELECT * FROM trip;

-- -----------------------------------------------------
-- Table inquiry (junction table)
-- -----------------------------------------------------
drop table if exists inquiry;

CREATE TABLE IF NOT EXISTS inquiry (
    inquiry_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    inq_status ENUM ('pending', 'booked', 'cancelled'),
    created_at DATETIME,
    modified_at DATETIME,
    trip_id INT,
    client_id INT,
	FOREIGN KEY (trip_id) REFERENCES trip (trip_id), #check here
    FOREIGN KEY (client_id) REFERENCES client (client_id),
    UNIQUE (trip_id, client_id) #check here
    );
    
INSERT INTO inquiry (inq_status, created_at, modified_at, trip_id, client_id) 
VALUES ('pending', '2025-09-07 14:28:33', NOW(), 1, 7), #NOW т.к. даёт значение YYYY-MM-DD HH-MM-SS, а не CURDATE, который даёт только YYYY-MM-DD
('booked', '2025-09-25', NOW(), 1, 10),
('cancelled', '2025-07-01', NOW(), 3, 6),
('pending', '2025-01-23', NOW(), 4, 5),
('pending', '2025-01-23', '2025-02-26 10:56:01', 4, 4),
('booked','2025-09-30', '2025-10-31 08:04:20', 3, 9);

SELECT * FROM inquiry;


-- -----------------------------------------------------
-- Table car. NB, здесь можно было сделать bridge tble, чтобы у 1 водителя много машин и у 1 машины много водителей, 
-- но чтобы не иметь в учебном проекте много таблиц в данном случае приведена только 1 таблица.
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS car(
car_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
car_make VARCHAR(15) NOT NULL,
car_code VARCHAR(10) NOT NULL,
model_year YEAR);

INSERT INTO car (car_make, car_code, model_year)
VALUES ('Volvo', 'BY1654', '2008'),
('Mercedez', 'BY1013', '2018'),
('Geely', 'BY1456', '2021'),
('Ford', 'BY9015', '2018'),
('FIAT', 'BY3134', '2020');

select * from car;

-- -----------------------------------------------------
-- Table driver
-- -----------------------------------------------------

drop table if exists driver;

CREATE TABLE IF NOT EXISTS driver (
   driver_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
   first_name VARCHAR(50) NOT NULL,
   last_name VARCHAR(50) NOT NULL,
   car_id INT,
   rate_hour DECIMAL (5,0) NOT NULL,
   FOREIGN KEY(car_id) REFERENCES car(car_id)
   );
   
  INSERT INTO driver (first_name, last_name, car_id, rate_hour)
  VALUES ('Vlad', 'Komarov', 3, 123),
  ('Misha', 'Ivanov', 4, 55),
  ('Givi', 'Gruzin', 2, 63),
  ('Kolya', 'Fedorov', 1, 85),
  ('Serge', 'Stilavin', 5, 45)
  ;
  
  select * from driver;
  
-- -----------------------------------------------------
-- Table trip_driver
-- -----------------------------------------------------
 drop table if exists trip_driver;
 
CREATE TABLE IF NOT EXISTS trip_driver (
    trip_id INT NOT NULL,
    driver_id INT NOT NULL,
    PRIMARY KEY (trip_id, driver_id),
	FOREIGN KEY (trip_id) REFERENCES trip (trip_id),
    FOREIGN KEY (driver_id) REFERENCES driver (driver_id)
    );
    
    INSERT INTO trip_driver (trip_id, driver_id)
    VALUES (2,3),
    (4,5),
    (1,2),
    (3,4),
    (1,5);
    
    select * from trip_driver;
    
-- добавить ещё 1 колонку с датой рождения
ALTER TABLE client
ADD date_of_birth DATE;

-- сделать запрос на всю выборку
SELECT 
    *
FROM
    client;

-- добавить данные о рождении
UPDATE client 
SET 
    date_of_birth = CASE client_id
        WHEN 1 THEN '1996-12-12'
        WHEN 2 THEN '1995-06-06'
        WHEN 3 THEN '1999-09-07'
        WHEN 4 THEN '1993-01-03'
        WHEN 5 THEN '1998-03-04'
        WHEN 6 THEN '1991-11-28'
        WHEN 7 THEN '2001-11-09'
        WHEN 8 THEN '1998-03-02'
        WHEN 9 THEN '1998-03-02'
        WHEN 10 THEN NULL
        WHEN 11 THEN '1993-12-25'
    END
WHERE
    client_id BETWEEN 1 AND 11;
;

select * from client;

-- сделать выборку по имени с WHERE
SELECT 
    first_name, last_name
FROM
    client
WHERE
    last_name = 'Rossi';

-- сделать выборку по макс дате рождения с GROUP, ORDER BY, LIMIT
SELECT 
    first_name, last_name, MAX(date_of_birth) dob
FROM
    client
GROUP BY 1 , 2
ORDER BY dob
LIMIT 3;

-- сделать выборку с HAVING, ORDER
SELECT 
    first_name,
    last_name,
    date_of_birth,
    ROUND(DATEDIFF(CURDATE(), date_of_birth) / 365,
            0) AS age
FROM
    client
HAVING age >= 30
ORDER BY age DESC;

-- сделать выборку по поиску инициалов пользователей с WHERE, ORDER BY
SELECT 
    first_name, last_name
FROM
    client
WHERE
    last_name LIKE 'R%'
        OR last_name LIKE 'P%'
        OR last_name LIKE 'M%'
ORDER BY last_name DESC;

-- сделать выборку с COUNT
SELECT 
    COUNT(client_id)
FROM
    client;
-- сделать выборку из другой таблицы
SELECT 
    *
FROM
    city;

-- сделать выборку с WHERE
SELECT 
    name, region
FROM
    city
WHERE
    region = 'Minsk region';
    
    -- сделать выборку по поиску инициалов пользователей с WHERE [or, or, and], ORDER BY
SELECT 
    first_name, last_name, date_of_birth
FROM
    client
WHERE
    (last_name LIKE 'R%'
        OR last_name LIKE 'P%'
        OR last_name LIKE 'M%')
        AND date_of_birth = '1996-12-12'
ORDER BY last_name DESC;

-- сделать выборку с order by
SELECT 
    name
FROM
    city
    ORDER BY 1 DESC;
    
    -- сделать выборку с максимальным почтовым индексом
SELECT 
    name, max(postal_code)
FROM
    city
GROUP BY name
ORDER BY max(postal_code) DESC;

-- -----------------------------------------------------
-- сделать выборку с between
select * from client
where client_id between 3 and 6;

-- сделать выборку с SELECT и LIKE&NOT LIKE
# обычные запросы с поиском по like&not like:
SELECT 
    *
FROM
    client
WHERE
    email LIKE 'J%';

SELECT 
    *
FROM
    client
WHERE
    last_name LIKE 'P%'
        AND first_name NOT LIKE 'J%';
        
# запрос с поиском имени с С в середине first_name:
SELECT 
    *
FROM
    client
WHERE
    first_name LIKE '%C%';
    
# запрос с экранированием:
    SELECT 
    *
FROM
    client
WHERE
    first_name LIKE '%\%';
    
# находим имя с двумя буквами 'a:
      SELECT 
    *
FROM
    client
    where first_name like '%a%a%';

# работа с функцией length и разницей
	SELECT 
    first_name
   ,length(first_name) f_n_l
     /* , replace(first_name, 'a','') modified,
    length(replace(first_name, 'a','')) modif_length*/
FROM
    client
      where (length(first_name) - length(replace(first_name, 'a',''))) >= 2
  order by first_name desc
;

# работа с длиной и нижними подчёркиваниями с определением длины слова
SELECT 
    first_name
    , length(first_name) lfn
FROM
    client
    where first_name LIKE ('j__j%');
  
  # такой не работает, чтобы узнать кол-во символов
    SELECT 
    first_name
    , length(first_name) lfn
FROM
    client
    where first_name LIKE ('____') = 4; # а так не отработает
    
select 15 % 3, 15 / 5 ; # простоможетработатьтак

-- Cделать выборку с SELECT и CASE
# вывести все записи с 1, если inq_status = 'pending', иначе 0
SELECT 
    inquiry_id,
    inq_status,
    CASE
        WHEN inq_status = 'pending' THEN 1
        ELSE 0
    END AS inq_status_id
FROM
    inquiry;
 
# вывести все записи с ASAP, если inq_status = 'BOOKED', иначе 'RELAX'
 SELECT 
    inquiry_id,
    inq_status,
    CASE
        WHEN inq_status = 'booked' THEN 'ÁSAP'
        ELSE 'RELAX'
    END AS inq_status_id
FROM
    inquiry
ORDER BY 3;


-- Cделать выборку со сравнением времени
# выборка сколько прошло дней с 1 до 2 даты
 SELECT 
    inquiry_id,
    created_at,
    modified_at,
    DATEDIFF(modified_at, created_at) AS 'прошло'
FROM
    inquiry;
 
# выборка даты меньшей '2025-06-30'
 SELECT 
    *
FROM
    inquiry
WHERE
    created_at > '2025-06-30'; #created_at уже в формате DATE, cама дата в кавычках

# выборка месяца и дня недели
SELECT 
    *,
    DATE_FORMAT(created_at, '%M') AS month,
    DATE_FORMAT(created_at, '%W') AS weekday
FROM
    inquiry
WHERE
    DATE_FORMAT(created_at, '%a') = 'Tue'; 

# выборка месяца и дня недели вместе через пробел '%M %W'
SELECT 
    *, DATE_FORMAT(created_at, '%M %W') AS month_week
FROM
    inquiry;
  
# а тут просто вычитает большие числа, т.к. должна быть datediff для дат, последнее число как пример
 SELECT 
    *,
    modified_at - created_at AS 'разница',
    20251108 - 20250907
FROM
    inquiry
LIMIT 3;

-- Сделать выборку с выводом всех нулевых и пустых значений
SELECT 
    *
FROM
    trip
WHERE
    available_seats IS NOT NULL;

-- Сделать выборку с GROUP BY, CASE, WHERE
SELECT 
    *
FROM
    trip
WHERE
    CASE
        WHEN category = 'sights' THEN 1
        ELSE 0
    END = 1;

# выборка с GROUP BY, HAVING
SELECT 
    trip_id,
    description,
    category,
    max_capacity,
    start_date,
    operator_id,
    CASE
        WHEN start_date > '2025-08-01' THEN 1
        ELSE 0
    END AS 'tour_time'
FROM
    trip
GROUP BY trip_id , description , category , max_capacity , start_date , operator_id
HAVING max_capacity > 10
ORDER BY tour_time DESC;
 
 -- сделать выборку на 2ух таблицах с JOIN (INNER, OUTER, LEFT, RIGHT)
 
#CROSS JOIN
SELECT 
    *
FROM
    city,
    client;

#INNER JOIN и соединение без JOIN но в where
SELECT 
    *
FROM
    operator o,
    trip t
WHERE
    o.operator_id = t.operator_id;

SELECT 
    *
FROM
    operator o
        INNER JOIN
    trip t ON o.operator_id = t.operator_id;
    
#INNER JOIN 
select first_name, last_name, email, i.inq_status, i.trip_id, ci.name, t.description, date_of_birth, max_capacity
from inquiry i
join client c on c.client_id = i.client_id
join trip t on t.trip_id = i.trip_id
join city ci on t.city_id = ci.city_id
order by 1;

#LEFT JOIN

select first_name, last_name, i.inq_status, i.trip_id, ci.name, t.description, date_of_birth, max_capacity
from client c
left join inquiry i on c.client_id = i.client_id
left join trip t on t.trip_id = i.trip_id
left join city ci on t.city_id = ci.city_id
order by 4, 1;

#FULL OUTER JOIN

select trip_id, city_id, description, category, o.operator_id, first_name, last_name
from trip t
left join operator o on o.operator_id = t.operator_id
union #full outer join не поддерживается, но можно сделать с l&r joins + union
select trip_id, city_id, description, category, o.operator_id, first_name, last_name
from trip t
right join operator o on o.operator_id = t.operator_id
order by 1;

# а можно было выше запрос чз left join
select trip_id, city_id, description, category, o.operator_id, first_name, last_name
from operator o
left join trip t on o.operator_id = t.operator_id
order by 1;

-- сделать выборку на 2ух таблицах с JOIN вместе с WHERE, HAVING, GROUP BY
SELECT 
    c.name AS city, price, start_date, max_capacity
FROM
    city c
        LEFT JOIN
    trip t ON t.city_id = c.city_id
WHERE
    max_capacity IS NULL;

SELECT 
    i.client_id,
    c.name,
    price,
    start_date,
    inq_status,
    price * 0.1 AS discount
FROM
    city c
        LEFT JOIN
    trip t ON t.city_id = c.city_id
        LEFT JOIN
    inquiry i ON i.trip_id = t.trip_id
WHERE
    i.client_id IS NOT NULL
        AND inq_status != 'cancelled'
GROUP BY c.name , price , start_date , i.client_id , inq_status
HAVING discount > 10
ORDER BY 2 , 5;

-- для 1 таблицы вывести значения, которые не соединены первичным и внешним ключом с другой таблицей 
/*(большей частью показываем city_name, т.к. именно city_name не связана с табл client внешними ключами)*/
SELECT 
    first_name, last_name, i.trip_id, c.name
FROM
    client cl
        LEFT JOIN
    inquiry i ON i.client_id = cl.client_id
        LEFT JOIN
    trip t ON i.trip_id = t.trip_id
        LEFT JOIN
    city c ON c.city_id = t.city_id
ORDER BY 3 DESC
;
-- concat 
select concat(first_name, ' ', phone) as client_data
from client;

select concat_ws(' ', last_name, operator_code) as operator_data
from operator;

-- length
select length('weekend tour');

-- substring_index из столбца;
select substring_index(description, ' ', 1) from trip; -- забавно что можно даже из столбца вывести;

-- substring_index;
select concat_ws(' ', substring_index(description, ' ', 1), price) as tour_price from trip;

-- выставить новую цену с 15% скидкой, округлить до целого используя round;
select trip_id, substring_index(description, ' ', 1) t_name, price, price*0.15 as discount, 
round((price - price*0.15), 0) as new_price from trip;

-- найти случайного победителя для free tour. Формула RAND() * (max - min) + min;
select floor(rand()*11+1) winner; -- у меня 12 client, выбираем счастливчика;

-- найти счастливчика но чз запрос попроще;
select client_id, first_name, last_name
from client
order by RAND()
LIMIT 1;

-- перевести цену в валюту;
select substring_index(description, ' ', 1) as t_name, 
price/ 2.9214 as USD
from trip;

-- перевести цену в валюту и округлить до целого в сторону чётного (т.е. нулем));
select substring_index(description, ' ', 1) as t_name, 
round(price/ 2.9214, -1) as USD
from trip;

-- возвести в степень price (я не знаю, что ещё здесь придумать, lol);
select substring_index(description, ' ', 1) as t_name, power(price, 2) from trip;

-- это можно с if выставить новую цену с 15% скидкой, округлить до целого используя round;
select trip_id, substring_index(description, ' ', 1) t_name, price, price*0.15 as discount, 
round((price - price*0.15), 1) as new_price from trip;

-- функции времени
select now(); -- не знаю, что с ней придумать;

-- datediff 
select substring_index(description, ' ', 1) t_name, start_date, datediff(now(), start_date) as 'прошло дней' from trip;

select sysdate(); -- не знаю, что с ней придумать;

select curtime(); -- не знаю, что с ней придумать;

-- функция if;

select * ,
if (max_capacity >= 10, 'премия', 'штраф') бонус
from trip;

-- функция ifnull;
select * from trip;
select substring_index(description, ' ', 1) t_name, start_date, ifnull(max_capacity, 'идёт набор') as max_capacity
from trip;

select substring_index(description, ' ', 1) t_name, start_date, ifnull(end_date, 'подробности в лс') as end_date
from trip;

select first_name, last_name, ifnull(date_of_birth, 'позвонить-уточнить') 'детали'
from client;

select substring_index(description, ' ', 1) t_name, start_date, ifnull(available_seats, 'места ещё есть') as available_seats
from trip;

-- функция coalesce работает также как ifnull
select * from client;
select first_name, last_name, coalesce(date_of_birth, date_of_birth, 'позвонить-уточнить') 'детали'
from client;

-- агрегирующая функция MIN&MAX;

select * from driver;

select max(rate_hour), min(rate_hour) from driver;

select first_name, max(rate_hour) BYN from driver
group by 1
limit 1;

-- функция MAX с подзапросом;
select first_name, last_name, rate_hour as BYN from driver where rate_hour =
(select max(rate_hour) from driver
);

select first_name, description, max_capacity from driver d
join trip_driver td on td.driver_id = d.driver_id
join trip t on td.trip_id = t.trip_id
where max_capacity in (select max(max_capacity) from trip);

select * from trip_driver;

 -- функция SUM
 select sum(rate_hour) from driver;
 
 -- функция AVERAGE & ROUND
 select round(avg(rate_hour),2) as BYN from driver;
 
-- функция с having&group by 
select first_name, last_name, car_make, max(rate_hour*8) day_pay from driver d
JOIN car c on c.car_id = d.car_id
group by first_name, last_name, car_make
having day_pay > 500;

-- получить имена без первой и последней буквы

select * from driver;

select first_name,
	MID(first_name, 3, length(first_name)-2) -- начиная с 3ей буквы вырезаем только 2 символа (вся длина - 3)
    from driver;

select first_name,
	MID(first_name, 3, length(first_name)-3) -- начиная с 3ей буквы вырезаем 2 символа (вся длина - 3)
    from driver;
    
-- функция case: вывести имя  и фам водителя, почасовую ставку, и доп. столбец rate_category, где
-- если ставка больше 80, вывести HIGH, если между 50 и 79 – MEDIUM, остальное – LOW.

SELECT first_name, last_name, rate_hour,
 CASE WHEN rate_hour > 80  THEN 'HIGH'
 WHEN rate_hour BETWEEN 50 AND 79 THEN 'MEDIUM'
ELSE 'LOW'
END AS rate_category
 FROM driver
 order by 1;
 
 -- подзапрос в SELECT c exists с корелляцией по id;
 
 select first_name from client c
 where exists (select * from inquiry i 
 where i.client_id = c.client_id
 and inq_status = 'pending');

-- подзапрос в SELECT для вывода имени и фамилии каждого оператора 
-- и количество уникальных клиентов, бронировавших туры этого оператора;

select operator_id, first_name, last_name
, (select count(i.client_id)
from trip t
join inquiry i on i.trip_id = t.trip_id
where t.operator_id = o.operator_id
) as count_u
from operator o;

-- подзапроc в SELECT вывести для каждого города его название
-- и количество различных клиентов, которые подавали заявки на туры, проходящие в нём;

select name 
, (select count(distinct client_id) from inquiry i
join trip t on t.trip_id = i.trip_id
where t.city_id = c.city_id) as count_clients
from city c
having count_clients > 1;

-- Подзапрос в SELECT вывеcти имена и фамилии клиентов
-- и общую стоимость всех туров, которые они забронировали (т.е. заявки в inquiry со статусом 'booked');

select first_name, last_name
, (select sum(price) from trip t
join inquiry i on i.trip_id = t.trip_id
where i.client_id = c.client_id
and 
i.inq_status = 'booked') as total_
from client c
having total_ > 0;

-- 5. подзапрос в insert с вставкой нового запроса от клиента;

insert into inquiry (inq_status, created_at, modified_at, trip_id, client_id)
values ('pending', NOW(), NOW(),  												
(select trip_id from trip where description = 'Romantic tour'),
(select client_id from client where email = 'valentina@mail.ru')); 

#проверка;
select * from inquiry where client_id = 1; 

-- 6. подзапрос с delete, удалить все туры из таблицы trip, по которым не было подано ни одной заявки;

delete from trip
where trip_id in (select trip_id 
					from (select trip.trip_id from trip
					left join inquiry i on i.trip_id = trip.trip_id
					 where inquiry_id is null) x);
                     
#or

-- отключить safe mode;
SET SQL_SAFE_UPDATES = 0; 

delete t from trip t # зачем здесь t
left join inquiry i 
on i.trip_id = t.trip_id
where inquiry_id is null;

#возвращаем строку;
INSERT INTO trip (trip_id, description, price, category, max_capacity, city_id, operator_id, start_date) 
VALUES(5, 'Culinary tour',350,'sights', 7, 5, 5, '2025-10-08'); 

-- подзапрос в DELETE c exists;
 delete from trip
 where not exists (select * from inquiry i 
 where i.trip_id = t.trip_id);
 
 #возвращаем строку
INSERT INTO trip (trip_id, description, price, category, max_capacity, city_id, operator_id, start_date) 
VALUES(5, 'Culinary tour',350,'sights', 7, 5, 5, '2025-10-08'); 
 
select * from trip;

-- подзапрос с UPDATE по обновлению мест, чтобы столбец available_seats отражал количество свободных мест;
update trip as t
 join		   (
				select trip_id, 
					count(trip_id) as booked_count from inquiry i
				where inq_status = 'booked'
				group by 1
                ) 
				as a 
                    on a.trip_id = t.trip_id
set t.available_seats = if(t.max_capacity is not null, t.max_capacity - a.booked_count, +1);

select * from trip;

-- включить safe mode;
SET SQL_SAFE_UPDATES = 1;

-- создать таблицу для логов 

CREATE TABLE IF NOT EXISTS logs (
    log_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    event_time DATETIME NOT NULL DEFAULT NOW(),
    log_type ENUM('INFO', 'WARNING', 'ERROR', 'SYSTEM') NOT NULL,
    table_name VARCHAR(50) NULL,
    record_id INT NULL,
    action ENUM('INSERT', 'UPDATE', 'DELETE') NULL,
    message VARCHAR(255) NOT NULL,
    user_info VARCHAR(100) NULL
);
INSERT into logs (log_type, table_name, record_id, message)
VALUES ('system', 'trip', 2, 'message 1' ),
  ('error', 'trip', 3, 'message 2'),
  ('info', 'trip', 4, 'message 3');
  
  select * from logs;
  
-- создать транзакцию;
 
  start transaction;
  
  update trip
  set price = price*2
  where description = 'weekend tour';

  insert into logs (log_type, table_name, record_id, message)
  values('info', 'trip', 5, 'updated price for weekend_tour');
  commit;
 
  -- откатить
  start transaction;
  update trip
  set price = price*2
  where description = 'weekend tour';
  rollback;
  select * from trip;
  
  -- 1. создание вьюшки с использованием полей 1 таблицы;
  create view v_cars as
  select car_make, car_code, model_year 
  , concat(car_make, ': ', model_year) as car_info
  from car;
  
  select * from car;
  select * from v_cars;
  select * from driver;
  
  -- 2. создание вьюшки с подзапросом, где вывести инфо по машине и водителю с именем Vlad;
  create or replace view v_driver as
  select c.car_code, 
        concat(car_make, ': ', model_year) as car_info,
        (select concat(first_name, ' ', last_name, ': ', rate_hour) as d_info
			from driver d
			where d.car_id = c.car_id) 
			as d_info
			from car c
            join driver d on d.car_id = c.car_id 
            where d.first_name = 'Vlad';
  
  select * from v_driver;
  
 -- 3. обновить вью, редактировать FIAT на fiat;
 UPDATE v_cars set car_make = 'Fiat' where car_make = 'FIAT';
 
 -- 4. добавить данные во view, но не будет работать, тк insert работает только с таблицами
  insert into v_cars(car_make, car_code, model_year)
  values(Opel, BY6789, 2012);

-- 5. запрос с использованием представления;
 select car_make, car_code
 from v_cars
 where model_year = 2018
 limit 3;
 
 -- 6. удаление вью;
  drop view v_driver;

