
/* Lab 4 - 3 - Departments
Ändra i DB så att alla anställda alltid är knutna till en avdelning.
Ändra så att default för nya anställda och för anställda utan dept 
ska vara "Training". Det ska inte kunna finnas anställda utan avdelningar. 
Lägg också in att deparments måste ha ett namn och det måste vara unikt 
samt att varje department måste ha en manager. */

ALTER TABLE employees MODIFY department INT DEFAULT 4 NOT NULL;

ALTER TABLE employees ADD CONSTRAINT FK_Emp_dep FOREIGN KEY (department) 
    REFERENCES deparments(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE;

-- No current missing employees.department. This could find missing:
-- SELECT id, first_name, last_name, department FROM `employees`
-- WHERE department NOT REGEXP '^[0-9]+$';

ALTER TABLE departments ADD name VARCHAR(30) UNIQUE;
ALTER TABLE departments MODIFY manager int NOT NULL;

-- 4 - 4 - Usage:
SHOW CREATE TABLE employees;
SHOW CREATE TABLE departments;