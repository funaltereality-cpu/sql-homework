DROP DATABASE IF EXISTS final_exam_Kudelko;
CREATE DATABASE IF NOT EXISTS final_exam_Kudelko;

USE final_exam_Kudelko;

-- -----------------------------------------------------
-- Table jobs
-- -----------------------------------------------------
drop table if exists jobs;

CREATE TABLE IF NOT EXISTS jobs (
  id VARCHAR(10)NOT NULL PRIMARY KEY,
  job_title VARCHAR(45) NOT NULL,
  min_salary DECIMAL(6) NOT NULL,
  max_salary DECIMAL(6) NOT NULL
  );

INSERT INTO jobs (id, job_title, min_salary, max_salary) 
VALUES ('AD_PRES', 'President', 20080, 40000),
('FI_ACCOUNT', 'Accountant', 4200, 9000),
('HR_REP','Human Resources Representative', 4000, 9000),
('IT_PROG', 'Programmer', 4000,	10000),
('MK_MAN', 'Marketing Manager', 9000, 15000);

SELECT * FROM jobs;
-- -----------------------------------------------------
-- Table departments
-- -----------------------------------------------------
drop table if exists departments;

CREATE TABLE IF NOT EXISTS departments (
  id INT NOT NULL PRIMARY KEY,
  department_name VARCHAR(45) NOT NULL,
  manager_id INT
  );
  
INSERT INTO departments (id, department_name, manager_id) 
VALUES (60,	'IT', 103),
(70, 'Public Relations', 204),
(80, 'Sales', 145),
(90, 'Executive', 100),
(100, 'Finance', 108 ),
(110, 'Accounting', 205);

SELECT * FROM departments;
-- -----------------------------------------------------
-- Table employees
-- -----------------------------------------------------
drop table if exists employees;

CREATE TABLE IF NOT EXISTS employees (
  id INT NOT NULL PRIMARY KEY,
  first_name VARCHAR(20) NOT NULL,
  last_name VARCHAR(25) NOT NULL,
  job_id VARCHAR(10) NOT NULL,
  salary DECIMAL(8,2) NOT NULL, 
  hire_date DATE,
  department_id INT,
  manager_id INT,
  FOREIGN KEY (department_id) REFERENCES departments(id),
  FOREIGN KEY (job_id) REFERENCES jobs(id),
  FOREIGN KEY (manager_id) REFERENCES employees(id)
  );
  
INSERT INTO employees (id, first_name, last_name, hire_date, job_id, salary, department_id, manager_id) 
VALUES (100, 'Steven',	'King', '2013-06-17', 'AD_PRES', 24000, 90,	null),
(101, 'Neena', 'Yang', '2015-09-21', 'AD_PRES',	17000,	90,	100),
(102, 'Lex', 'Garcia', '2011-01-13', 'AD_PRES', 17000,	90,	100),
(103, 'Alexander', 'James', '2016-01-03', 'IT_PROG', 9000, 60, 102),
(104, 'Bruce', 'Miller', '2017-05-21',	'IT_PROG', 6000, 60, 103),
(105, 'David', 'Williams', '2016-06-25', 'IT_PROG', 4800, 60, 103),
(106, 'Valli','Jackson',  '2016-02-05', 'IT_PROG', 4800, 60, 103),
(107, 'Diana', 'Nguyen', '2017-02-07',	'IT_PROG', 4200, 60, 103),
(108, 'Nancy', 'Gruenberg',	'2012-08-17','FI_ACCOUNT',12008, 100,null),
(109,'Daniel', 'Faviet','2012-08-16', 'FI_ACCOUNT', 9000, 100, 108),
(110,'John', 'Chen', '2015-09-28', 'FI_ACCOUNT', 8200,100,108),
(111,'Ismael', 'Sciarra', '2015-09-30', 'FI_ACCOUNT', 7700, 100,108),
(112,'Jose Manuel', 'Urman', '2016-03-07',	'FI_ACCOUNT', 7800, 100, 108),
(113, 'Luis', 'Popp', '2017-12-07','FI_ACCOUNT',6900,100,	108),
(145, 'John', 'Singh', '2014-10-01','MK_MAN', 14000,80,100),
(200, 'Jennifer', 'Whalen', '2013-09-17', 'AD_PRES', 4400, 110, 101),
(201,'Michael', 'Martinez', '2014-02-17', 'MK_MAN', 13000, 110,100),
(202, 'Pat', 'Davis', '2015-08-17', 'MK_MAN', 6000,110, 201),
(203,'Susan', 'Jacobs', '2012-06-07', 'HR_REP',	6500, 110, 101),
(204,'Hermann', 'Brown', '2012-06-07', 'HR_REP', 10000, 80, 101),
(205,'Shelley','Higgins', '2012-06-07', 'AD_PRES', 	12008,	110,101),
(206,'William', 'Gietz', '2012-06-07', 'AD_PRES', 8300, 110, 205)
;

select * from employees;


ALTER TABLE departments
ADD FOREIGN KEY (manager_id) REFERENCES employees(id);

SELECT * FROM departments;
SELECT * FROM jobs;

