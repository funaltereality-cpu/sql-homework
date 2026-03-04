-- =========================
-- 1. Создание базы данных
-- =========================
DROP DATABASE IF EXISTS ChristmasDB;
CREATE DATABASE ChristmasDB CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ChristmasDB;

-- =========================
-- 2. Создание таблиц
-- =========================
-- Таблица людей
drop table if exists people;

CREATE TABLE people (
  person_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  city VARCHAR(100),
  age INT
);

-- Таблица подарков 
CREATE TABLE gifts (
  gift_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  category VARCHAR(50),
  price DECIMAL(8,2),
  stock INT
);

-- Таблица заказов
CREATE TABLE orders (
  order_id INT AUTO_INCREMENT PRIMARY KEY,
  person_id INT NOT NULL,
  gift_id INT NOT NULL,
  quantity INT NOT NULL,
  order_date DATE,
  shipped BOOLEAN DEFAULT FALSE,
  -- опциональная колонка для упаковки подарка
  gift_wrapped BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (person_id) REFERENCES people(person_id),
  FOREIGN KEY (gift_id) REFERENCES gifts(gift_id)
);

-- Таблица украшений
CREATE TABLE decorations (
  deco_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100),
  color VARCHAR(50),
  material VARCHAR(50),
  price DECIMAL(6,2)
);

-- Таблица песен
CREATE TABLE songs (
  song_id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(150),
  artist VARCHAR(100),
  mood VARCHAR(50),
  length_seconds INT
);

-- Таблица фильмов
CREATE TABLE movies (
  movie_id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(200),
  year INT,
  genre VARCHAR(50),
  rating DECIMAL(3,1)
);

-- Таблица событий
CREATE TABLE events (
  event_id INT AUTO_INCREMENT PRIMARY KEY,
  person_id INT,
  event_date DATE,
  description TEXT,
  FOREIGN KEY (person_id) REFERENCES people(person_id)
);


-- НАЧАЛЬНЫЕ ИНСЕРТЫ
-- ========== PEOPLE ==========
INSERT INTO people (name, city, age) VALUES
('Anna Elf', 'North Pole', 120),
('Ivan Ivanov', 'Minsk', 29),
('Maria Petrova', 'Minsk', 34),
('Sergey Sneg', 'Gomel', 41),
('Olga Snow', 'Brest', 27),
('Santa Claus', 'North Pole', 1000);

-- ========== GIFTS ==========
INSERT INTO gifts (name, category, price, stock) VALUES
('Wooden Reindeer Toy', 'Toys', 19.99, 25),
('Plush Snowman', 'Toys', 14.50, 40),
('Christmas Puzzle 500pc', 'Games', 24.00, 15),
('Red Scarf', 'Clothing', 12.00, 60),
('Luxury Watch', 'Electronics', 199.99, 5),
('Wooden Star Ornament', 'Decor', 6.50, 120),
('LED Fairy Lights', 'Decor', 9.99, 80),
('Gourmet Chocolate Box', 'Food', 29.99, 30),
('Magic Snow Globe', 'Decor', 11.00, 50),
('Board Game: Winter Quest', 'Games', 34.99, 20),
('Cozy Wool Socks', 'Clothing', 8.99, 100),
('Smart Speaker Mini', 'Electronics', 49.99, 12);

-- ========== DECORATIONS ==========
INSERT INTO decorations (name, color, material, price) VALUES
('Wooden Star', 'gold', 'wood', 7.50),
('Glass Bauble Red', 'red', 'glass', 3.20),
('Handmade Wreath', 'green', 'twigs', 15.00),
('Snowflake Hanging', 'white', 'paper', 2.50),
('Felt Santa Hat', 'red', 'felt', 4.00),
('Wooden Tree Topper', 'silver', 'wood', 8.00);

-- ========== SONGS ==========
INSERT INTO songs (title, artist, mood, length_seconds) VALUES
('Silent Night', 'Traditional', 'calm', 180),
('Jingle Bells', 'Traditional', 'cheerful', 150),
('Winter Wonderland', 'Various', 'relaxing', 210),
('Let It Snow', 'Various', 'upbeat', 195),
('Carol of the Bells', 'Various', 'dramatic', 160);

