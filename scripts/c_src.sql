-- Author: Joel Åkerblom joak.dev@gmail.com

USE lab4;

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