DROP DATABASE IF EXISTS tours;
CREATE DATABASE IF NOT EXISTS tours;
-- -- Command + slash / -- hotkey for the comment
USE tours;

-- -----------------------------------------------------
-- Table clients
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS clients (
  client_id INT NOT NULL PRIMARY KEY auto_increment,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  phone VARCHAR(20) NOT NULL UNIQUE,
  email varchar(100) NOT NULL UNIQUE,
  note VARCHAR(255) DEFAULT NULL,
  status ENUM('new', 'repeated', 'VIP') DEFAULT 'new'
  );
  -- изменение таблицы
ALTER TABLE clients
ADD address VARCHAR(255) NULL;


INSERT INTO clients (first_name, last_name, phone, email) 
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

SELECT * FROM clients;
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
    operator_code VARCHAR(15) NOT NULL unique 
);

INSERT INTO operator (first_name, last_name, operator_code) 
VALUES ('Elena','Smith','OP4889'),
('Misha','Taz','OX7865'),
('Kate','Bush','KL1023'),
('Alex','Mir','MN5679'),
('Marie','Curie','BY5432');

SELECT * FROM operator;

SELECT operator_id, count(*) 
FROM operator
group by 1
having operator_id in (2,4,5);

-- -----------------------------------------------------
-- Table trip
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS trip (
	trip_id INT NOT NULL PRIMARY KEY auto_increment,
    description VARCHAR(255) NULL UNIQUE,
    price DECIMAL (5,0) NOT NULL,
    start_date DATE,
    end_date DATE,
    duration INT,
    category ENUM ('love', 'sights', 'extreme'),
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

select min(price), max(price) from trip; 

-- вывод макс суммы с подзапросом
SELECT * FROM trip where price in (select max(price) from trip);
-- -----------------------------------------------------
-- Table inquiry (junction table)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS inquiry (
    inquiry_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    inq_status ENUM ('pending', 'booked', 'cancelled'),
    created_at DATE,
    modified_at DATE,
    trip_id INT,
    client_id INT,
	FOREIGN KEY (trip_id) REFERENCES trip (trip_id), #check here
    FOREIGN KEY (client_id) REFERENCES clients (client_id),
    UNIQUE (trip_id, client_id) #check here
    );
    
INSERT INTO inquiry (inq_status, created_at, modified_at, trip_id, client_id) 
VALUES ('pending', '2025-09-07', curdate(), 1, 7),
('booked', '2025-09-25', curdate(), 1, 10),
('cancelled', '2025-07-01', curdate(), 3, 6),
('pending', '2025-01-23', curdate(), 4, 5),
('pending', '2025-01-23', '2025-02-26', 4, 4),
('booked','2025-09-30', '2025-10-31', 3, 9);

SELECT * FROM inquiry;

-- добавить ещё 1 колонку с датой рождения
ALTER TABLE clients
ADD date_of_birth DATE;

-- сделать запрос на всю выборку
SELECT 
    *
FROM
    clients;

-- добавить данные о рождении
UPDATE clients 
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

select * from clients;
select * from operator;
select * from trip;

-- 1. concat 
select concat(first_name, ' ', phone) as client_data
from clients;

select concat_ws(' ', last_name, operator_code) as operator_data
from operator;

-- length
select length('weekend tour');

-- substring_index из столбца;
select substring_index(description, ' ', 1) from trip; -- забавно что можно даже из столбца вывести;

-- substring_index;
select concat_ws(' ', substring_index(description, ' ', 1), price) as tour_price from trip;

-- 2. выставить новую цену с 15% скидкой, округлить до целого используя round;
select trip_id, substring_index(description, ' ', 1) t_name, price, price*0.15 as discount, 
round((price - price*0.15), 0) as new_price from trip;

-- найти случайного победителя для free tour. Формула RAND() * (max - min) + min;
select floor(rand()*11+1) winner; -- у меня 12 clients, выбираем счастливчика;

-- найти счастливчика но чз запрос попроще;
select client_id, first_name, last_name
from clients
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

-- 3. функции времени
select now(); -- не знаю, что с ней придумать;

-- datediff 
select substring_index(description, ' ', 1) t_name, start_date, datediff(now(), start_date) as 'прошло дней' from trip;

select sysdate(); -- не знаю, что с ней придумать;

select curtime(); -- не знаю, что с ней придумать;

-- 4. функция if;

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
from clients;

select substring_index(description, ' ', 1) t_name, start_date, ifnull(available_seats, 'места ещё есть') as available_seats
from trip;

-- функция coalesce работает также как ifnull
select * from clients;
select first_name, last_name, coalesce(date_of_birth, date_of_birth, 'позвонить-уточнить') 'детали'
from clients;
