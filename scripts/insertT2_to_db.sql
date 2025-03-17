USE PolaczeniaKolejowe
GO

CREATE TABLE #TmpPolaczenie (
    PolaczenieID INT PRIMARY KEY,  -- PK - ID
    NazwaPolaczenia VARCHAR(30)     -- Nazwa po³¹czenia np. Gdañsk -> Warszawa
);

CREATE TABLE #TmpPrzystanek (
    PrzystanekID INT PRIMARY KEY,   -- PK - ID
    PolaczenieID INT,               -- FK - Po³¹czenie (powi¹zanie z tabel¹ Po³¹czenie)
    NazwaPrzystanku VARCHAR(30),    -- Nazwa przystanku
    KolejnoscNaTrasie INT,          -- Kolejnoœæ przystanku na trasie
    FOREIGN KEY (PolaczenieID) REFERENCES Polaczenie(PolaczenieID)
);

CREATE TABLE #TmpKurs (
    KursID INT PRIMARY KEY,         -- PK - ID
    Data DATE,                  -- Dzieñ i godzina odjazdu ze stacji pocz¹tkowej
    PociagID INT,                   -- ID poci¹gu (z danych z pliku)
    PolaczenieID INT,               -- FK - Po³¹czenie (powi¹zanie z tabel¹ Po³¹czenie)
    FOREIGN KEY (PolaczenieID) REFERENCES Polaczenie(PolaczenieID)
);

CREATE TABLE #TmpBilet (
    BiletID INT PRIMARY KEY,        -- PK - ID
    PrzystanekPoczID INT,           -- FK - Przystanek pocz¹tkowy
    PrzystanekKonID INT,            -- FK - Przystanek koñcowy
    TypWagonu VARCHAR(30),          -- Typ wagonu (np. przedzia³owe, bezprzedzia³owe)
	KursID INT,                     -- FK - Kurs
    FOREIGN KEY (KursID) REFERENCES Kurs(KursID),
    FOREIGN KEY (PrzystanekPoczID) REFERENCES Przystanek(PrzystanekID),
    FOREIGN KEY (PrzystanekKonID) REFERENCES Przystanek(PrzystanekID)
);

-- Tabela CzasPrzejazdu
CREATE TABLE #TmpCzasPrzejazdu (
    KursID INT,                     -- FK - Kurs
    Data DATE,                  -- Data (dzieñ kursu)
    PrzystanekID INT,               -- FK - Przystanek
    GodzinaPrzyjazdu TIME,      -- Godzina przyjazdu na przystanek
    GodzinaOdjazdu TIME,        -- Godzina odjazdu z przystanku
    PRIMARY KEY (KursID, PrzystanekID),  -- PK - Klucz z³o¿ony
    FOREIGN KEY (KursID) REFERENCES Kurs(KursID),
    FOREIGN KEY (PrzystanekID) REFERENCES Przystanek(PrzystanekID)
);


BULK INSERT dbo.#TmpPolaczenie FROM 'C:\Users\Dell\Documents\HurtownieDanych\zapytaniaMDX\sources\polaczeniaT2.bulk' WITH (FIELDTERMINATOR=',', CODEPAGE = '65001')
BULK INSERT dbo.#TmpPrzystanek FROM 'C:\Users\Dell\Documents\HurtownieDanych\zapytaniaMDX\sources\przystankiT2.bulk' WITH (FIELDTERMINATOR=',', CODEPAGE = '65001')
BULK INSERT dbo.#TmpKurs FROM 'C:\Users\Dell\Documents\HurtownieDanych\zapytaniaMDX\sources\kursyT2.bulk' WITH (FIELDTERMINATOR=',', CODEPAGE = '65001')
BULK INSERT dbo.#TmpCzasPrzejazdu FROM 'C:\Users\Dell\Documents\HurtownieDanych\zapytaniaMDX\sources\czasy_przejazduT2.bulk' WITH (FIELDTERMINATOR=',', CODEPAGE = '65001')
BULK INSERT dbo.#TmpBilet FROM 'C:\Users\Dell\Documents\HurtownieDanych\zapytaniaMDX\sources\biletyT2.bulk' WITH (FIELDTERMINATOR=',', CODEPAGE = '65001')


MERGE INTO dbo.Polaczenie AS target
USING #TmpPolaczenie AS source
ON target.PolaczenieID = source.PolaczenieID
-- Jeœli rekord nie istnieje, wstaw go
WHEN NOT MATCHED BY TARGET THEN
    INSERT (PolaczenieID, NazwaPolaczenia)
    VALUES (source.PolaczenieID, source.NazwaPolaczenia);

MERGE INTO dbo.Przystanek AS target
USING #TmpPrzystanek AS source
ON target.PrzystanekID = source.PrzystanekID
WHEN NOT MATCHED BY TARGET THEN
    INSERT (PrzystanekID, PolaczenieID, NazwaPrzystanku, KolejnoscNaTrasie)
    VALUES (source.PrzystanekID, source.PolaczenieID, source.NazwaPrzystanku, source.KolejnoscNaTrasie);

MERGE INTO dbo.Kurs AS target
USING #TmpKurs AS source
ON target.KursID = source.KursID
WHEN NOT MATCHED BY TARGET THEN
    INSERT (KursID, Data, PociagID, PolaczenieID)
    VALUES (source.KursID, source.Data, source.PociagID, source.PolaczenieID);

MERGE INTO dbo.CzasPrzejazdu AS target
USING #TmpCzasPrzejazdu AS source
ON target.KursID = source.KursID AND target.PrzystanekID = source.PrzystanekID
WHEN NOT MATCHED BY TARGET THEN
    INSERT (KursID, Data, PrzystanekID, GodzinaPrzyjazdu, GodzinaOdjazdu)
    VALUES (source.KursID, source.Data, source.PrzystanekID, source.GodzinaPrzyjazdu, source.GodzinaOdjazdu);

MERGE INTO dbo.Bilet AS target
USING #TmpBilet AS source
ON target.BiletID = source.BiletID
WHEN NOT MATCHED BY TARGET THEN
    INSERT (BiletID, PrzystanekPoczID, PrzystanekKonID, TypWagonu, KursID)
    VALUES (source.BiletID, source.PrzystanekPoczID, source.PrzystanekKonID, source.TypWagonu, source.KursID);

DROP TABLE #TmpPolaczenie;
DROP TABLE #TmpPrzystanek;
DROP TABLE #TmpKurs;
DROP TABLE #TmpCzasPrzejazdu;
DROP TABLE #TmpBilet;