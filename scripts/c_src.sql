-- Author: Joel Åkerblom joak.dev@gmail.com

USE lab4;

-- Lab 4 - 2 - Projects
-- Skriv queries så att projects ändras (ALTER TABLE) så att varje project alltid har en supervisor, så att två projektnamn inte kan vara samma, och så att det alltid måste finnas ett projektnamn.
ALTER TABLE projects MODIFY supervisor INT NOT NULL; -- WORKS!
ALTER TABLE projects ADD UNIQUE(name); -- existing duplicate entries
ALTER TABLE projects MODIFY name VARCHAR(50) NOT NULL; -- WORKS!