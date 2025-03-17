-- Tworzenie tabel wymiarów
USE master
CREATE DATABASE railDW  collate Latin1_General_CI_AS;
GO
USE railDW
GO

CREATE TABLE Pociag (
    ID_Pociag INT IDENTITY(1,1) PRIMARY KEY,
    NrSeryjny VARCHAR(20) NOT NULL,
    Model VARCHAR(10),
    KategoriaRokProdukcji VARCHAR(20) CHECK (KategoriaRokProdukcji IN ('Stare', 'Nowe', 'Nowsze', 'Najnowoczeœniejsze')),
    KategoriaPredkosci VARCHAR(10) CHECK (KategoriaPredkosci IN ('Wolne', 'Szybkie', 'Najszybsze')),
    Klimatyzacja VARCHAR(20) CHECK (Klimatyzacja IN ('Klimatyzowany', 'Nieklimatyzowany')),
    CzyAktualny BIT NOT NULL
);

CREATE TABLE Polaczenie (
    ID_Polaczenie INT IDENTITY(1,1) PRIMARY KEY,
    NazwaPolaczenia VARCHAR(50) NOT NULL
);

CREATE TABLE Przystanek (
    ID_Przystanek INT IDENTITY(1,1) PRIMARY KEY,
    NazwaPrzystanku VARCHAR(30) NOT NULL
);

CREATE TABLE Data (
    ID_Data INT IDENTITY(1,1) PRIMARY KEY,
    Data DATE NOT NULL,
    Rok INT,
    Miesiac VARCHAR(12) CHECK (Miesiac IN ('Styczeñ', 'Luty', 'Marzec', 'Kwiecieñ', 'Maj', 'Czerwiec', 'Lipiec', 'Sierpieñ', 'Wrzesieñ', 'PaŸdziernik', 'Listopad', 'Grudzieñ')),
    MiesiacNo INT CHECK (MiesiacNo BETWEEN 1 AND 12),
    DzienTygodnia VARCHAR(12) CHECK (DzienTygodnia IN ('Poniedzia³ek', 'Wtorek', 'Œroda', 'Czwartek', 'Pi¹tek', 'Sobota', 'Niedziela')),
    DzienTygodniaNo INT CHECK (DzienTygodniaNo BETWEEN 1 AND 7),
    DzienRoboczy VARCHAR(15) CHECK (DzienRoboczy IN ('dzieñ wolny', 'dzieñ roboczy')),
    PoraRoku VARCHAR(7) CHECK (PoraRoku IN ('Wiosna', 'Lato', 'Jesieñ', 'Zima')),
    Wakacje VARCHAR(20) CHECK (Wakacje IN ('dzieñ powszedni', 'ferie zimowe', 'ferie letnie')),
    Swieto VARCHAR(50)
);

CREATE TABLE Czas (
    ID_Czas INT IDENTITY(1,1) PRIMARY KEY,
    Godzina INT CHECK (Godzina BETWEEN 0 AND 23),
    Minuta INT CHECK (Minuta BETWEEN 0 AND 59),
    PoraDnia VARCHAR(10) CHECK (PoraDnia IN ('rano', 'po³udnie', 'popo³udnie', 'wieczór', 'noc'))
);

-- Tworzenie tabel faktów
CREATE TABLE WykonaniePrzejazdu (
    ID_Polaczenie INT,
    ID_Przystanek INT,
    ID_Pociag INT,
    LiczbaPasazerowPrzedzialowych INT,
    LiczbaPasazerowBezprzedzialowych INT,
	LiczbaPasazerow AS (LiczbaPasazerowPrzedzialowych + LiczbaPasazerowBezprzedzialowych) PERSISTED,
    MiejscaPrzedzialowe INT,
    MiejscaBezprzedzialowe INT,
	MiejscaWPociagu AS (MiejscaPrzedzialowe + MiejscaBezprzedzialowe) PERSISTED,
    KursNO INT,
    ID_Data INT,
    ID_CzasPrzyjazdu INT,
    ID_CzasOdjazdu INT,
    FOREIGN KEY (ID_Polaczenie) REFERENCES Polaczenie(ID_Polaczenie),
    FOREIGN KEY (ID_Przystanek) REFERENCES Przystanek(ID_Przystanek),
    FOREIGN KEY (ID_Pociag) REFERENCES Pociag(ID_Pociag),
    FOREIGN KEY (ID_Data) REFERENCES Data(ID_Data),
    FOREIGN KEY (ID_CzasPrzyjazdu) REFERENCES Czas(ID_Czas),
    FOREIGN KEY (ID_CzasOdjazdu) REFERENCES Czas(ID_Czas)
);

CREATE TABLE NabycieBiletu (
    ID_Polaczenie INT,
    ID_PrzystanekPocz INT,
    ID_PrzystanekKon INT,
    KursNO INT,
    IloscBiletow INT,
    ID_Data INT,
    FOREIGN KEY (ID_Polaczenie) REFERENCES Polaczenie(ID_Polaczenie),
    FOREIGN KEY (ID_PrzystanekPocz) REFERENCES Przystanek(ID_Przystanek),
    FOREIGN KEY (ID_PrzystanekKon) REFERENCES Przystanek(ID_Przystanek),
    FOREIGN KEY (ID_Data) REFERENCES Data(ID_Data)
);
