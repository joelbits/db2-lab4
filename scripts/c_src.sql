-- Author: Joel Åkerblom joak.dev@gmail.com

USE lab4;

-- Lab 4 - 5 - Optimera datatyper
-- Skriv en query som ändrar (ALTER TABLE)  ett par av datatyperna till något som är effektivare. 

-- 4 - 5 - a) projects - name behöver inte vara VARCHAR(50). Ändra till något som är mer lagom.
ALTER table projects MODIFY name VARCHAR(25); -- PROCEDURE ANALYSE() says avg 9 and max 16 with current data. Changed from VARCHAR(50).

-- 4 - 5 - b) departments - id kommer aldrig vara större heltal än 50. Byt till mer lagom datatyp än INT.
ALTER table departments MODIFY id TINYINT; -- PROCEDURE ANALYSE() says max 12 with current data. Changed from int to tinyint.

-- 4 - 5 - c) employees - title - kan bara vara något av "dr", "mr", "ms", "mrs", "rev" eller "honorable". Byt datatyp till ENUM.
ALTER table employees MODIFY title ENUM('dr', 'mr', 'ms', 'mrs', 'rev', 'honorable'); -- Changed from VARCHAR(50)