-- ========== MOVIES ==========
INSERT INTO movies (title, year, genre, rating) VALUES
('Home Alone', 1990, 'Comedy', 7.6),
('Love Actually', 2003, 'Romance', 7.6),
('The Holiday', 2006, 'Romance', 6.9),
('How the Grinch Stole Christmas', 2000, 'Family', 6.1),
('Frosty the Snowman', 1969, 'Animation', 7.3);

-- ========== ORDERS (декабрьские и тестовые) ==========
INSERT INTO orders (person_id, gift_id, quantity, order_date, shipped, gift_wrapped) VALUES
(2, 1, 2, '2025-12-05', TRUE, TRUE),
(3, 2, 1, '2025-12-10', FALSE, FALSE),
(4, 3, 1, '2025-12-20', FALSE, TRUE),
(2, 4, 3, '2025-11-28', TRUE, FALSE),
(5, 7, 2, '2025-12-24', FALSE, TRUE),
(1, 6, 5, '2025-12-01', TRUE, FALSE),
(6, 8, 1, '2025-12-23', TRUE, TRUE),
(3, 5, 1, '2024-12-15', TRUE, FALSE),
(2, 9, 1, '2025-12-02', TRUE, FALSE),
(3, 10, 2, '2025-12-02', FALSE, TRUE),
(4, 11, 4, '2025-12-15', TRUE, FALSE),
(5, 12, 1, '2025-12-18', FALSE, FALSE),
(1, 1, 1, '2025-12-24', TRUE, TRUE);

-- ========== EVENTS (есть старые события >2 лет) ==========
INSERT INTO events (person_id, event_date, description) VALUES
(2, '2025-12-24', 'Family dinner and gift exchange'),
(3, '2025-12-31', 'New Year party with friends'),
(4, '2022-11-20', 'Old event to be deleted (archive)'),
(5, '2021-06-15', 'Very old event for cleanup'),
(1, '2025-12-06', 'Elf workshop shift');


-- Task 1: добавить 5 записей в people и 8 в gifts с рождественскими именами. 

start transaction;

INSERT INTO people (name, city, age) VALUES
('Alabaster Snowball', 'North Pole', 20),
('Bushy Evergreen', 'North Pole', 17),
('Pepper Minstix', 'North Pole', 19),
('Shiny Apatree', 'North Pole', 18),
('Wunorse Openslae', 'North Pole', 21)
;

INSERT INTO gifts (name, category, price, stock) VALUES
('Glitzy shoes', 'Clothing', 459.00, 13),
('Iphone 17', 'Electronics', 1000.00, 10),
('Neck massager', 'Electronics', 65.00, 18),
('Flavourful Leaf Tea', 'Food', 12.00, 67),
('Soft Christmas blanket', 'Decor', 58.00, 12),
('Set of tangerine candles', 'Decor', 45.00, 110),
('Extra warm parka', 'Clothing', 700.00, 5),
('Laneige lip mask set', 'Cosmetics', 110.00, 3)
;


commit;

-- rollback; -- rollback можно сделать только пока транзакция открыта; А что значить сделать откат, если ошибка? Типа autocommit какой-то?

-- Task 2: вывести подарки категории 'Toys' по цене по возрастанию. Вызов: фильтр stock > 0 и цена между 10 и 100. 
# тут только два начальных подарка в toys, поэтому сделала фильтры, но можно без них, т.к. выведет ту же инф;
select * from gifts
where category = 'toys'
and stock > 0 
and price between 10 and 100
order by price
;

-- Task 3: показать имя покупателя, название подарка и количество для всех заказов. Вызов: ограничить выборку заказами декабря.
# тут все даты за декабрь, поэтому не совсем понятно, зачем выводить;
select p.name, g.name, quantity from orders o
inner join people p on p.person_id = o.person_id
inner join gifts g on g.gift_id = o.gift_id
where order_date between '2025-12-01' and '2025-12-31'
;

