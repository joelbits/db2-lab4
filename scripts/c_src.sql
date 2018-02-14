
-- Lab 4 - 2 - Projects
-- Skriv queries så att projects ändras (ALTER TABLE) så att varje project alltid har en supervisor (1), så att två projektnamn inte kan vara samma (2), och så att det alltid måste finnas ett projektnamn (3).

-- (1)
ALTER TABLE projects MODIFY supervisor INT NOT NULL;

-- (2)
-- Since MySQL ~5.7.4 ALTER IGNORE... does not work anymore. Therefore, first removing duplicates = change projects.name of duplicates to something unique

 -- Renames existing duplicate names to existing name + some random numbers
UPDATE projects p
    JOIN (SELECT name, MIN(id) min_id FROM projects GROUP BY name HAVING COUNT(*) > 1) nn
        ON p.name = nn.name AND p.id <> nn.min_id
SET p.name = CONCAT(p.name, ' ABS(CHECKSUM(NewId())) % 10000');

-- Now since no duplicates should exist for projects.name we can apply UNIQUE(name)
ALTER TABLE projects ADD CONSTRAINT UNIQUE(name);

-- (3)
ALTER TABLE projects MODIFY name VARCHAR(50) NOT NULL;

-- Usage:
SHOW CREATE TABLE projects;
