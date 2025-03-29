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