-- Task 4: посчитать общую сумму, потраченную каждым человеком. Вызов: вывести топ-3 тратящих больше всего.
select p.name, sum(o.quantity*g.price) as 'total' from orders o
inner join people p on p.person_id = o.person_id
inner join gifts g on g.gift_id = o.gift_id
group by p.name
order by 2 desc
limit 3
;

-- Task 5: найти 5 самых заказываемых подарков по сумме quantity. Вызов: показать процент от общего числа заказанных единиц.
select sum(quantity) as 'итого подарков', g.name, 
round((sum(quantity) / (select sum(quantity) from orders) * 100),0) as percent
from orders o
inner join gifts g on g.gift_id = o.gift_id
group by o.gift_id
order by sum(quantity) desc
limit 5
;

-- Task 6: выбрать заказы между 1 и 31 декабря. Вызов: сгруппировать по дню и показать количество заказов.
select order_date, sum(quantity) total_orders 
from orders
where order_date between '2025-12-01' and '2025-12-31'
group by order_date
order by 1
;
-- Task 7 (LEVEL: HARD): при выполнении заказа уменьшить `stock`. Вызов: проверка `stock >= quantity` и откат при нехватке;
-- создание триггера before insert 
DROP TRIGGER IF EXISTS gifts_check_stock;

DELIMITER $$

CREATE TRIGGER gifts_check_stock
BEFORE INSERT ON orders
FOR EACH ROW
BEGIN
    DECLARE current_stock INT; -- описываем настоящий сток

    SELECT stock  -- получаем текущий запас подарков
    INTO current_stock
    FROM gifts
    WHERE gift_id = NEW.gift_id;

    IF current_stock IS NULL THEN -- проверяем, существует ли такой подарок
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Gift not found';
    END IF;

    IF NEW.quantity > current_stock THEN -- проверяем, достаточно ли товара на складе
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Not enough stock';
    END IF;
END$$

DELIMITER ;

-- создание триггера after insert

-- здесь также НУЖЕН! триггер на автоматическое считывание количества стока после заказа, так как, если новый заказ будет с меньшим
-- количеством чем в стоке, то будет двойной заказ и сток будет отрицательным, а мы даже не будем знать об этом

drop trigger if exists gifts_stock_after_insert;

DELIMITER $$

create trigger gifts_stock_after_insert
after insert on orders
for each row
begin
        update gifts -- обновляем количество товара
        set stock = gifts.stock - NEW.quantity -- он знает, что я беру из другой таблицы?
        where gift_id = new.gift_id;
END$$

DELIMITER ;

select * from gifts
where gift_id = 5;
select * from orders
where gift_id = 5;

INSERT INTO orders (person_id, gift_id, quantity, order_date, shipped, gift_wrapped) VALUES
(3, 5, 1, '2024-12-16', TRUE, FALSE);

update gifts 				 # проверка как сработал insert и триггер и обновление информации о заказах. Можно делать вручную, 
join (select orders.gift_id, # но лучше поставить триггер, который будет обновлять информацию автоматически
		sum(orders.quantity) as total 
        from orders 
        group by orders.gift_id) as o
on gifts.gift_id = o.gift_id
set gifts.stock = gifts.stock - o.total;

-- Task 8: Удалить `events` старше 2 лет;

select event_date
from events
where YEAR(event_date) + 2 <= 2025;

delete
from events
where year(event_date) + 2 <=2025;

-- Task 9: LIKE, полнотекст. найти `decorations`, где `material` содержит 'wood' или `name` содержит 'star'.  
# Cоздать полнотекстовый индекс и выполнить MATCH...AGAINST

select * 								#здесь обычный query через like
from decorations
where material like 'wood' 
or name like 'star';

alter table decorations					#здесь добавляем полнотекстовый индекс в таблицу, чтобы искать слова
add fulltext index idx(material, name);

show index from decorations;			#здесь можем увидеть созданный индекс

select * from decorations				#здесь поиск по индексу и ВАЖНО! два слова в поиске пишем без запятой
where match(material, name) 			#выведёт строки, имеющие по крайней мере 1 из этих слов
against('wood star');

