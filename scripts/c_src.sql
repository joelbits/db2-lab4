
/* Lab 4 - 8 - Skapa tabell: total_salary
Skapa en tabell för summan av löner, lägg in nuvarande värde 
(gör SELECT SUM(salary)...) och lägg till triggers på anställdas löner
så att summan av löner alltid stämmer i nya tabellen. Tabellen ska 
också ha ett fält för last_update som visar när den senast uppdaterades. 
Testa och visa med några UPDATE och INSERT att det fungerar. */

DROP TABLE IF EXISTS total_salary;

CREATE TABLE total_salary (
    total_sum INT,
    last_update DATETIME
);

INSERT INTO total_salary (total_sum, last_update)
VALUES ((SELECT SUM(salary) FROM employees), NOW());

SELECT * FROM total_salary;

-- TODO: The triggers required!