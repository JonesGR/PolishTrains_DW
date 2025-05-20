# Projekt hurtowni danych

## Etapy 
1. Definiowanie wymagań dla systemu typu BI i zdefiniowanie źródeł danych
1. Implementacja generatora danych źródłowych
1. Projekt hurtowni danych
1. Implementacja hurtowni danych
1. Implementacja procesu ETL
1. Zapytania MDX
1. Opracowanie dashboardów, wizualizacja danych

### 1. Definiowanie wymagań dla systemu typu BI i zdefiniowanie źródeł danych

Celem zadania było zdefiniowanie wymagań dla systemu BI, z uwzględnieniem istniejących w firmie/organizacji procesów i źródeł danych. W ramach tego etapu symulowany był proces zbierania wymagań dla fikcyjnej firmy.
- **Opis organizacji**: [dokumenty/ProcessesSpecification.pdf](dokumenty/ProcessesSpecification.pdf)
- **Specyfikacja procesu biznesowego**: [dokumenty/RequirementsProcessSpecification.pdf](dokumenty/RequirementsProcessSpecification.pdf)

### 2. Generator danych źródłowych

Zadanie polegało na stworzeniu parametryzowanego generatora danych, który umożliwia symulację działania systemu na dużych zbiorach danych. Generator pełnił rolę pomocniczą, jednak istotną dla testowania dalszych etapów projektu BI.
- Możliwości generatora:
    - Parametryzacja ilości generowanych rekordów
    - Możliwość wygenerowania danych w dwóch punktach czasowych: `T1` i `T2`
    - Dane z `T2` zawierają dane z `T1` oraz dodatkowe nowe rekordy

### 3. Projekt hurtowni danych

Celem zadania było zaprojektowanie hurtowni danych odpowiadającej specyfikacji wymagań dla wybranego procesu biznesowego. 
- **Projekt hurtowni danych**: [dokumenty/ProjektHurtowniDanych.pdf](dokumenty/ProjektHurtowniDanych.pdf)

### 4. Implementacja hurtowni danych

Celem zadania było zapoznanie się z zagadnieniami związanymi z implementacją hurtowni danych z wykorzystaniem narzędzii **SQL Server Data Tools (SSDT)** w środowisku **Visual Studio 2022**.
- Projekt hurtowni znajduje się w folderze `RailDW`

<h3 align=center> Schemat hurtowni danych</h3>

