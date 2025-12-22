DROP DATABASE IF EXISTS tours;
CREATE DATABASE IF NOT EXISTS tours;
USE tours;

-- Table client
DROP TABLE IF EXISTS client;

CREATE TABLE IF NOT EXISTS client (
  client_id INT NOT NULL PRIMARY KEY auto_increment,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  phone VARCHAR(20) NOT NULL UNIQUE,
  email varchar(100) NOT NULL UNIQUE,
  note VARCHAR(255) DEFAULT NULL,
  status ENUM('new', 'repeated', 'VIP') DEFAULT 'new',
  CHECK(REGEXP_LIKE(phone, '^\\+[1-9][0-9]{1,14}$')));
  
  -- изменение таблицы
ALTER TABLE client
ADD address VARCHAR(255) NULL;

INSERT INTO client (first_name, last_name, phone, email) 
VALUES ('Valentina','Rossi','+375295868878', 'valentina@mail.ru'),
('Jorje','Rossi','+375298888889', 'jorje@mail.ru'),
('Lucia','Smith','+375298888890', 'lucia@mail.ru'),
('Sam','Ivanov','+375298888881', 'sam@mail.ru'),
('Bella','Petrov','+375298883889', 'bella@mail.ru'),
('Jack','Pink','+375298888878', 'jack@mail.ru'),
('Marie','Mouth','+375294988889', 'mariee@mail.ru'),
('Ted%','Grizz','+375293888889', 'ted@mail.ru'),
('Ruth','Lazlo','+375298858889', 'ruth@mail.ru'),
('Victor','Herr','+375296888889', 'victor@mail.ru'),
('Thomas','Mann','+375298788889', 'thomas@mail.ru'),
('Ninon', 'De Lanclo', '+330987654460', 'ninon@paris.fr');

-- Table city
CREATE TABLE IF NOT EXISTS city (
    city_id INT NOT NULL PRIMARY KEY auto_increment,
    name VARCHAR(50) NOT NULL,
    postal_code VARCHAR(15) NOT NULL unique,
    region VARCHAR(50) NOT NULL,
    details VARCHAR (255) NULL);

INSERT INTO city (name, postal_code, region) 
VALUES ('Minsk','225000','Minsk region'),
('Brest','225001','Brest region'),
('Gomel','225002','Gomel region'),
('Pinsk','225003','Brest region'),
('Nyasvizh','225004','Minsk region');

-- Table operator
DROP TABLE IF EXISTS operator;

CREATE TABLE IF NOT EXISTS operator (
    operator_id INT NOT NULL PRIMARY KEY auto_increment,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    operator_code VARCHAR(15) NOT NULL unique,
    email varchar(100) NOT NULL UNIQUE,
    phone VARCHAR(20) NOT NULL UNIQUE,
    CHECK(REGEXP_LIKE(phone, '^\\+375(29|33|25|44)[0-9]{7}$')));

INSERT INTO operator (first_name, last_name, operator_code, phone, email) 
VALUES ('Elena','Smith','OP4889','+375296888329', 'elenafb@mail.ru'),
('Misha','Taz','OX7865','+375295193204','mishafb@mail.ru'),
('Kate','Bush','KL1023','+375291284329','katefb@mail.ru'),
('Alex','Mir','MN5679','+375251284586','alexfb@mail.ru'),
('Marie','Curie','BY5432', '+375331210320', 'mariefb@mail.ru');

-- Table category: внешний ключ хранится в таблице со стороны MANY (n) в таблице trip_id
drop table if exists category;

CREATE TABLE IF NOT EXISTS category (
category_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
cat_code varchar(55) NOT NULL,
cat_name varchar(55) NOT NULL);

INSERT INTO category (cat_code, cat_name)
VALUES('rome1', 'Romantic tour'),
('weeki2','Weekend tour'),
('ex3me', 'Extreme tour'),
('ph42', 'Photoshoot tour'),
('killtheoctopus5', 'Culinary tour');

