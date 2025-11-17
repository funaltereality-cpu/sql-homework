-- DB practical_test_1_Kudelko

DROP DATABASE IF EXISTS practical_test_1_Kudelko;

CREATE DATABASE IF NOT EXISTS practical_test_1_Kudelko;
USE practical_test_1_Kudelko;

 CREATE TABLE IF NOT EXISTS tutors (
  tutor_id INT NOT NULL PRIMARY KEY auto_increment,
  tutor_name VARCHAR(75) NOT NULL UNIQUE,
  department ENUM ('K1', 'K2') NOT NULL
  );
  
  INSERT INTO tutors(tutor_name, department)
  VALUES ('Mirsh', 'K1'),
  ('Gonzalo', 'K1'),
  ('Leer', 'K2'),
  ('Puzov', 'K2'),
  ('Andreenko', 'K1');
  
  SELECT * FROM tutors;

CREATE TABLE IF NOT EXISTS students (
  student_id INT NOT NULL PRIMARY KEY auto_increment,
  student_name VARCHAR(100) NOT NULL UNIQUE,
  student_group ENUM ('G1', 'G2') NOT NULL,
  tutor_id INT,
  FOREIGN KEY (tutor_id) REFERENCES tutors(tutor_id)
  );
  
INSERT INTO students (student_name, student_group, tutor_id)
VALUES ('Smith', 'G1', 1),
('Bon', 'G2', 3),
('Elliah', 'G1', 4),
('Petrov', 'G2', 5),
('Freud', 'G1', NULL);

SELECT * FROM students;

  
  CREATE TABLE IF NOT EXISTS grades (
  grade_id INT NOT NULL PRIMARY KEY auto_increment,
  student_id INT ,
  grade_date DATE,
  grade INT,
  tutor_id INT,
  FOREIGN KEY (tutor_id) REFERENCES tutors(tutor_id),
  FOREIGN KEY (student_id) REFERENCES students(student_id)
  );
  
  INSERT INTO grades(student_id, grade_date, grade, tutor_id)
  VALUES (1, '2025-09-08', 10, 2),
		 (2, '2025-10-01', 7, 2),
		 (3, '2025-10-02', 6, 3),
		 (4, '2025-09-13', 4, 5),
         (5, '2025-11-02', 5, 4),
         (5, '2025-11-12', 8, 4),
         (3, '2025-10-09', 9, 1);
         
SELECT * from grades;

-- запросы

#положительные оценки с 2025-09-01 по 2025-11-15, положительные те, кот-ые больше 4;

select student_id, grade
from grades
where grade > 4;

select student_id, grade, grade_date
from grades
where grade > 4 and grade_date between '2025-09-01' and '2025-11-15';

#положительные оценки с кодами студентов 1 и 2;
select student_id, grade
from grades
where student_id in (1,2);

#все студенты с кроме групп г1 и г2 ? непонятно, так как создана таблица только с группами 1 и 2
select *
from students
where student_group = 'G3';

#оценки от 6 до 8 с 2025-09-01 по 2025-11-15;

select student_id, grade, grade_date
from grades
where grade in (6,7,8) and grade_date between '2025-09-01' and '2025-11-15';

#or

select student_id, grade, grade_date
from grades
where grade between 6 and 8 and grade_date between '2025-09-01' and '2025-11-15';

#получить фам дипломников и руководителей

select * from students;
select * from tutors;

select student_name, tutor_name
from students s, tutors t
where s.tutor_id = t.tutor_id;

#получить ВСЕ фам дипломников и руководителей
select student_name, tutor_name
from students s
left join  tutors t on s.tutor_id = t.tutor_id;

#получить все фам дипломников и рук из группы 2
select student_name, tutor_name, student_group
from students s
left join  tutors t on s.tutor_id = t.tutor_id
where student_group = 'G2';

#получить все фам рук из группы 1 и 2;
select tutor_name, student_group
from students s
inner join  tutors t on s.tutor_id = t.tutor_id
where student_group in('G2','G1');

#получить все пары студентов из 1 и той же группы;
select student_name from students
where student_group = 'G1';

select student_name from students
where student_group = 'G2';

#вывести ср балл по каждому за период c 2025-09-08 - 2025-12-31
select * from grades;

select student_id, ROUND(avg(grade),1) as avg
from grades
where grade_date between '2025-09-08' and '2025-12-31'
group by student_id;

#вывести все фам студентов-дипломников и рук

select student_name, tutor_name
from students s
inner join tutors t on t.tutor_id = s.tutor_id;

#вывести тех, кто не сдавал экз

select * from grades
where grade is NULL;

#вывести сведения об оценках, отсорт по student_id, убыванию оценки

select s.student_id, student_name, grade from students s
inner join grades g using (student_id)
order by 1, 3 desc;

#получить кол-во дипломников

select count(student_id) from students
where tutor_id is not null;

#получить id рук с кол-вом дипломников

select tutor_id, count(student_id)
from students
where tutor_id is not null
group by tutor_id;

# получить средние баллы
select student_id, round(avg(grade),1) 
from grades
group by 1;

# получить средние баллы у группы 2
select * from grades;

select s.student_id, round(avg(grade),1) as avg, student_group
from grades g
JOIN students s on g.student_id = s.student_id
where student_group = 'G2'
group by 1;







