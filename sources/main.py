import random
import string
import csv
from datetime import datetime, timedelta
from faker import Faker

fake = Faker('pl_PL')

ILE_MODELI_POCIAGOW = 5
ILE_POLACZEN = 3
ILE_POCIAGOW = ILE_POLACZEN * 4
# Ile różnych miast z których mogą być losowane przystanki
ILE_MIAST = 20
# Min/max przystaknów w jednym połączeniu
MIN_PRZYSTANKOW = 3
MAX_PRZYSTANKOW = 5

ILE_DNI = 180

# Kursy są od 6:00 do 18:00
CO_ILE_MIN_KURS = 60 * 4


def zapisz_do_pliku(nazwa_pliku, dane):
    with open(nazwa_pliku, mode='w', newline='', encoding='utf-8') as plik:
        writer = csv.writer(plik)
        writer.writerows(dane)


def generuj_skrotowy_model():
    # Losowy prefix (2-4 litery)
    prefix_length = random.randint(2, 4)
    prefix = ''.join(random.choices(string.ascii_uppercase, k=prefix_length))

    # Losowy suffix (2-4 cyfry)
    suffix_length = random.randint(2, 4)
    suffix = ''.join(random.choices(string.digits, k=suffix_length))

    model = f"{prefix}-{suffix}"
    return model

def generuj_numer_seryjny():
    # Pierwsze 5 znaków - litery
    litery = ''.join(random.choices(string.ascii_uppercase, k=5))

    # Kolejne 5 znaków - cyfry
    cyfry = ''.join(random.choices(string.digits, k=15))

    numer_seryjny = f"{litery}{cyfry}"
    return numer_seryjny

def generuj_unikalne_numery_seryjne(ile_pociagow):
    nr_seryjny = set()
    while len(nr_seryjny) < ile_pociagow:
        nowy_numer = generuj_numer_seryjny()
        if nowy_numer not in nr_seryjny:
            nr_seryjny.add(nowy_numer)
    return list(nr_seryjny)


def generuj_pociagi(liczba_pociagow, ile_modeli, poczatkowe_id):
    modele = []
    nr_seryjne = generuj_unikalne_numery_seryjne(liczba_pociagow)

    for _ in range(ile_modeli):
        modele.append(generuj_skrotowy_model())

    pociagi = []

    for i in range(1, liczba_pociagow + 1):
        model = random.choice(modele)
        rok_produkcji = random.randint(1990, 2020)
        miejsca_pasazerskie = random.choice(list(range(100, 200, 10)))

        # 60% na podzielone, 20% tylko przedziałowe, 20% tylko bezprzedziałowe
        typ_pociagu = random.choices(
            ['podzielony', 'przedziałowy', 'bezprzedziałowy'],
            weights=[60, 20, 20],
            k=1
        )[0]

        if typ_pociagu == 'podzielony':
            # Miejsca przedzialowe z przedziału 20% - 80% wszystkich miejsc
            min_przedzialowe = int(0.2 * miejsca_pasazerskie)
            max_przedzialowe = int(0.8 * miejsca_pasazerskie)

            # Losowanie liczby miejsc
            miejsca_przedzialowe = random.choice(list(range(min_przedzialowe, max_przedzialowe + 1, 5)))
            miejsca_bezprzedzialowe = miejsca_pasazerskie - miejsca_przedzialowe

        elif typ_pociagu == 'przedziałowy':
            # Wszystkie miejsca są przedziałowe
            miejsca_przedzialowe = miejsca_pasazerskie
            miejsca_bezprzedzialowe = 0

        else:  # typ_pociagu == 'bezprzedziałowy'
            # Wszystkie miejsca są bezprzedziałowe
            miejsca_przedzialowe = 0
            miejsca_bezprzedzialowe = miejsca_pasazerskie

        # Losowanie maksymalnej prędkości w zależności od roku produkcji (nowsze są szybsze)
        if rok_produkcji < 2000:
            predkosc_max = random.choice(list(range(100, 151, 5)))
        elif 2000 <= rok_produkcji < 2010:
            predkosc_max = random.choice(list(range(150, 181, 5)))
        else:
            predkosc_max = random.choice(list(range(180, 201, 5)))

        klimatyzacja = random.choices(
            ['Klimatyzowany', 'Nieklimatyzowany'],
            weights=[60, 40],
            k=1
        )[0]

        pociagi.append({
            'pociag_id': len(pociagi) + 1 + poczatkowe_id,
            'nr_seryjny': nr_seryjne[i - 1],
            'model': model,
            'rok_produkcji': rok_produkcji,
            'miejsca_pasazerskie': miejsca_pasazerskie,
            'miejsca_przedzialowe': miejsca_przedzialowe,
            'miejsca_bezprzedzialowe': miejsca_bezprzedzialowe,
            'predkosc_maksymalna': predkosc_max,
            'klimatyzacja': klimatyzacja
        })

    return pociagi


