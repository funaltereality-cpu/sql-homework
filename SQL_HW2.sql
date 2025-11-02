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
