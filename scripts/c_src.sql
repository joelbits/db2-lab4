-- Author: Joel Åkerblom joak.dev@gmail.com

USE lab4;

-- Lab 4 - 1 Foreign keys
-- Skriv queries (ALTER TABLE) för koppla ihop tabellerna med foreign_keys, ta med lämpliga val för vad som ska hända vid updates och deletes på PK:
-- departments-mangager till employees-id,
-- project-supervisor till employees-id
-- projectmembers-e_id till employees-id
-- projectmembers-p_id till projects-id

-- Add FKs to departments table
-- TODO: Make work: ALTER TABLE departments DROP CONSTRAINT FK_Employee_Id IF (@existing > 0);
--TODO: Double check ON DELETE / UPDATE ALL OF THEM !!!
ALTER TABLE departments
ADD CONSTRAINT FK_Employee_Id FOREIGN KEY (manager)
    REFERENCES employees(id)
    ON DELETE CASCADE ON UPDATE CASCADE;

-- Add FKs to projects table
ALTER TABLE projects
ADD CONSTRAINT FK_Employee_Id FOREIGN KEY (supervisor)
    REFERENCES employees(id)
    ON DELETE CASCADE ON UPDATE CASCADE;

-- Add FKs to project_members table
ALTER TABLE project_members
ADD CONSTRAINT FK_Employee_Id FOREIGN KEY (e_id)
    REFERENCES employees(id)
    ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT FK_Project_Id FOREIGN KEY (p_id)
    REFERENCES projects(id)
    ON DELETE CASCADE ON UPDATE CASCADE;