def generuj_polaczenia(liczba_polaczen, min_przystankow, max_przystankow, ile_miast, pocz_id_polacz, pocz_id_przyst):
    polaczenia = []
    przystanki = []

    polskie_miasta = [fake.city() for _ in range(ile_miast)]

    for i in range(1+pocz_id_polacz, liczba_polaczen + pocz_id_polacz + 1):
        polaczenie_id = i
        liczba_przystankow = random.randint(min_przystankow, max_przystankow)
        przystanki_na_trasie = random.sample(polskie_miasta, liczba_przystankow)

        # Pierwszy Przystanek - Ostatni Przystanek
        nazwa_polaczenia = f"{przystanki_na_trasie[0]} - {przystanki_na_trasie[-1]}"

        polaczenia.append({
            'polaczenie_id': len(polaczenia) + 1 + pocz_id_polacz,
            'nazwa_polaczenia': nazwa_polaczenia
        })

        # Generowanie przystanków dla połączenia
        for kolejność, miasto in enumerate(przystanki_na_trasie, start=1):
            przystanki.append({
                'przystanek_id': len(przystanki) + 1 + pocz_id_przyst,
                'polaczenie_id': polaczenie_id,
                'nazwa_przystanku': miasto,
                'kolejnosc_na_trasie': kolejność
            })

    return polaczenia, przystanki


def generuj_kursy(ile_dni, polaczenia, pociagi, co_ile_min_kurs, pomin_dni, poczatkowe_id, przypisane_pociagi, zajete_pociagi):
    kursy = []

    # Data początkowa (1 stycznia 2020)
    start_data = datetime(2020, 1, 1)

    # Pomiń dni dla czasu T2
    start_data = start_data + timedelta(days=pomin_dni)

    for dzien in range(ile_dni):
        obecna_data = start_data + timedelta(days=dzien)
        data_kursu_str = obecna_data.strftime('%Y-%m-%d')

        if data_kursu_str not in zajete_pociagi:
            zajete_pociagi[data_kursu_str] = []

        for polaczenie in polaczenia:
            polaczenie_id = polaczenie['polaczenie_id']

            # Generowanie kursów od 6:00 do 18:00 co x minut
            godzina = datetime(obecna_data.year, obecna_data.month, obecna_data.day, 6, 0)
            koniec_dnia = datetime(obecna_data.year, obecna_data.month, obecna_data.day, 18, 0)

            while godzina <= koniec_dnia:
                godzina_wyjazdu = godzina.strftime('%H:%M')

                # Klucz dla połączenia i konkretnej godziny
                klucz_przypisania = (polaczenie_id, godzina_wyjazdu)

                # Czy dla danego połączenia i godziny już wylosowano pociąg
                if klucz_przypisania not in przypisane_pociagi:
                    # Sprawdzenie, które pociągi są dostępne
                    dostepne_pociagi = [p for p in pociagi if p['pociag_id'] not in zajete_pociagi[data_kursu_str]]

                    if dostepne_pociagi:
                        pociag = random.choice(dostepne_pociagi)
                        pociag_id = pociag['pociag_id']

                        # Przypisanie pociągu do konkretnego połączenia i godziny
                        przypisane_pociagi[klucz_przypisania] = pociag_id

                        zajete_pociagi[data_kursu_str].append(pociag_id)

                else:
                    # Jeśli pociąg został już wcześniej przypisany, używamy go
                    pociag_id = przypisane_pociagi[klucz_przypisania]

                # Dodanie kursu
                kursy.append({
                    'kurs_id': len(kursy) + 1 + poczatkowe_id,
                    'data': data_kursu_str,
                    'pociag_id': pociag_id,
                    'polaczenie_id': polaczenie_id,
                    'godzina_wyjazdu': godzina_wyjazdu
                })

                # Przesuwanie czasu o określoną liczbę minut
                godzina += timedelta(minutes=co_ile_min_kurs)

    return kursy


