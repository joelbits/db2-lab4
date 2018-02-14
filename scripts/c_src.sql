
-- Lab 4 - 6 - Skapa vy: salary_data_dept
-- Skapa en vy som ger avdelningsnamn, minsta lön, hösta lön, 
-- medellön och antal anställda för varje avdelning.

CREATE OR REPLACE VIEW salary_data_dept 
AS
SELECT d.department AS dep_name,
    (SELECT MIN(salary) FROM employees WHERE department = d.id) as min_emp_sal,
    (SELECT MAX(salary) FROM employees WHERE department = d.id) as max_emp_sal,
    (SELECT AVG(salary) FROM employees WHERE department = d.id) as avg_emp_sal,
    (SELECT COUNT(*) FROM employees WHERE department = d.id) as no_employees
FROM departments d, employees e
GROUP BY d.id;

-- 4 - 6 - Usage:
SELECT * FROM salary_data_dept;