-- 1.	Таблица Employees. Получить список всех сотрудников из 60го отдела (department_id) с зарплатой(salary), большей 4000
select id, first_name, last_name, salary from employees
where department_id = 60
having salary > 4000; -- не стоит здесь использовать having, т.к. логически он не нужен, нет агрегатной функции 

select id, first_name, last_name, salary from employees
where department_id = 60
and salary > 4000; -- where здесь предпочтительнее, т.к. быстрее, нет сложной логики и группировки. WHERE работает до группировки

-- 2. Таблица Employees. Получить список всех сотрудников, у которых в имени содержатся минимум 2 буквы 'n' 
select * from employees
where first_name like '%n%n%'; -- ищет имена с минимум 2мя буквами n

-- or 
	SELECT 
    first_name, 
	last_name
    FROM
    employees
where (length(first_name) - length(replace(lower(first_name), 'n',''))) >= 2
  order by 1 desc;

-- 3. Таблица Employees. Получить список всех ID менеджеров;

select distinct manager_id from employees -- мы ищем те manager_id на которые ccылаются другие строки, т.е. кто руководит людьми, 
where manager_id is not NULL; -- если NUll – это CEO; 

select distinct em.manager_id as 'submit to', em.id as 'id', em.first_name, em.last_name -- найти всё из предыдущего запроса 
from employees e -- и вывести имена и фамилии менеджеров и кому они подчиняются
join employees em 
on em.id = e.manager_id;

-- 4.	Таблица Employees. Получить список работников с их позициями в формате: Donald(sh_clerk)

select
CONCAT(first_name, '(', replace(lower(job_id), ' ','_'), ')') as name_post
from employees e
left join jobs j on j.id = e.job_id;

-- (length(first_name) - length(replace(lower(first_name), 'n',''))) >= 2 

-- 5. Таблица Departments. Получить первое слово из имени департамента для тех у кого в названии больше одного слова

select substring_index(department_name, ' ', 1) as first_word
, LENGTH(department_name) - LENGTH(REPLACE(department_name, ' ', '')) + 1 AS word_count
from departments
having word_count >=2 ;

-- 6. Таблица Employees. Получить список всех сотрудников, которые работают в компании больше 10 лет

select id, hire_date,                    -- не самый лучший вариант с NOW для этого запроса
round(datediff(NOW(), hire_date)/365,1)
from employees
having round(datediff(NOW(), hire_date)/365,0)  > 10;

-- NOW() подходит, когда нужны секунды и точность момента
-- CURDATE() подходит, когда считаем в годах, днях для
														-- стажа
                                                        -- возраста
                                                        -- сколько лет договору
                                                        -- сколько лет прошло с регистрации

-- лучше с timestampdiff(year, hire_date, curdate()), т.к. он выводит полные годы без округлений:

select id, hire_date
,timestampdiff(YEAR, hire_date, CURDATE()) as work_exp
from employees
where timestampdiff(YEAR, hire_date, CURDATE()) >= 10;

-- 7. Таблица Employees. Получить список всех сотрудников, которые пришли на работу в августе 2012го года. 
select * 
from employees
where MONTH(hire_date) = 8 and YEAR(hire_date) = 2012;

-- 8. Сколько сотрудников имена которых начинается с одной и той же буквы? 
-- Сортировать по количеству. Показывать только те где количество больше 1;

SELECT name_count, first_name, last_name
FROM (
    SELECT 
        first_name, 
        last_name, 
        LEFT(first_name, 1) as f, 
        COUNT(*) OVER (PARTITION BY LEFT(first_name, 1)) as name_count
    FROM employees
) AS t
WHERE name_count > 1
order by 1 desc;

-- or

SELECT 
    LEFT(first_name, 1) as first_letter,
    COUNT(*) as name_count				-- сначала группируем
FROM employees							-- потом count(*) считает количество строк в группе
GROUP BY LEFT(first_name, 1)
HAVING COUNT(*) > 1;

-- 9.Сколько сотрудников которые работают в одном и тоже отделе и получают одинаковую зарплату? 
select t1.salary, t1.department_id,
t1.first_name as first_name1,
t2.first_name as first_name2,
t1.department_id as department_id
from
employees t1
join employees t2
on t1.department_id = t2.department_id
and t1.id <> t2.id
where t1.salary = t2.salary
;

-- or

select t1.salary, t1.department_id, count(*)
from
employees t1
join employees t2
on t1.department_id = t2.department_id
and t1.id <> t2.id
where t1.salary = t2.salary
group by 1, 2
;

-- PS. но если нужен именно вывод СКОЛЬКО, то через self-join:
select
count(*) as count_u
from
employees t1
join employees t2
on t1.department_id = t2.department_id
and t1.id <> t2.id
where t1.salary = t2.salary
having count(*)> 0;

-- 10. Таблица Employees, Departaments. 
-- Получить список department_id, department_name 
-- и округленную среднюю зарплату работников в каждом департаменте. 

select d.id, department_name, round(avg(salary), 2) as average_s
from departments d
inner join Employees e
on e.department_id = d.id
group by 1, 2;