-- Table trip
DROP TABLE IF EXISTS trip;

CREATE TABLE IF NOT EXISTS trip (
	trip_id INT NOT NULL PRIMARY KEY auto_increment,
    description VARCHAR(255) NULL UNIQUE,
    price DECIMAL (5,0) NOT NULL,
    start_date DATE,
    end_date DATE,
    duration INT,
    max_capacity int,
    available_seats int null,
    city_id INT,
    operator_id INT,
    category_id INT,
    CHECK (start_date <= end_date),
    FOREIGN KEY (city_id) REFERENCES city(city_id),
    FOREIGN KEY (operator_id) REFERENCES operator(operator_id),
    FOREIGN KEY (category_id) REFERENCES category(category_id));
    
INSERT INTO trip (description, price, category_id, max_capacity, city_id, operator_id, start_date, end_date) 
VALUES ('Weekend tour',35, 2, 20, 1, 1, '2025-09-08', '2025-09-10' ),
('Romantic tour',28, 1, 20, 2, 1, '2025-09-28', '2025-09-30'),
('Extreme tour',90, 3, NULL, 3, 2, '2025-07-04', '2025-07-12'),
('Photoshoot tour',200, 4, 10, 4, 4, '2025-01-29', '2025-01-31'),
('Culinary tour',350, 5, 7, 5, 5, '2025-10-08', '2025-10-13');

-- Table inquiry (junction table)
DROP TABLE IF EXISTS inquiry;

CREATE TABLE IF NOT EXISTS inquiry (
    inquiry_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    inq_status ENUM ('pending', 'booked', 'cancelled'),
    created_at DATETIME,
    modified_at DATETIME,
    trip_id INT,
    client_id INT,
	FOREIGN KEY (trip_id) REFERENCES trip (trip_id),
    FOREIGN KEY (client_id) REFERENCES client (client_id),
    UNIQUE (trip_id, client_id));
    
INSERT INTO inquiry (inq_status, created_at, modified_at, trip_id, client_id) 
VALUES ('pending', '2025-09-07 14:28:33', NOW(), 1, 7),
('booked', '2025-09-25', NOW(), 1, 10),
('cancelled', '2025-07-01', NOW(), 3, 6),
('pending', '2025-01-23', NOW(), 4, 5),
('pending', '2025-01-23', '2025-02-26 10:56:01', 4, 4),
('booked','2025-09-30', '2025-10-31 08:04:20', 3, 9);

-- Table car
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

-- Table driver
DROP TABLE IF EXISTS driver;

CREATE TABLE IF NOT EXISTS driver (
   driver_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
   first_name VARCHAR(50) NOT NULL,
   last_name VARCHAR(50) NOT NULL,
   car_id INT,
   rate_hour DECIMAL (5,0) NOT NULL,
   FOREIGN KEY(car_id) REFERENCES car(car_id));
   
  INSERT INTO driver (first_name, last_name, car_id, rate_hour)
  VALUES ('Vlad', 'Komarov', 3, 123),
  ('Misha', 'Ivanov', 4, 55),
  ('Givi', 'Gruzin', 2, 63),
  ('Kolya', 'Fedorov', 1, 85),
  ('Serge', 'Stilavin', 5, 45);
  
-- Table trip_driver
 DROP TABLE IF EXISTS trip_driver;
 
CREATE TABLE IF NOT EXISTS trip_driver (
    trip_id INT NOT NULL,
    driver_id INT NOT NULL,
    PRIMARY KEY (trip_id, driver_id),
	FOREIGN KEY (trip_id) REFERENCES trip (trip_id),
    FOREIGN KEY (driver_id) REFERENCES driver (driver_id));
    
    INSERT INTO trip_driver (trip_id, driver_id)
    VALUES (2,3),
    (4,5),
    (1,2),
    (3,4),
    (1,5);
    
-- Table review
DROP TABLE IF EXISTS review;

