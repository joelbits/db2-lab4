
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

-- 4 - 8 - Procedure helping the triggers below
DROP PROCEDURE IF EXISTS update_total_salaries;
DELIMITER //
CREATE PROCEDURE update_total_salaries()
BEGIN
    UPDATE total_salary SET 
    total_sum = (SELECT SUM(salary) FROM employees),
    last_update = NOW();
END //
DELIMITER ;

-- 4 - 8 - The triggers
DROP TRIGGER IF EXISTS salary_insert;
DELIMITER //
CREATE TRIGGER salary_insert
AFTER INSERT ON employees FOR EACH ROW
BEGIN
    CALL update_total_salaries();
END //
DELIMITER ;

DROP TRIGGER IF EXISTS salary_update;
DELIMITER //
CREATE TRIGGER salary_update
AFTER UPDATE ON employees FOR EACH ROW
BEGIN
    CALL update_total_salaries();
END //
DELIMITER ;

DROP TRIGGER IF EXISTS salary_delete;
DELIMITER //
CREATE TRIGGER salary_delete
AFTER DELETE ON employees FOR EACH ROW
BEGIN
    CALL update_total_salaries();
END //
DELIMITER ;

-- 4 - 8 - Usage:
