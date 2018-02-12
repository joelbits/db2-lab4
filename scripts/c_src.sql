-- Author: Joel Åkerblom joak.dev@gmail.com

USE lab4;

-- Lab 4 - 5 - Skapa vy: salary_data_dept
-- Skapa en vy som ger avdelningsnamn, minsta lön, hösta lön, medellön och antal anställda för varje avdelning.
-- ALTER TABLE departments ADD name VARCHAR(30) UNIQUE; -- FROM Lab 4 - 3

DROP VIEW IF EXISTS salary_data_dept;
CREATE VIEW salary_data_dept AS
SELECT d.name AS department_name,
    MIN(e.salary) AS min_salary,
    MAX(e.salary) AS max_salary,
    AVG(e.salary) AS avg_salary,
    (SELECT COUNT(*) FROM employees) AS dep_employees
FROM departments d, employees e;

-- SELECT * FROM salary_data_dept
-- GROUP BY department_name;