![image](https://github.com/user-attachments/assets/16815389-c49f-4efb-920a-cf03c71417da)


# Projekt hurtowni danych

## Etapy

1. Definiowanie wymagań dla systemu typu BI i zdefiniowanie źródeł danych
2. Implementacja generatora danych źródłowych
3. Projekt hurtowni danych
4. Implementacja hurtowni danych
5. Implementacja procesu ETL
6. Zapytania MDX
7. Opracowanie dashboardów, wizualizacja danych

### 1. Definiowanie wymagań dla systemu typu BI i zdefiniowanie źródeł danych

Celem zadania było zdefiniowanie wymagań dla systemu BI, z uwzgl...apu symulowany był proces zbierania wymagań dla fikcyjnej firmy.

* **Opis organizacji**: [dokumenty/ProcessesSpecification.pdf](dokumenty/ProcessesSpecification.pdf)
* **Specyfikacja procesu biznesowego**: [dokumenty/RequirementsP...ecification.pdf](dokumenty/RequirementsProcessSpecification.pdf)

### 2. Generator danych źródłowych

Zadanie polegało na stworzeniu parametryzowanego generatora danych, który umożliwia symulację działania systemu na dużych zbiorach danych. Generator pełnił rolę pomocniczą, jednak istotną dla testowania dalszych etapów projektu BI.

* Możliwości generatora:

  * Parametryzacja ilości generowanych rekordów
  * Możliwość wygenerowania danych w dwóch punktach czasowych: `T1` i `T2`
  * Dane z `T2` zawierają dane z `T1` oraz dodatkowe nowe rekordy

### 3. Projekt hurtowni danych

Celem zadania było zaprojektowanie hurtowni danych odpowiadającej specyfikacji wymagań dla wybranego procesu biznesowego.

* **Projekt hurtowni danych**: [dokumenty/ProjektHurtowniDanych.pdf](dokumenty/ProjektHurtowniDanych.pdf)

### 4. Implementacja hurtowni danych

Celem zadania było zapoznanie się z zagadnieniami związanymi z implementacją hurtowni danych z wykorzystaniem narzędzi **SQL Server Data Tools (SSDT)** w środowisku **Visual Studio 2022**.

* Projekt Visual Studio hurtowni znajduje się w folderze `RailDW`

<h3 align=center> Schemat hurtowni danych</h3>

![image](https://github.com/user-attachments/assets/16815389-c49f-4efb-920a-cf03c71417da)

### 5. Implementacja procesu ETL

Proces ETL został zaprojektowany w środowisku **SQL Server Integration Services (SSIS)** i składa się z **dwóch** odrębnych pakietów:

| Pakiet SSIS              | Rola                                                               | Najważniejsze kroki                                                                                                                                                                                                                                                                                                                                                                                                                    |
| ------------------------ | ------------------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `Initial_data.dtsx`      | Jednorazowe **załadowanie danych statycznych** do wymiarów         | Utworzenie tymczasowych tabel pomocniczych <br> Załadowanie wymiarów **Season**, **Holiday**, **Vacation** <br> Wygenerowanie i wypełnienie wymiarów **Date** oraz **Time** <br>4. Usunięcie tabel pomocniczych                                                                                                                                                                                                                 |
| `Recurrent_loading.dtsx` | **Przyrostowe ładowanie** danych operacyjnych w cyklu T‑n —► T‑n+1 | Załadowanie zrzutu danych źródłowych dla chwili **Tₙ**<br>Porównanie z już załadowanymi rekordami (zrzut **Tₙ₋₁**) przy pomocy komponentów **Lookup**<br>Wstawienie **wyłącznie nowych** wierszy do faktów **WykonaniePrzejazdu** i **NabycieBiletu** oraz nowych wierszy w wymiarach **Pociąg**, **Połączenie**, **Przystanek**<br> Aktualizacja wymiarów wolno‑zmiennych przy użyciu komponentu **Slowly Changing Dimension**) |

#### Wykrywanie nowych lub zmienionych danych

* Źródłowy system kolejowy generuje pełny zrzut danych w każdym punkcie czasowym **Tⱼ**.
* Zrzut **Tⱼ** zawiera dane z **Tⱼ₋₁** + nowo dodane rekordy.
* W pakiecie `Recurrent_loading.dtsx` do hurtowni trafiają **tylko rekordy, których brakowało**.

#### Aktualizacja wymiarów wolno zmieniających się (SCD)

* Dla wymiarów, w których atrybuty mogą zmieniać się w czasie (np. dodanie klimatyzacji w pociągu), zastosowano **Type 2 SCD**.
* SSIS automatycznie kończy „stary” rekord i dodaje nowy z aktualnymi atrybutami.

#### Przetwarzanie kostki

Ostatnim krokiem jest automatyczne przetworzenie kostki analitycznej. Dzięki temu:
* Raporty i dashboardy korzystają zawsze z najnowszych danych,
* Cała procedura jest w pełni zautomatyzowana

#### Uruchomienie procesu ETL

Projekt SSIS znajduje się w folderze HurtownieETL. Przed pierwszym uruchomieniem należy:

1. Ustawić ścieżki plików – w każdym pakiecie otwórz zakładkę Connection Managers i wskaż prawidłowe lokalizacje plików źródłowych z folderu sources oraz skryptów z folderu scripts.
2. Wykonać potrzebne skrypty z folderu scripts do utworzenia obu baz.
3. Skonfigurować połączenia – uaktualnij parametry/connection strings, tak aby kierowały na odpowiednie instancje SQL Server dla bazy źródłowej oraz hurtowni.

Po spełnieniu powyższych kroków uruchom:
* Initial_data.dtsx – jednorazowo, aby załadować dane statyczne,
* Recurrent_loading.dtsx – cyklicznie, aby wczytywać przyrostowe dane operacyjne.


<h3 align=center> Initial data </h3>

![image](https://github.com/user-attachments/assets/b7a07e1a-2e0c-4305-b0ec-26c466790046)

<h3 align=center> Recurrent loading </h3>

![image](https://github.com/user-attachments/assets/0da9f725-e44f-4efd-86d1-b99893fd193b)





