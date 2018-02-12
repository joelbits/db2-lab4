-- Author: Joel Åkerblom joak.dev@gmail.com

USE lab4;

-- Lab 4 - 1 Foreign keys
-- Skriv queries (ALTER TABLE) för koppla ihop tabellerna med foreign_keys, ta med lämpliga val för vad som ska hända vid updates och deletes på PK:
-- departments-mangager till employees-id,
-- project-supervisor till employees-id
-- projectmembers-e_id till employees-id
-- projectmembers-p_id till projects-id

-- Lab 4 - 3 - Departments
-- Ändra i DB så att alla anställda alltid är knutna till en avdelning. Ändra så att default för nya anställda och för anställda utan dept ska vara "Training". Det ska inte kunna finnas anställda utan avdelningar. Lägg också in att deparments måste ha ett namn och det måste vara unikt samt att varje department måste ha en manager.
ALTER TABLE employees MODIFY department INT NOT NULL; -- WORKS