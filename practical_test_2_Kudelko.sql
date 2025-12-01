-- practical_test_2_Kudelko
drop database if exists practical_test_2_Kudelko;

create database if not exists practical_test_2_Kudelko;

use practical_test_2_Kudelko;

-- создание таблицы tutors;

drop table if exists tutors;

  CREATE TABLE IF NOT EXISTS tutors (
  tutor_id INT NOT NULL PRIMARY KEY auto_increment,
  name VARCHAR(100) NOT NULL UNIQUE,
  department VARCHAR(100) NOT NULL
  );
  
  INSERT INTO tutors(name, department)
  VALUES ('Mirsh', 'K1'),
  ('Gonzalo', 'K1'),
  ('Leer', 'K2'),
  ('Puzov', 'K2'),
  ('Andreenko', 'K1');
  
  select * from tutors;


-- создание таблицы students;

  drop table if exists students;

  CREATE TABLE IF NOT EXISTS students (
  student_id INT NOT NULL PRIMARY KEY auto_increment,
  name VARCHAR(100) NOT NULL UNIQUE,
  groupe VARCHAR(20) NOT NULL,
  tutor_id INT,
  FOREIGN KEY (tutor_id) references tutors(tutor_id)
  );
  
INSERT INTO students (name, groupe, tutor_id)
VALUES ('Smith', 'G1', 1),
('Bon', 'G2', 3),
('Elliah', 'G1', 4),
('Petrov', 'G2', 5),
('Freud', 'G1', NULL);

SELECT * FROM students;
  -- создание таблицы grades;

 drop table if exists grades;

  CREATE TABLE IF NOT EXISTS grades (
  grade_id INT NOT NULL PRIMARY KEY auto_increment,
  date DATE,
  grade INT,
  student_id INT,
  tutor_id INT,
  FOREIGN KEY (tutor_id) references tutors(tutor_id),
  FOREIGN KEY (student_id) references students(student_id)
  );
  
  INSERT INTO grades(student_id, date, grade, tutor_id)
  VALUES (1, '2025-09-08', 10, 2),
		 (2, '2025-10-01', 7, 2),
		 (3, '2025-10-02', 6, 3),
		 (4, '2025-09-13', 4, 5),
         (5, '2025-11-02', NUll, NUll),
         (5, '2025-11-12', 8, 4),
         (3, '2025-10-09', 9, 1);
         
SELECT * from grades;

-- 1. получить фамилии дипломников с указанием фамилии руководителей;

select s.name as students, t.name as tutors
from students s
left join tutors t on t.tutor_id = s.tutor_id
where s.tutor_id is not null
;

-- 2. получить оценки студентов из G2, с указанием фамилии руководителя и студента

select s.name as students, t.name as tutors, grade from grades g
inner join students s on g.student_id = s.student_id
inner join tutors t on t.tutor_id = g.tutor_id
where groupe = 'G2'
order by grade asc;

-- 3. получить фамилии руководителей дипломов групп 1 и 2

select t.name tutors from tutors t
left join students s on s.tutor_id = t.tutor_id
where groupe in ('G2', 'G1');

-- 4. получить пары фамилий студентов обучающихся в одной и той же группе

select s1.name as student1_name,
	   s2.name as student2_name,
      s1.groupe as groupe_name
from students as s1
join students as s2
on s1.groupe = s2.groupe
and s1.student_id < s2.student_id
where s1.groupe in ('G1', 'G2');

-- 5. получить оценки с указанием фамилий студентов;

select s.name as students, grade from grades g
inner join students s on g.student_id = s.student_id
order by grade asc;

-- 6. получить фамилии всех студентов, для дипломников + фам руководителя;
select s.name as students, t.name as tutors from students s
left join tutors t on t.tutor_id = s.tutor_id;

-- 7. получить фамилии студентов, которые не сдавали дипломные

select s.name from students s
where tutor_id is NULL; 

-- or 

select s.name from students s
left join grades g on g.student_id = s.student_id
where grade is NULL; 

-- 8. получить инфо об оценках, отсортированных по коду студентов по убыванию оценки;

select g.grade from students s
inner join grades g on g.student_id = s.student_id 
where grade is not null
order by s.student_id, 1 desc;

-- 9.получить кол-во дипломников
select * from students;

select count(student_id) from students; -- (если мы считаем студента с нулевым tutor);

select count(student_id) from students
where tutor_id is not null; -- (если мы не считаем студента с нулевым tutor);

-- 10. получить фио студентов и их средний бал

select name, round(avg(g.grade),1) as average from students s
right join grades g on g.student_id = s.student_id 
where grade is not null
group by 1;

-- 11. получить список дипломников у каждого препода 

select s.name students, t.name as tutors
from tutors t
inner join students s on s.tutor_id = t.tutor_id;

-- 12. получить кол-во + оценок каждой кафедры, где дипломники получили больше 1 + оценки (>=4) 
-- и в названии есть буква K;

select department, count(grade) from grades g
join tutors t on t.tutor_id = g.tutor_id
where grade >=4 and department like '%K%'
group by department
order by 2;


