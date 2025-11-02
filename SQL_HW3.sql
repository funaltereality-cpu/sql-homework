USE products;

-- добавить ещё 1 колонку с датой рождения
ALTER TABLE user
ADD date_of_birth DATE;

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
-- сделать выборку по имени с WHERE
SELECT 
    first_name, last_name
FROM
    user
WHERE
    last_name = 'Rossi';

-- сделать выборку по макс дате рождения с GROUP, ORDER BY, LIMIT
SELECT 
    first_name, last_name, MAX(date_of_birth) dob
FROM
    user
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
    user
HAVING age >= 30
ORDER BY age DESC;

-- сделать выборку по поиску инициалов пользователей с WHERE, ORDER BY
SELECT 
    first_name, last_name
FROM
    user
WHERE
    last_name LIKE 'R%'
        OR last_name LIKE 'P%'
        OR last_name LIKE 'M%'
ORDER BY last_name DESC;

-- сделать выборку с COUNT
SELECT 
    COUNT(user_id)
FROM
    user;

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


