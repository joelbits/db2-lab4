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


-- Lab 4 - 2 - Projects
-- Skriv queries så att projects ändras (ALTER TABLE) så att varje project alltid har en supervisor, så att två projektnamn inte kan vara samma, och så att det alltid måste finnas ett projektnamn.
ALTER TABLE projects MODIFY supervisor INT NOT NULL; -- Works!

-- Since MySQL ~5.7.4 ALTER IGNORE... does not work anymore. Therefore, first removing duplicates = change projects.name of duplicates to something unique
SELECT name, id, COUNT(*) c -- remove ID and works better......
FROM projects 
GROUP BY name 
HAVING c > 1
ORDER BY id ASC;
 -- Returns "name", "c" with project.name, 2 (count)
UPDATE projects SET name = CONCAT(name, id) WHERE 

ALTER TABLE projects ADD CONSTRAINT UNIQUE(name);

ALTER TABLE projects MODIFY name VARCHAR(50) NOT NULL; -- Works!
