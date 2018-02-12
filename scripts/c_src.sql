-- Author: Joel Åkerblom joak.dev@gmail.com

USE lab4;

-- Lab 4 - 5 - Skapa vy: salary_data_dept
-- Skapa en vy som ger avdelningsnamn, minsta lön, hösta lön, medellön och antal anställda för varje avdelning.
-- ALTER TABLE departments ADD name VARCHAR(30) UNIQUE; -- FROM Lab 4 - 3

DROP VIEW IF EXISTS salary_data_dept;
CREATE VIEW salary_data_dept AS
SELECT ANY_VALUE(d.department) AS dep_name,
    MIN(e.salary) AS min_salary,
    MAX(e.salary) AS max_salary,
    AVG(e.salary) AS avg_salary,
    (SELECT COUNT(*) from employees WHERE (employees.department = e.id)) AS dep_emps
from (departments d
    LEFT JOIN employees e
    ON ((d.id = e.department))
)
group by dep_emps;

SELECT * FROM salary_data_dept;