-- Task 10: AVG, MIN, MAX, GROUP BY. Задача: вывести среднюю, минимальную и максимальную цену по категориям подарков. 
# Вызов: добавить HAVING для категорий с >3 товарами.

select category
, min(price)
, max(price)
, avg(price) from gifts
group by category
having count(*) >3;						#здесь лучше count(*) т.к. считает все строки в группе и не зависит от null
										# count(category) считала бы только строки, где category is not null
-- Task 11: CASE. 
# Классифицировать товары как дешёвые (<20), средние, дорогие (>100) и посчитать количество. Вывести процент от полного числа

select 
round((sum(stock) / (select sum(stock) from gifts)* 100),0) as 'percent',
count(*) as 'total by price',					#здесь также count(*) для подсчёта всех строк в группе
case 
when price < 20 then 'дешёвые' 
when price > 100 then 'дорогие'
else 'средние'
	end as 'price range'
from gifts
group by case 							#group by с полной пропиской функции case, тк иначе не сработает
when price < 20 then 'дешёвые' 
when price > 100 then 'дорогие'
else 'средние'
	end 
order by 'price range'
;
-- Task 12: найти людей, купивших подарок дороже средней цены всех подарков
-- ps. Формулировка вызова непонятна: переписать через JOIN подзапрос поиска среднего. 
select p.name 												
, g.name
from people p
join orders o on p.person_id = o.person_id
join gifts g on g.gift_id = o.gift_id
where price > (select avg(price) from gifts)
;

-- Task 13: Навык: Множественные JOIN. Задача: вывести людей, их заказы и связанные украшения/песни. 
#(ps. но у нас нет связанных украшений и песен...?)
USE ChristmasDB;
select * from orders;
select * from people;

select p.name, o.gift_id from people p
left join orders o on p.person_id = o.person_id;

-- Task 14: Навык: ALTER TABLE.  
#Задача: добавить `gift_wrapped BOOLEAN DEFAULT FALSE` в `orders`.  
#Вызов: пометить TRUE для заказов праздничной недели.

ALTER TABLE orders ADD gift_wrapped1 BOOLEAN DEFAULT FALSE  AFTER gift_wrapped; 

update orders													#если я правильно поняла условие, то вот через set можно
set gift_wrapped1 = 1
where order_date between '2025-12-23' and '2025-12-31'
;

-- Task 15: Навык: JOIN, агрегаты.  
#Задача: найти 5 самых длинных песен и показать их настроение.  
#Вызов: вычислить среднюю длину по настроению. 

select title
, mood
, length_seconds as length
from songs
order by 3 desc
;
select round(avg (length_seconds)/60, 0) 
as 'avg length/min'
from songs;

-- Task 16: Навык: Оконные функции.  
#Задача: ранжировать подарки по сумме потраченной суммы для каждого человека. Ранжируем по каждому человеку.

select dense_rank() over 
(partition by o.person_id
						order by sum(g.price*o.quantity) desc
                        ) "rank"
, o.person_id
, g.gift_id
, g.name
from gifts g
inner join orders o on o.gift_id = g.gift_id
group by 2,3,4
order by "rank", o.person_id
;

#ниже не является решением задачи, но стоит учесть для проставки значения для каждой строчки
select null as "rank"
, g.name
, g.price
, o.person_id
from gifts g
inner join orders o on o.gift_id = g.gift_id
;

select distinct dense_rank() over w as "rank"
, g.name
, g.price
, o.person_id
from gifts g
inner join orders o on o.gift_id = g.gift_id
window w as (order by price desc)				#создание оконной функции, она ничего не делает, но зато в селекте проставляется ранжирование
;

-- Task 17: симулировать одновременные покупки одного подарка двумя пользователями;
-- Решение: создаю две разные вкладки и проверяю, что разные соединения с помощью SELECT CONNECTION_ID(); 
-- Когда вижу, что соединения разные, то в 1 вкладке начинаю транзакцию:
start transaction; 
 
-- и начинаю менять сток в таблице gifts;
update gifts
set stock = stock - 1
where gift_id = 5;

-- параллельно во второй также начинаю транзакцию
start transaction;