def generuj_czasy_przejazdu(kursy, przystanki):

    czasy_przejazdu = []

    for kurs in kursy:
        kurs_id = kurs['kurs_id']
        data_kursu = datetime.strptime(kurs['data'], '%Y-%m-%d')
        godzina_start = datetime.strptime(f"{kurs['data']} {kurs['godzina_wyjazdu']}", '%Y-%m-%d %H:%M')

        # Przystanki dla danego połązczenia
        przystanki_na_trasie = [p for p in przystanki if p['polaczenie_id'] == kurs['polaczenie_id']]
        przystanki_na_trasie.sort(key=lambda x: x['kolejnosc_na_trasie'])  # Sortowanie po kolejności

        aktualna_godzina = godzina_start
        aktualna_data = data_kursu
        total_time = timedelta(hours=0)

        for i, przystanek in enumerate(przystanki_na_trasie):
            przystanek_id = przystanek['przystanek_id']

            if i == 0:
                # Pierwszy przystanek - czas odjazdu to godzina wyjazdu kursu
                czas_przyjazdu = aktualna_godzina
            else:
                # Losowy czas przejazdu 10min do 2h
                czas_przejazdu = timedelta(minutes=random.randint(10, 120))
                czas_przyjazdu = aktualna_godzina + czas_przejazdu
                total_time += czas_przejazdu

            # Czy przekroczono północ - zmiana na kolejny dzień
            if czas_przyjazdu.day != aktualna_godzina.day:
                aktualna_data += timedelta(days=1)
                czas_przyjazdu = czas_przyjazdu.replace(year=aktualna_data.year, month=aktualna_data.month,
                                                        day=aktualna_data.day)

            # Losowy postój 5 do 20 minut
            czas_postoju = timedelta(minutes=random.randint(5, 20))
            godzina_odjazdu = czas_przyjazdu + czas_postoju
            total_time += czas_postoju

            # Zapis danych przejazdu dla przystanku
            czasy_przejazdu.append({
                'kurs_id': kurs_id,
                'data': aktualna_data.strftime('%Y-%m-%d'),
                'przystanek_id': przystanek_id,
                'godzina_przyjazdu': czas_przyjazdu.strftime('%H:%M'),
                'godzina_odjazdu': godzina_odjazdu.strftime('%H:%M')
            })

            aktualna_godzina = godzina_odjazdu

    return czasy_przejazdu


def zlicz_wysiadajacych_na_przystanku(bilety, przystanek_id, typ_wagonu, kurs_id):
    # sumowanie ile osób z wcześniej wylosowanych biletów wysiada na tym przystanku
    return sum(
        1 for bilet in bilety if
        bilet['przystanek_koncowy'] == przystanek_id and bilet['typ_wagonu'] == typ_wagonu and bilet[
            'kurs_id'] == kurs_id)


