-- Author: Joel Åkerblom

use lab4;

-- Lab 4 - 1 Foreign keys
-- Skriv queries (ALTER TABLE) för koppla ihop tabellerna med foreign_keys, ta med lämpliga val för vad som ska hända vid updates och deletes på PK:
-- departments-mangager till employees-id, (1)
-- project-supervisor till employees-id (2)
-- projectmembers-e_id till employees-id (3)
-- projectmembers-p_id till projects-id (4)

-- (1) Add FKs to departments table: departments-mangager till employees-id
ALTER TABLE departments
ADD CONSTRAINT FK_Dep_Manager_Employee_Id FOREIGN KEY (manager)
    REFERENCES employees(id)
    ON DELETE RESTRICT ON UPDATE CASCADE;

-- (2) project-supervisor till employees-id
ALTER TABLE projects
ADD CONSTRAINT FK_Proj_Supervisor_Employee_Id FOREIGN KEY (supervisor)
    REFERENCES employees(id)
    ON DELETE RESTRICT ON UPDATE CASCADE;

-- (3) Add FKs to project_members-e_id -> employees-id
ALTER TABLE project_members
ADD CONSTRAINT FK_Proj_Members_eid_Employee_Id FOREIGN KEY (e_id)
    REFERENCES employees(id)
    ON DELETE CASCADE ON UPDATE CASCADE;

-- (4) Add FK projectmembers-p_id -> projects-id
ALTER TABLE project_members
ADD CONSTRAINT FK_Proj_Members_pid_Project_Id FOREIGN KEY (p_id)
    REFERENCES projects(id)
    ON DELETE CASCADE ON UPDATE CASCADE;

-- 4 - 1 - USAGE:
SHOW CREATE TABLE departments;
SHOW CREATE TABLE projects;
SHOW CREATE TABLE project_members;


-- Lab 4 - 2 - Projects
-- Skriv queries så att projects ändras (ALTER TABLE) så att varje project alltid har en supervisor (1), så att två projektnamn inte kan vara samma (2), och så att det alltid måste finnas ett projektnamn (3).

-- (1) alter table projects supervisor not null
ALTER TABLE projects MODIFY supervisor INT NOT NULL;

-- (2) alter table projecs add constraint unique(name)
-- Since MySQL ~5.7.4 ALTER IGNORE... does not work. Therefore, first removing duplicates = change projects.name of duplicates to something "unique". Not perfect.

 -- Renames existing duplicate names to existing name + some random numbers
UPDATE projects p
    JOIN (SELECT name, MIN(id) min_id FROM projects GROUP BY name HAVING COUNT(*) > 1) nn
        ON p.name = nn.name AND p.id <> nn.min_id
SET p.name = CONCAT(p.name, ' ABS(CHECKSUM(NewId())) % 10000');

-- Now since no duplicates should exist for projects.name we can apply UNIQUE(name)
ALTER TABLE projects ADD CONSTRAINT UNIQUE(name);

-- (3) alter table projects name not null
ALTER TABLE projects MODIFY name VARCHAR(50) NOT NULL;

-- 4 - 2 - Usage:
SHOW CREATE TABLE projects;


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

-- 4 - 3 - Usage:
SHOW CREATE TABLE employees;
SHOW CREATE TABLE departments;

-- Lab 4 - 4 - Employees
-- Vi (eller kund) vet att det kommer göras många sökningar och sorteringar på efternamn. Lägg därför in INDEX där. Användarnamn måste också spärras så inte två kan få samma.
ALTER TABLE employees ADD INDEX (last_name);
ALTER TABLE employees ADD UNIQUE(login);

-- 4 - 4 - Usage:
SHOW CREATE TABLE employees;


-- Lab 4 - 5 - Optimera datatyper
-- Skriv en query som ändrar (ALTER TABLE)  ett par av datatyperna till något som är effektivare. 

-- 4 - 5 - a) projects - name behöver inte vara VARCHAR(50). Ändra till något som är mer lagom.
ALTER table projects MODIFY name VARCHAR(25);
-- PROCEDURE ANALYSE() says avg 9 and max 16 with current data. Changed from VARCHAR(50).

-- 4 - 5 - b) departments - id kommer aldrig vara större heltal än 50. Byt till mer lagom datatyp än INT.
ALTER table departments MODIFY id TINYINT;
-- PROCEDURE ANALYSE() says max 12 with current data. Changed from int to tinyint.

-- 4 - 5 - c) employees - title - kan bara vara något av "dr", "mr", "ms", "mrs", "rev" eller "honorable". Byt datatyp till ENUM.
ALTER table employees MODIFY title ENUM('dr', 'mr', 'ms', 'mrs', 'rev', 'honorable');
-- Changed from VARCHAR(50)

-- 4 - 5 - Usage:
SHOW CREATE TABLE projects;
SHOW CREATE TABLE departments;
SHOW CREATE TABLE employees;


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


/* Lab 4 - 7 - Skapa vyn: retirement_countdown
    Skapa en vy som listar anställda 
    med titel, förnamn, efternamn och avdelning 
    de jobbar på samt hur många år det är kvar tills de fyller 65. 
    Sortera på avdelning, år kvar. 
    Visa bara de som har 10 eller mindre år kvar till pension. */


