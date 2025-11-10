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

-- сделать выборку по имени с WHERE
SELECT 
    first_name, last_name
FROM
    clients
WHERE
    last_name = 'Rossi';

-- сделать выборку по макс дате рождения с GROUP, ORDER BY, LIMIT
SELECT 
    first_name, last_name, MAX(date_of_birth) dob
FROM
    clients
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
    clients
HAVING age >= 30
ORDER BY age DESC;

-- сделать выборку по поиску инициалов пользователей с WHERE, ORDER BY
SELECT 
    first_name, last_name
FROM
    clients
WHERE
    last_name LIKE 'R%'
        OR last_name LIKE 'P%'
        OR last_name LIKE 'M%'
ORDER BY last_name DESC;

-- сделать выборку с COUNT
SELECT 
    COUNT(client_id)
FROM
    clients;
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
    clients
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
select * from clients
where client_id between 3 and 6;

-- сделать выборку с SELECT и LIKE&NOT LIKE
# обычные запросы с поиском по like&not like:
SELECT 
    *
FROM
    clients
WHERE
    email LIKE 'J%';

SELECT 
    *
FROM
    clients
WHERE
    last_name LIKE 'P%'
        AND first_name NOT LIKE 'J%';
        
# запрос с поиском имени с С в середине first_name:
SELECT 
    *
FROM
    clients
WHERE
    first_name LIKE '%C%';
    
# запрос с экранированием:
    SELECT 
    *
FROM
    clients
WHERE
    first_name LIKE '%\%';
    
# находим имя с двумя буквами 'a:
      SELECT 
    *
FROM
    clients
    where first_name like '%a%a%';

# работа с функцией length и разницей
	SELECT 
    first_name
   ,length(first_name) f_n_l
     /* , replace(first_name, 'a','') modified,
    length(replace(first_name, 'a','')) modif_length*/
FROM
    clients
      where (length(first_name) - length(replace(first_name, 'a',''))) >= 2
  order by first_name desc
;

# работа с длиной и нижними подчёркиваниями с определением длины слова
SELECT 
    first_name
    , length(first_name) lfn
FROM
    clients
    where first_name LIKE ('j__j%');
  
  # такой не работает, чтобы узнать кол-во символов
    SELECT 
    first_name
    , length(first_name) lfn
FROM
    clients
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
 
 -- 1-2. сделать выборку на 2ух таблицах с JOIN (INNER, OUTER, LEFT, RIGHT)
 
#CROSS JOIN
SELECT 
    *
FROM
    city,
    clients;

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
join clients c on c.client_id = i.client_id
join trip t on t.trip_id = i.trip_id
join city ci on t.city_id = ci.city_id
order by 1;

#LEFT JOIN

select first_name, last_name, i.inq_status, i.trip_id, ci.name, t.description, date_of_birth, max_capacity
from clients c
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

-- 3. сделать выборку на 2ух таблицах с JOIN вместе с WHERE, HAVING, GROUP BY
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

-- 4. для 1 таблицы вывести значения, которые не соединены первичным и внешним ключом с другой таблицей 
/*(большей частью показываем city_name, т.к. именно city_name не связана с табл clients внешними ключами)*/
SELECT 
    first_name, last_name, i.trip_id, c.name
FROM
    clients cl
        LEFT JOIN
    inquiry i ON i.client_id = cl.client_id
        LEFT JOIN
    trip t ON i.trip_id = t.trip_id
        LEFT JOIN
    city c ON c.city_id = t.city_id
ORDER BY 3 DESC
;