def generuj_bilety(kursy, przystanki, pociagi, pocz_id):

    bilety = []

    for kurs in kursy:
        bilet_na_kurs = []
        kurs_id = kurs['kurs_id']
        pociag_id = kurs['pociag_id']
        pociag = next(p for p in pociagi if p['pociag_id'] == pociag_id)

        # Dostępne miejsca w przedziałowe i bezprzedziałowe wagonach
        miejsca_przedzialowe = pociag['miejsca_przedzialowe']
        miejsca_bezprzedzialowe = pociag['miejsca_bezprzedzialowe']

        # Przystanki dla kursu
        przystanki_na_trasie = [p for p in przystanki if p['polaczenie_id'] == kurs['polaczenie_id']]
        przystanki_na_trasie.sort(key=lambda x: x['kolejnosc_na_trasie'])  # Sortowanie po kolejności

        # Ile osób jest w pociągu
        liczba_podroznych_przedzial = 0
        liczba_podroznych_bezprzedzial = 0

        for i in range(len(przystanki_na_trasie) - 1):

            przystanek_poczatkowy = przystanki_na_trasie[i]

            przystanek_poczatkowy_id = przystanek_poczatkowy['przystanek_id']

            # Ile osób wysiada na tym przystanku
            liczba_wysiadajacych_przedzial = zlicz_wysiadajacych_na_przystanku(bilet_na_kurs, przystanek_poczatkowy_id,
                                                                               'przedziałowy', kurs_id)
            liczba_wysiadajacych_bezprzedzial = zlicz_wysiadajacych_na_przystanku(bilet_na_kurs,
                                                                                  przystanek_poczatkowy_id,
                                                                                  'bezprzedziałowy', kurs_id)

            liczba_podroznych_przedzial -= liczba_wysiadajacych_przedzial
            liczba_podroznych_bezprzedzial -= liczba_wysiadajacych_bezprzedzial

            # Wolne miejsca po wysiadaniu pasażerów
            wolne_miejsca_przedzial = miejsca_przedzialowe - liczba_podroznych_przedzial
            wolne_miejsca_bezprzedzial = miejsca_bezprzedzialowe - liczba_podroznych_bezprzedzial

            # Losowa liczba wsiadających
            liczba_wsiadajacych_przedzial = random.randint(0, wolne_miejsca_przedzial)
            liczba_wsiadajacych_bezprzedzial = random.randint(0, wolne_miejsca_bezprzedzial)

            liczba_podroznych_przedzial += liczba_wsiadajacych_przedzial
            liczba_podroznych_bezprzedzial += liczba_wsiadajacych_bezprzedzial

            # Generowanie biletów dla osób wsiadających na tym przystanku
            for _ in range(liczba_wsiadajacych_przedzial):
                przystanek_koncowy_id = random.choice([p['przystanek_id'] for p in przystanki_na_trasie[i + 1:]])
                bilet_na_kurs.append({
                    'bilet_id': len(bilety) + 1 + pocz_id,
                    'przystanek_poczatkowy': przystanek_poczatkowy_id,
                    'przystanek_koncowy': przystanek_koncowy_id,
                    'typ_wagonu': 'przedziałowy',
                    'kurs_id': kurs_id
                })

                bilety.append({
                    'bilet_id': len(bilety) + 1 + pocz_id,
                    'przystanek_poczatkowy': przystanek_poczatkowy_id,
                    'przystanek_koncowy': przystanek_koncowy_id,
                    'typ_wagonu': 'przedziałowy',
                    'kurs_id': kurs_id
                })

            for _ in range(liczba_wsiadajacych_bezprzedzial):
                przystanek_koncowy_id = random.choice([p['przystanek_id'] for p in przystanki_na_trasie[i + 1:]])
                bilet_na_kurs.append({
                    'bilet_id': len(bilety) + 1 + pocz_id,
                    'przystanek_poczatkowy': przystanek_poczatkowy_id,
                    'przystanek_koncowy': przystanek_koncowy_id,
                    'typ_wagonu': 'bezprzedziałowy',
                    'kurs_id': kurs_id
                })

                bilety.append({
                    'bilet_id': len(bilety) + 1 + pocz_id,
                    'przystanek_poczatkowy': przystanek_poczatkowy_id,
                    'przystanek_koncowy': przystanek_koncowy_id,
                    'typ_wagonu': 'bezprzedziałowy',
                    'kurs_id': kurs_id
                })

    return bilety


# -------------- GENEROWANIE DLA CZASU T1 --------------

pociagiT1 = generuj_pociagi(ILE_POCIAGOW, ILE_MODELI_POCIAGOW, 0)

polaczeniaT1, przystankiT1 = generuj_polaczenia(ILE_POLACZEN, MIN_PRZYSTANKOW, MAX_PRZYSTANKOW, ILE_MIAST, 0, 0)

przypisane_pociagi = {}
zajete_pociagi = {}

kursyT1 = generuj_kursy(ILE_DNI, polaczeniaT1, pociagiT1, CO_ILE_MIN_KURS, 0, 0, przypisane_pociagi, zajete_pociagi)

czasy_przejazduT1 = generuj_czasy_przejazdu(kursyT1, przystankiT1)

biletyT1 = generuj_bilety(kursyT1, przystankiT1, pociagiT1, 0)

# -------------- GENEROWANIE DLA CZASU T1 --------------

# -------------- ZAPISANIE T1 --------------

dane_pociagiT1 = [(p['pociag_id'], p['nr_seryjny'], p['model'], p['rok_produkcji'], p['miejsca_pasazerskie'], p['miejsca_przedzialowe'],
                   p['miejsca_bezprzedzialowe'], p['predkosc_maksymalna'], p['klimatyzacja']) for p in pociagiT1]
zapisz_do_pliku('specyfikacja_pociagowT1.csv', dane_pociagiT1)

dane_polaczeniaT1 = [(p['polaczenie_id'], p['nazwa_polaczenia']) for p in polaczeniaT1]
zapisz_do_pliku('polaczeniaT1.bulk', dane_polaczeniaT1)

dane_przystankiT1 = [(p['przystanek_id'], p['polaczenie_id'], p['nazwa_przystanku'], p['kolejnosc_na_trasie']) for p in
                     przystankiT1]
