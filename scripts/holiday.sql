USE auxiliary;

-- Generowane inserty dla lat 2020-2023
DECLARE @year INT = 2020;

WHILE @year <= 2023
BEGIN
    -- Sta³e œwiêta
    INSERT INTO holidays ("date", "holiday", "bank_holiday") VALUES(CONCAT(@year, '-01-01'), 'Nowy Rok', 1);
    INSERT INTO holidays ("date", "holiday", "bank_holiday") VALUES(CONCAT(@year, '-01-06'), 'Trzech Króli', 1);
    INSERT INTO holidays ("date", "holiday", "bank_holiday") VALUES(CONCAT(@year, '-05-01'), 'Œwiêto Pracy', 1);
    INSERT INTO holidays ("date", "holiday", "bank_holiday") VALUES(CONCAT(@year, '-05-03'), 'Œwiêto Konstytucji 3 Maja', 1);
    INSERT INTO holidays ("date", "holiday", "bank_holiday") VALUES(CONCAT(@year, '-08-15'), 'Wniebowziêcie Najœwiêtszej Maryi Panny', 1);
    INSERT INTO holidays ("date", "holiday", "bank_holiday") VALUES(CONCAT(@year, '-11-01'), 'Dzieñ Wszystkich Œwiêtych', 1);
    INSERT INTO holidays ("date", "holiday", "bank_holiday") VALUES(CONCAT(@year, '-11-11'), 'Dzieñ Niepodleg³oœci', 1);
    INSERT INTO holidays ("date", "holiday", "bank_holiday") VALUES(CONCAT(@year, '-12-25'), 'Bo¿e Narodzenie', 1);
    INSERT INTO holidays ("date", "holiday", "bank_holiday") VALUES(CONCAT(@year, '-12-26'), 'Drugi dzieñ Bo¿ego Narodzenia', 1);
    INSERT INTO holidays ("date", "holiday", "bank_holiday") VALUES(CONCAT(@year, '-02-02'), 'Dzieñ Zaduszny', 0);
    INSERT INTO holidays ("date", "holiday", "bank_holiday") VALUES(CONCAT(@year, '-01-21'), 'Dzieñ Babci', 0);
    INSERT INTO holidays ("date", "holiday", "bank_holiday") VALUES(CONCAT(@year, '-01-22'), 'Dzieñ Dziadka', 0);
    INSERT INTO holidays ("date", "holiday", "bank_holiday") VALUES(CONCAT(@year, '-02-14'), 'Walentynki', 0);
    INSERT INTO holidays ("date", "holiday", "bank_holiday") VALUES(CONCAT(@year, '-03-08'), 'Dzieñ Kobiet', 0);
    INSERT INTO holidays ("date", "holiday", "bank_holiday") VALUES(CONCAT(@year, '-05-26'), 'Dzieñ Matki', 0);
    INSERT INTO holidays ("date", "holiday", "bank_holiday") VALUES(CONCAT(@year, '-06-23'), 'Dzieñ Ojca', 0);
    INSERT INTO holidays ("date", "holiday", "bank_holiday") VALUES(CONCAT(@year, '-06-01'), 'Dzieñ Dziecka', 0);
    INSERT INTO holidays ("date", "holiday", "bank_holiday") VALUES(CONCAT(@year, '-12-06'), 'Miko³ajki', 0);
	INSERT INTO holidays ("date", "holiday", "bank_holiday") VALUES(CONCAT(@year, '-12-31'), 'Sylwester', 0);

    SET @year = @year + 1;
END


-- Daty dla Wielkanocy w latach 2020-2023:
-- 2020: Wielkanoc - 2020-04-12
-- 2021: Wielkanoc - 2021-04-04
-- 2022: Wielkanoc - 2022-04-17
-- 2023: Wielkanoc - 2023-04-09

-- Wielka Sobota
INSERT INTO holidays ("date", "holiday", "bank_holiday") VALUES('2020-04-11', 'Wielka Sobota', 1);
INSERT INTO holidays ("date", "holiday", "bank_holiday") VALUES('2021-04-03', 'Wielka Sobota', 1);
INSERT INTO holidays ("date", "holiday", "bank_holiday") VALUES('2022-04-16', 'Wielka Sobota', 1);
INSERT INTO holidays ("date", "holiday", "bank_holiday") VALUES('2023-04-08', 'Wielka Sobota', 1);

-- Wielkanoc
INSERT INTO holidays ("date", "holiday", "bank_holiday") VALUES('2020-04-12', 'Wielkanoc', 1);
INSERT INTO holidays ("date", "holiday", "bank_holiday") VALUES('2021-04-04', 'Wielkanoc', 1);
INSERT INTO holidays ("date", "holiday", "bank_holiday") VALUES('2022-04-17', 'Wielkanoc', 1);
INSERT INTO holidays ("date", "holiday", "bank_holiday") VALUES('2023-04-09', 'Wielkanoc', 1);

-- Wielki Pi¹tek i Poniedzia³ek Wielkanocny
INSERT INTO holidays ("date", "holiday", "bank_holiday") VALUES('2020-04-10', 'Wielki Pi¹tek', 0);
INSERT INTO holidays ("date", "holiday", "bank_holiday") VALUES('2020-04-13', 'Poniedzia³ek Wielkanocny', 1);
INSERT INTO holidays ("date", "holiday", "bank_holiday") VALUES('2021-04-02', 'Wielki Pi¹tek', 0);
INSERT INTO holidays ("date", "holiday", "bank_holiday") VALUES('2021-04-05', 'Poniedzia³ek Wielkanocny', 1);
INSERT INTO holidays ("date", "holiday", "bank_holiday") VALUES('2022-04-15', 'Wielki Pi¹tek', 0);
INSERT INTO holidays ("date", "holiday", "bank_holiday") VALUES('2022-04-18', 'Poniedzia³ek Wielkanocny', 1);
INSERT INTO holidays ("date", "holiday", "bank_holiday") VALUES('2023-04-07', 'Wielki Pi¹tek', 0);
INSERT INTO holidays ("date", "holiday", "bank_holiday") VALUES('2023-04-10', 'Poniedzia³ek Wielkanocny', 1);

-- Bo¿e Cia³o (60 dni po Wielkanocy)
INSERT INTO holidays ("date", "holiday", "bank_holiday") VALUES('2020-06-11', 'Bo¿e Cia³o', 1);
INSERT INTO holidays ("date", "holiday", "bank_holiday") VALUES('2021-06-03', 'Bo¿e Cia³o', 1);
INSERT INTO holidays ("date", "holiday", "bank_holiday") VALUES('2022-06-16', 'Bo¿e Cia³o', 1);
INSERT INTO holidays ("date", "holiday", "bank_holiday") VALUES('2023-06-08', 'Bo¿e Cia³o', 1);