-- и меняю сток также:
update gifts
set stock = stock - 1
where gift_id = 5;

-- но не могу закончить операцию по изменению, DB грузит, так как первая операция в первой вкладке осталась без commit
-- когда в первой вкладке делаю
commit;
-- то автоматически во второй вкладке выполняется операция

-- также нужно во второй вкладке сделать commit, так чтобы в первой вкладке отобразилась инфо после операции во второй вкладке

-- Task 18: Навык: Подзапросы, логика рекомендаций.   
#Задача: предложить каждому человеку подарок из категории, которую он чаще всего заказывает.
#Здесь я сломала голову с этими подзапросами

select o.person_id
, g.category
, o.quantity
,concat('Dear ', p.name, ', we recommend ', (g.name)) as recommendation
from orders o
inner join gifts g on g.gift_id = o.gift_id
left join people p on p.person_id = o.person_id
	where o.quantity > 1
	and	o.quantity = (
						select
						max(quantity) from 
						orders o2
						where o2.person_id = o.person_id
)
order by 1 asc;

-- Task 19: CREATE VIEW.  
# Задача: создать представление`v_top_spenders` с людьми, потратившими >100.
# Not updatable

create view v_top_spenders as
select p.name
,sum(g.price*o.quantity) as total_sum
from orders o
inner join gifts g on g.gift_id = o.gift_id
left join people p on p.person_id = o.person_id
group by p.name
having total_sum > 100
;

select * from v_top_spenders;

update v_top_spenders set name = "Masha Petrova" where name = "Maria Petrova";

-- Task 20: создать `orders_december_backup` с копией заказов за декабрь

CREATE TABLE orders_december_backup as
SELECT * from orders
where order_date between "2025-12-01" and "2025-12-31";

#or

CREATE TABLE orders_december_backup as
SELECT * from orders
where order_date >= "2025-12-01" 
and order_date <="2025-12-31";

select * from orders_december_backup;

#удаляю запись для будущей проверки back-up
delete from orders
where order_id = 1;

#вставляю запись из бэкапа обратно;
insert into orders
select * from orders_december_backup
where order_id = 1;

-- Task 21: Добавление JSON колонки, затем JSON_EXTRACT.  
#Задача: добавить `attributes` в `gifts` и выбрать подарки с цветом 'red'

#удаляет колонку
alter table gifts drop attributes;

alter table gifts add attributes json;

update gifts 
set attributes = case gift_id
	when 1 then '{"colour": "red"}'
	when 2 then '{"colour": "yellow"}'
	when 3 then '{"colour": "violet"}'
	when 4 then '{"colour": "red"}'
    when 5 then '{"colour": "black"}'
	when 6 then '{"colour": "grey"}'
	when 7 then '{"colour": "blue"}'
	when 8 then '{"colour": "red"}'
	when 9 then '{"colour": "hot pink"}'
	when 10 then '{"colour": "red"}'
	when 11 then '{"colour": "blue"}'
	when 12 then '{"colour": "white"}'
	when 13 then '{"colour": "purple"}'
	when 14 then '{"colour": "yellow"}'
	when 15 then '{"colour": "pink"}'
    when 16 then '{"colour": "red"}'
    when 17 then '{"colour": "black"}'
    when 18 then '{"colour": "red"}'
    when 19 then '{"colour": "grey"}'
    when 20 then '{"colour": "pink"}'
end 
where gift_id between 1 and 20;

#json_extract – оставляем название колонки, и знак $ в начале для обозначения начала path,значение берём в ОДНИ кавычки

select * from gifts
where json_extract(attributes, '$.colour') = 'red';

-- Task 22: CREATE INDEX, EXPLAIN.  
#Задача: добавить индекс на `orders(order_date)` и сравнить `EXPLAIN`.

#сначала сравниваем до, чтобы затем если что-то изменится после добавления индекса, увидеть разницу

explain 
select * from orders
where order_date = '2025-12-05';

alter table orders add index od (order_date);

#если нужно удалить, то используем
drop index od on orders;

explain select * from orders
where order_date = '2025-12-05';