CREATE OR REPLACE VIEW retirement_countdown AS
SELECT *
FROM
(
    SELECT
    	e.id as 'e_id',
    	e.title AS 'title', 
    	e.first_name AS 'fname', 
    	e.last_name AS 'lname',
    	e.department AS 'dep_id',
        (SELECT department FROM departments WHERE id = e.department) AS 'dep_name',
        (SELECT (65 - TIMESTAMPDIFF(YEAR, e.birth_date, NOW()))) AS 'time_to_ret'
    FROM employees e
    INNER JOIN departments d ON e.department = d.id
    GROUP BY e.department, e.id,  e.first_name, e.title, e.last_name
    ORDER BY dep_id, time_to_ret
) AS T;


-- 4 - 7 - Usage: 
SELECT * FROM `retirement_countdown`;


/* Lab 4 - 8 - Skapa tabell: total_salary
Skapa en tabell för summan av löner, lägg in nuvarande värde 
(gör SELECT SUM(salary)...) och lägg till triggers på anställdas löner
så att summan av löner alltid stämmer i nya tabellen. Tabellen ska 
också ha ett fält för last_update som visar när den senast uppdaterades. 
Testa och visa med några UPDATE och INSERT att det fungerar. */
DROP TABLE IF EXISTS total_salary;

CREATE TABLE total_salary (
    total_sum INT,
    last_update DATETIME
);

-- Update the table once initially
INSERT INTO total_salary (total_sum, last_update)
VALUES ((SELECT SUM(salary) FROM employees), NOW());

-- 4 - 8 - Procedure helping the triggers below
DROP PROCEDURE IF EXISTS update_total_salaries;
DELIMITER //
CREATE PROCEDURE update_total_salaries()
BEGIN
    UPDATE total_salary SET 
    total_sum = (SELECT SUM(salary) FROM employees),
    last_update = NOW();
END //
DELIMITER ;

-- 4 - 8 - The triggers
DROP TRIGGER IF EXISTS salary_insert;
DELIMITER //
CREATE TRIGGER salary_insert
AFTER INSERT ON employees FOR EACH ROW
BEGIN
    CALL update_total_salaries();
END //
DELIMITER ;

DROP TRIGGER IF EXISTS salary_update;
DELIMITER //
CREATE TRIGGER salary_update
AFTER UPDATE ON employees FOR EACH ROW
BEGIN
    CALL update_total_salaries();
END //
DELIMITER ;

DROP TRIGGER IF EXISTS salary_delete;
DELIMITER //
CREATE TRIGGER salary_delete
AFTER DELETE ON employees FOR EACH ROW
BEGIN
    CALL update_total_salaries();
END //
DELIMITER ;

-- 4 - 8 - Usage:
/* 

SELECT * FROM `total_salary`;
total_sum   last_update
39366201	2018-02-15 11:14:45	

UPDATE employees SET salary = 2000000 WHERE id = 1;

SELECT * FROM `total_salary`;
total_sum   last_update
41325693 	2018-02-15 11:15:53

*/


/* Lab 4 - 9 - Flytta hr_notes
 a) Skriv queries för att skapa en tabell och flytta allt 
innehåll i hr_notes till den nya tabellen samt koppla den nya tabellen 
till employees-id med foreign keys. Ta bort kolumnen för hr_notes från employees. */
DROP TABLE IF EXISTS hr;
CREATE TABLE hr (
    id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    content TEXT,
    CONSTRAINT FK_Employee_Id FOREIGN KEY (id) REFERENCES employees(id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

INSERT INTO hr (content)
SELECT hr_notes FROM employees;

ALTER TABLE employees DROP COLUMN hr_notes;

-- 4 - 9 - a) Usage: SELECT * FROM hr;

-- Lab 4 - 9 - b) Skriv query som visar efternamn, förnamn, hr_notes för alla anställda.
SELECT e.last_name, e.first_name,
	(SELECT content FROM hr WHERE id = e.id) as hr_notes
FROM employees e;


/* Lab 4 - 10-12 (VG-taks) NOT done
(VG) Lab 4 - 10 - Inga lönsminskningar
Skriv kod för trigger som gör att löner begränsas så att det inte går att sänka lönen
 ör en anställd och inte går att höja med mer än 5%.
 
(VG) Lab 4 - 10 - Flytta telefonnummer
Skriv queries för att skapa en ny tabell och flytta telefonnummer från employees till 
den nya tabellen. Nya tabellen ska ha en ENUM för type som är "Work", "Home", "Mobile" 
samt telefonnummer. Skapa sedan en vy, phone_list, med förnamn, efternamn, hemtelefon, 
jobbtelefon, mobiltelefon. Gör en select som visar telefonlistan sorterad på efternamn 
och sedan förnamn.
 
(VG) Lab 4 - 10 - Analys
Analysera db-server, tabellstruktur och queries och gör 3 optimeringar av DB, tabeller, 
queries, index. Beskriv vilka, visa queries för att implementera och queries som visar 
på förbättring. Motivera gärna med exempel på mätvärden före och efter. Det ska vara 
saker som du kan modifera via MySQL. Optimeringar vad gäller bandbredd, hårdvara för 
server, byte av SQL-dialekt, osv är intressanta men inte det som ska redovisas för 
denna uppgift. */
