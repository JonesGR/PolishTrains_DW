USE PolaczeniaKolejowe
GO
BULK INSERT dbo.Polaczenie FROM 'C:\Users\Dell\Downloads\ETL_PIERWSZY_FAKT\sources\polaczeniaT1.bulk' WITH (FIELDTERMINATOR=',', CODEPAGE = '65001')
BULK INSERT dbo.Przystanek FROM 'C:\Users\Dell\Downloads\ETL_PIERWSZY_FAKT\sources\przystankiT1.bulk' WITH (FIELDTERMINATOR=',', CODEPAGE = '65001')
BULK INSERT dbo.Kurs FROM 'C:\Users\Dell\Downloads\ETL_PIERWSZY_FAKT\sources\kursyT1.bulk' WITH (FIELDTERMINATOR=',', CODEPAGE = '65001')
BULK INSERT dbo.CzasPrzejazdu FROM 'C:\Users\Dell\Downloads\ETL_PIERWSZY_FAKT\sources\czasy_przejazduT1.bulk' WITH (FIELDTERMINATOR=',', CODEPAGE = '65001')
BULK INSERT dbo.Bilet FROM 'C:\Users\Dell\Downloads\ETL_PIERWSZY_FAKT\sources\biletyT1.bulk' WITH (FIELDTERMINATOR=',', CODEPAGE = '65001')