CREATE TABLE IF NOT EXISTS review (
   review_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
   description TEXT,
   rating INT NOT NULL,
   client_id INT,
   trip_id INT,
   review_date DATE NOT NULL,
   FOREIGN KEY(client_id) REFERENCES client(client_id),
   FOREIGN KEY(trip_id) REFERENCES trip(trip_id),
   UNIQUE(client_id, trip_id),
   check(description <> ' '));

  INSERT INTO review (description, rating, client_id, trip_id, review_date)
  VALUES ('Awesome trip', 5, 9, 3, '2025-07-13'),
  ('The best thing to do during summer!', 5, 12, 2, '2025-10-02'),
  ('The guide was very knowledgeable', 5, 12, 5, '2025-10-26');
    
-- Добавить колонку с датой рождения
ALTER TABLE client
ADD date_of_birth DATE;

-- Добавить данные о рождении
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

-- Table review
DROP TABLE IF EXISTS review;

CREATE TABLE IF NOT EXISTS review (
   review_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
   description TEXT,
   rating INT NOT NULL,
   client_id INT,
   trip_id INT,
   review_date DATE NOT NULL,
   FOREIGN KEY(client_id) REFERENCES client(client_id),
   FOREIGN KEY(trip_id) REFERENCES trip(trip_id),
   UNIQUE(client_id, trip_id),
   check(description <> ' '));

  INSERT INTO review (description, rating, client_id, trip_id, review_date)
  VALUES ('Awesome trip', 5, 9, 3, '2025-07-13'),
  ('The best thing to do during summer!', 5, 12, 2, '2025-10-02'),
  ('The guide was very knowledgeable', 5, 12, 5, '2025-10-26');

-- Сделать выборку с SELECT и LIKE&NOT LIKE
SELECT 
    *
FROM
    client
WHERE
    last_name LIKE 'P%'
        AND first_name NOT LIKE 'J%';

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

-- Cделать выборку со сравнением времени
 SELECT 
    inquiry_id,
    created_at,
    modified_at,
    DATEDIFF(modified_at, created_at) AS 'прошло'
FROM
    inquiry;

-- Сделать выборку с GROUP BY, CASE, WHERE
SELECT 
    *
FROM
    trip
WHERE
    CASE
        WHEN category_id = 2 THEN 1
        ELSE 0
    END = 1;

#INNER JOIN в where
SELECT 
    *
FROM
    operator o,
    trip t
WHERE
    o.operator_id = t.operator_id;

#LEFT JOIN
SELECT first_name, last_name, i.inq_status, i.trip_id, ci.name, t.description, date_of_birth, max_capacity
FROM client c
LEFT JOIN inquiry i ON c.client_id = i.client_id
LEFT JOIN trip t ON t.trip_id = i.trip_id
LEFT JOIN city ci ON t.city_id = ci.city_id
ORDER BY 4, 1;

-- Сделать выборку на 2ух таблицах с JOIN вместе с WHERE, HAVING, GROUP BY
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

-- Выставить новую цену с 15% скидкой, округлить до целого используя round;
SELECT trip_id, substring_index(description, ' ', 1) t_name, price, price*0.15 as discount, 
ROUND((price - price*0.15), 0) AS new_price FROM trip;

-- функция if;
SELECT * ,
IF (max_capacity >= 10, 'премия', 'штраф') бонус
FROM trip;
 
 -- подзапрос в SELECT c exists с корелляцией по id;
 SELECT first_name FROM client c
 WHERE EXISTS (select * FROM inquiry i 
 WHERE i.client_id = c.client_id
 AND inq_status = 'pending');

-- отключить safe mode;
SET SQL_SAFE_UPDATES = 0;

-- подзапрос с UPDATE по обновлению мест, чтобы столбец available_seats отражал количество свободных мест;
UPDATE trip as t
 JOIN		   (
				select trip_id, 
					count(trip_id) as booked_count from inquiry i
				WHERE inq_status = 'booked'
				GROUP BY 1
                ) 
				AS a 
                    ON a.trip_id = t.trip_id
