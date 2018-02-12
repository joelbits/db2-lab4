-- Author: Joel Åkerblom joak.dev@gmail.com

USE lab4;

-- Lab 4 - 3 - Departments
-- Ändra i DB så att alla anställda alltid är knutna till en avdelning. Ändra så att default för nya anställda och för anställda utan dept ska vara "Training". Det ska inte kunna finnas anställda utan avdelningar. Lägg också in att deparments måste ha ett namn och det måste vara unikt samt att varje department måste ha en manager.
ALTER TABLE employees MODIFY department INT NOT NULL; -- test

ALTER TABLE employees MODIFY department INT SET DEFAULT 'Training'; -- test
INSERT ('Training') INTO employees (department) WHERE department IS NULL; -- test

ALTER TABLE departments ADD name VARCHAR(30) UNIQUE; -- test
ALTER TABLE departments MODIFY manager int NOT NULL; -- test
