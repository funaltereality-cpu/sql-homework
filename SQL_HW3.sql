DROP DATABASE IF EXISTS products;
CREATE DATABASE IF NOT EXISTS products;

USE products;

-- -----------------------------------------------------
-- Table users
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS user (
  user_id INT NOT NULL PRIMARY KEY auto_increment,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  phone VARCHAR(20) NOT NULL UNIQUE,
  email varchar(100) NOT NULL UNIQUE,
  note VARCHAR(255) DEFAULT NULL,
  status ENUM('new', 'current') DEFAULT 'new'
  );
  -- изменение таблицы
ALTER TABLE user
ADD address VARCHAR(255) NULL;


INSERT INTO user (first_name, last_name, phone, email) 
VALUES ('Valentina','Rossi','375298888888', 'valentina@mail.ru'),
('Jorje','Rossi','375298888889', 'jorje@mail.ru'),
('Lucia','Smith','375298888890', 'lucia@mail.ru'),
('Sam','Ivanov','375298888881', 'sam@mail.ru'),
('Bella','Petrov','375298883889', 'bella@mail.ru'),
('Jack','Pink','375298888878', 'jack@mail.ru'),
('Marie','Mouth','375294988889', 'mariee@mail.ru'),
('Ted','Grizz','375293888889', 'ted@mail.ru'),
('Ruth','Lazlo','375298858889', 'ruth@mail.ru'),
('Victor','Herr','375296888889', 'victor@mail.ru'),
('Thomas','Mann','375298788889', 'thomas@mail.ru');

SELECT * FROM USER;
-- -----------------------------------------------------
-- Table city
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS city (
    city_id INT NOT NULL PRIMARY KEY auto_increment,
    name VARCHAR(50) NOT NULL,
    postal_code VARCHAR(15) NOT NULL unique,
    region VARCHAR(50) NOT NULL,
    description VARCHAR (255) NULL    
);

INSERT INTO city (name, postal_code, region) 
VALUES ('Minsk','225000','Minsk region'),
('Brest','225001','Brest region'),
('Gomel','225002','Gomel region'),
('Pinsk','225003','Brest region'),
('Nyasvizh','225004','Minsk region');

SELECT * FROM city;

-- -----------------------------------------------------
-- Table userCity (junction table)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS userCity (
    city_id INT NOT NULL,
    user_id INT NOT NULL,
    trips INT,
    PRIMARY KEY (user_id, city_id),
    
      -- связи с другими таблицами
  CONSTRAINT fk_userCity_user
    FOREIGN KEY (user_id) REFERENCES user(user_id)
    ON DELETE CASCADE,

  CONSTRAINT fk_userCity_city
    FOREIGN KEY (city_id) REFERENCES city(city_id)
    ON DELETE CASCADE
);

-- добавить ещё 1 колонку с датой рождения
ALTER TABLE user
ADD date_of_birth DATE;

-- 1. сделать запрос на всю выборку
SELECT 
    *
FROM
    user;

-- добавить данные о рождении
UPDATE USER 
SET 
    date_of_birth = CASE user_id
        WHEN 1 THEN '1996-12-12'
        WHEN 2 THEN '1995-06-06'
        WHEN 3 THEN '1999-09-07'
        WHEN 4 THEN '1993-01-03'
        WHEN 5 THEN '1998-03-04'
        WHEN 6 THEN '1991-11-28'
        WHEN 7 THEN '2001-11-09'
        WHEN 8 THEN '1998-03-02'
        WHEN 9 THEN '1998-03-02'
        WHEN 10 THEN '1994-04-25'
        WHEN 11 THEN '1993-12-25'
    END
WHERE
    user_id BETWEEN 1 AND 11;
;
-- 2. сделать выборку по имени с WHERE
SELECT 
    first_name, last_name
FROM
    user
WHERE
    last_name = 'Rossi';

-- 3. сделать выборку по макс дате рождения с GROUP, ORDER BY, LIMIT
SELECT 
    first_name, last_name, MAX(date_of_birth) dob
FROM
    user
GROUP BY 1 , 2
ORDER BY dob
LIMIT 3;

-- 4. сделать выборку с HAVING, ORDER
SELECT 
    first_name,
    last_name,
    date_of_birth,
    ROUND(DATEDIFF(CURDATE(), date_of_birth) / 365,
            0) AS age
FROM
    user
HAVING age >= 30
ORDER BY age DESC;

-- 5. сделать выборку по поиску инициалов пользователей с WHERE, ORDER BY
SELECT 
    first_name, last_name
FROM
    user
WHERE
    last_name LIKE 'R%'
        OR last_name LIKE 'P%'
        OR last_name LIKE 'M%'
ORDER BY last_name DESC;

-- 6. сделать выборку с COUNT
SELECT 
    COUNT(user_id)
FROM
    user;
-- 7. сделать выборку из другой таблицы
SELECT 
    *
FROM
    city;

-- 8. сделать выборку с WHERE
SELECT 
    name, region
FROM
    city
WHERE
    region = 'Minsk region';
    
    -- 9. сделать выборку по поиску инициалов пользователей с WHERE [or, or, and], ORDER BY
SELECT 
    first_name, last_name, date_of_birth
FROM
    user
WHERE
    (last_name LIKE 'R%'
        OR last_name LIKE 'P%'
        OR last_name LIKE 'M%')
        AND date_of_birth = '1996-12-12'
ORDER BY last_name DESC;

-- 10. сделать выборку с order by
SELECT 
    name
FROM
    city
    ORDER BY 1 DESC;
    
    -- 11. сделать выборку с максимальным почтовым индексом
SELECT 
    name, max(postal_code)
FROM
    city
GROUP BY name
ORDER BY max(postal_code) DESC;