SET t.available_seats = if(t.max_capacity is not null, t.max_capacity - a.booked_count, +1);

-- Включить safe mode;
SET SQL_SAFE_UPDATES = 1;

-- Table logs
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
  
-- Создать транзакцию;
  START TRANSACTION;
  
  UPDATE trip
  SET price = price*2
  WHERE description = 'weekend tour';

  INSERT INTO logs (log_type, table_name, record_id, message)
  VALUES('info', 'trip', 5, 'updated price for weekend_tour');
  COMMIT;
 
  -- Откатить;
  START TRANSACTION;
  UPDATE trip
  SET price = price*2
  WHERE description = 'weekend tour';
  ROLLBACK;
  
  -- Создание вьюшки с подзапросом, где вывести инфо по машине и водителю с именем Vlad;
  CREATE OR REPLACE VIEW v_driver AS
  SELECT c.car_code, 
        CONCAT(car_make, ': ', model_year) as car_info,
        (SELECT concat(first_name, ' ', last_name, ': ', rate_hour) AS d_info
			FROM driver d
			WHERE d.car_id = c.car_id) 
			AS d_info
			FROM car c
            JOIN driver d on d.car_id = c.car_id 
            WHERE d.first_name = 'Vlad';
 
 -- Удалить вью;
  DROP VIEW V_DRIVER;

-- Создать триггер на дискаунт при брони 3 поездок after insert;
DROP TRIGGER IF EXISTS DISCOUNT;

DELIMITER $$

CREATE 
TRIGGER discount 
AFTER INSERT ON inquiry FOR EACH ROW
BEGIN
	DECLARE count_inquiry INT;
        
SELECT count(*) INTO count_inquiry 
FROM inquiry
WHERE client_id = NEW.client_id;
        
	IF count_inquiry>=3 then 
	UPDATE CLIENT 
    SET note = '1 trip for free' WHERE client_id = NEW.client_id;
	ELSE 
    UPDATE CLIENT 
    SET note = 'full price' WHERE client_id = NEW.client_id;
		 END IF; 
         END$$
DELIMITER ;
 
-- Создать триггер на отмену брони after_update;
 DROP TRIGGER IF EXISTS CANCELLATION;

DELIMITER $$

CREATE 
TRIGGER cancellation
AFTER UPDATE ON inquiry FOR EACH ROW
BEGIN
	IF NEW.inq_status='cancelled' AND OLD.inq_status <> 'cancelled' THEN 
	UPDATE client 
    SET note = 'charge cancellation fees' WHERE client_id = NEW.client_id;
	ELSE 
    UPDATE client 
    SET note = NULL WHERE client_id = NEW.client_id;
		 END IF; 
         END$$
DELIMITER ;

-- Создать триггер на проверку даты публикации отзыва перед поездкой before_insert;
 DROP TRIGGER IF EXISTS REVIEW_DATE;

DELIMITER $$

CREATE 
TRIGGER review_date
BEFORE INSERT ON review FOR EACH ROW
BEGIN
	DECLARE trip_end DATE;
    SELECT trip.end_date into trip_end
    FROM trip 
    WHERE trip_id =NEW.trip_id;
    
    IF NEW.review_date < trip_end THEN
	SIGNAL SQLSTATE '45000' 
    SET MESSAGE_TEXT = 'Cannot add the review before the trip ends';
		 END IF; 
         END$$
DELIMITER ;
    
-- Создать триггер before delete;
DROP TRIGGER IF EXISTS block_review_drop;

DELIMITER $$

CREATE TRIGGER block_review_drop
BEFORE DELETE ON review
FOR EACH ROW
BEGIN
	IF OLD.review_date < NOW() - INTERVAL 5 day 
    THEN SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'You cannot delete the comment after 5 days';
    END IF;
    END $$
    DELIMITER ;