zapisz_do_pliku('przystankiT1.bulk', dane_przystankiT1)

dane_kursy_bez_godzinyT1 = [(k['kurs_id'], k['data'], k['pociag_id'], k['polaczenie_id']) for k in kursyT1]
zapisz_do_pliku('kursyT1.bulk', dane_kursy_bez_godzinyT1)

dane_czasy_przejazduT1 = [(cp['kurs_id'], cp['data'], cp['przystanek_id'], cp['godzina_przyjazdu'], cp['godzina_odjazdu'])
                          for cp in czasy_przejazduT1]
zapisz_do_pliku('czasy_przejazduT1.bulk', dane_czasy_przejazduT1)

dane_biletyT1 = [(b['bilet_id'], b['przystanek_poczatkowy'], b['przystanek_koncowy'], b['typ_wagonu'], b['kurs_id']) for b
                 in biletyT1]
zapisz_do_pliku('biletyT1.bulk', dane_biletyT1)

# -------------- ZAPISANIE T1 --------------

ILE_POCIAGOW_T2 = 3
ILE_POLACZEN_T2 = 2

# -------------- GENEROWANIE DLA CZASU T2 --------------
pociagiT2 = pociagiT1
pociagiNEW = generuj_pociagi(ILE_POCIAGOW_T2, ILE_MODELI_POCIAGOW, len(pociagiT1))
pociagiT2.extend(pociagiNEW)

polaczeniaT2 = polaczeniaT1
przystankiT2 = przystankiT1
polaczeniaNEW, przystankiNEW = generuj_polaczenia(ILE_POLACZEN_T2, MIN_PRZYSTANKOW, MAX_PRZYSTANKOW, ILE_MIAST, len(polaczeniaT1), len(przystankiT1))
polaczeniaT2.extend(polaczeniaNEW)
przystankiT2.extend(przystankiNEW)

kursyT2 = kursyT1
kursyNEW = generuj_kursy(ILE_DNI, polaczeniaT2, pociagiT2, CO_ILE_MIN_KURS, ILE_DNI, len(kursyT1), przypisane_pociagi, zajete_pociagi)
kursyT2.extend(kursyNEW)

czasy_przejazduT2 = czasy_przejazduT1
czasy_przejazduNEW = generuj_czasy_przejazdu(kursyNEW, przystankiT2)
czasy_przejazduT2.extend(czasy_przejazduNEW)

biletyT2 = biletyT1
biletyNEW = generuj_bilety(kursyNEW, przystankiT2, pociagiT2, len(biletyT1))
biletyT2.extend(biletyNEW)

# -------------- ZAPISANIE T2 --------------

dane_pociagiT2 = [(p['pociag_id'],p['nr_seryjny'], p['model'], p['rok_produkcji'], p['miejsca_pasazerskie'], p['miejsca_przedzialowe'],
                   p['miejsca_bezprzedzialowe'], p['predkosc_maksymalna'], p['klimatyzacja']) for p in pociagiT2]
zapisz_do_pliku('specyfikacja_pociagowT2.csv', dane_pociagiT2)

dane_polaczeniaT2 = [(p['polaczenie_id'], p['nazwa_polaczenia']) for p in polaczeniaT2]
zapisz_do_pliku('polaczeniaT2.bulk', dane_polaczeniaT2)

dane_przystankiT2 = [(p['przystanek_id'], p['polaczenie_id'], p['nazwa_przystanku'], p['kolejnosc_na_trasie']) for p in
                     przystankiT2]
zapisz_do_pliku('przystankiT2.bulk', dane_przystankiT2)

dane_kursy_bez_godzinyT2 = [(k['kurs_id'], k['data'], k['pociag_id'], k['polaczenie_id']) for k in kursyT2]
zapisz_do_pliku('kursyT2.bulk', dane_kursy_bez_godzinyT2)

dane_czasy_przejazduT2 = [(cp['kurs_id'], cp['data'], cp['przystanek_id'], cp['godzina_przyjazdu'], cp['godzina_odjazdu'])
                          for cp in czasy_przejazduT2]
zapisz_do_pliku('czasy_przejazduT2.bulk', dane_czasy_przejazduT2)

dane_biletyT2 = [(b['bilet_id'], b['przystanek_poczatkowy'], b['przystanek_koncowy'], b['typ_wagonu'], b['kurs_id']) for b
                 in biletyT2]
zapisz_do_pliku('biletyT2.bulk', dane_biletyT2)