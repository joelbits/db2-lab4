-- Author: Joel Åkerblom joak.dev@gmail.com

USE lab4;

-- Lab 4 - 1 - Foreign keys
-- Skriv queries (ALTER TABLE) för koppla ihop tabellerna med foreign_keys, ta med lämpliga val för vad som ska hända vid updates och deletes på PK:
-- departments-mangager till employees-id,
-- project-supervisor till employees-id
-- projectmembers-e_id till employees-id
-- projectmembers-p_id till projects-id


-- Lab 4 - 2 - Projects
-- Skriv queries så att projects ändras (ALTER TABLE) så att varje project alltid har en supervisor, så att två projektnamn inte kan vara samma, och så att det alltid måste finnas ett projektnamn.
ALTER TABLE projects MODIFY supervisor NOT NULL;
ALTER TABLE projects ADD UNIQUE(name);
ALTER TABLE projects MODIFY name NOT NULL;
-- TODO: Not tested!