-- Author: Joel Åkerblom joak.dev@gmail.com

USE lab4;

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

-- USAGE:
SHOW CREATE TABLE departments;
SHOW CREATE TABLE projects;
SHOW CREATE TABLE project_members;


-- Lab 4 - 4 - Employees
-- Vi (eller kund) vet att det kommer göras många sökningar och sorteringar på efternamn. Lägg därför in INDEX där. Användarnamn måste också spärras så inte två kan få samma.
ALTER TABLE employees ADD INDEX (last_name);
ALTER TABLE employees ADD UNIQUE(login);

-- Usage:
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

-- Usage:
SHOW CREATE TABLE projects;
SHOW CREATE TABLE departments;
SHOW CREATE TABLE employees;
