USE master
CREATE DATABASE PolaczeniaKolejowe collate Latin1_General_CI_AS;
GO
USE PolaczeniaKolejowe;
GO
CREATE TABLE Polaczenie (
    PolaczenieID INT PRIMARY KEY,  -- PK - ID
    NazwaPolaczenia VARCHAR(30)     -- Nazwa po³¹czenia np. Gdañsk -> Warszawa
);

CREATE TABLE Przystanek (
    PrzystanekID INT PRIMARY KEY,   -- PK - ID
    PolaczenieID INT,               -- FK - Po³¹czenie (powi¹zanie z tabel¹ Po³¹czenie)
    NazwaPrzystanku VARCHAR(30),    -- Nazwa przystanku
    KolejnoscNaTrasie INT,          -- Kolejnoœæ przystanku na trasie
    FOREIGN KEY (PolaczenieID) REFERENCES Polaczenie(PolaczenieID)
);

CREATE TABLE Kurs (
    KursID INT PRIMARY KEY,         -- PK - ID
    Data DATE,                  -- Dzieñ i godzina odjazdu ze stacji pocz¹tkowej
    PociagID INT,                   -- ID poci¹gu (z danych z pliku)
    PolaczenieID INT,               -- FK - Po³¹czenie (powi¹zanie z tabel¹ Po³¹czenie)
    FOREIGN KEY (PolaczenieID) REFERENCES Polaczenie(PolaczenieID)
);

CREATE TABLE Bilet (
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
CREATE TABLE CzasPrzejazdu (
    KursID INT,                     -- FK - Kurs
    Data DATE,                  -- Data (dzieñ kursu)
    PrzystanekID INT,               -- FK - Przystanek
    GodzinaPrzyjazdu TIME,      -- Godzina przyjazdu na przystanek
    GodzinaOdjazdu TIME,        -- Godzina odjazdu z przystanku
    PRIMARY KEY (KursID, PrzystanekID),  -- PK - Klucz z³o¿ony
    FOREIGN KEY (KursID) REFERENCES Kurs(KursID),
    FOREIGN KEY (PrzystanekID) REFERENCES Przystanek(PrzystanekID)
);
