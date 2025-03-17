USE auxiliary;

-- Generowane inserty pór roku dla lat 2020-2023
DECLARE @year INT = 2020;

WHILE @year <= 2023
BEGIN
    INSERT INTO season VALUES(CONCAT(@year, '-01-01'), CONCAT(@year, '-03-20'), 'zima');
    INSERT INTO season VALUES(CONCAT(@year, '-03-21'), CONCAT(@year, '-06-21'), 'wiosna');
    INSERT INTO season VALUES(CONCAT(@year, '-06-22'), CONCAT(@year, '-09-22'), 'lato');
    INSERT INTO season VALUES(CONCAT(@year, '-09-23'), CONCAT(@year, '-12-21'), 'jesien');
    INSERT INTO season VALUES(CONCAT(@year, '-12-22'), CONCAT(@year, '-12-31'), 'zima');

    SET @year = @year + 1;
END
