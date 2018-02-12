-- Author: Joel Åkerblom joak.dev@gmail.com

USE lab4;

-- Lab 4 - 7 - Skapa vyn: retirement_countdown
-- Skapa en vy som listar anställda med titel, förnamn, efternamn och avdelning de jobbar på samt hur många år det är kvar tills de fyller 65. Sortera på avdelning, år kvar. Visa bara de som har 10 eller mindre år kvar till pension.

ALTER TABLE departments ADD name VARCHAR(30) UNIQUE; -- From Lab 4 - 3

DROP VIEW IF EXISTS retirement_countdown;

CREATE VIEW retirement_countdown AS
SELECT e.title AS e_title,
    e.first_name AS fname,
    e.last_name AS lname,
    (SELECT department FROM departments WHERE id = e.department) AS dep_name,
    (SELECT COUNT(*) FROM employees) AS dep_employees
FROM employees e;

-- SELECT * FROM salary_data_dept
-- GROUP BY department_name;
