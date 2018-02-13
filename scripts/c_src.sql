-- Author: Joel Åkerblom joak.dev@gmail.com

USE lab4;

-- Lab 4 - 4 - Employees
-- Vi (eller kund) vet att det kommer göras många sökningar och sorteringar på efternamn. Lägg därför in INDEX där. Användarnamn måste också spärras så inte två kan få samma.
ALTER TABLE employees ADD INDEX (last_name);
ALTER TABLE employees ADD UNIQUE(login);