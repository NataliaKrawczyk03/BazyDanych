USE firma2

-- Wyświetl tylko id pracownika oraz jego nazwisko. 
SELECT id_pracownika, nazwisko
FROM ksiegowosc.pracownicy;

--Wyświetl pracowników których płaca jest większa niz 1000
SELECT 
    ksiegowosc.pracownicy.imie, 
    ksiegowosc.pracownicy.nazwisko, 
    ksiegowosc.pensja.stanowisko, 
    ksiegowosc.pensja.kwota 
FROM 
    ksiegowosc.wynagrodzenie
JOIN 
    ksiegowosc.pracownicy ON ksiegowosc.wynagrodzenie.id_pracownika = ksiegowosc.pracownicy.id_pracownika
JOIN
    ksiegowosc.pensja ON ksiegowosc.wynagrodzenie.id_pensji = ksiegowosc.pensja.id_pensji
WHERE 
    ksiegowosc.pensja.kwota > 1000;

--Wyświetl pracowników nieposiadających premii których płaca jest wieksza niz 2000
SELECT 
    ksiegowosc.pracownicy.imie, 
    ksiegowosc.pracownicy.nazwisko, 
    ksiegowosc.pensja.stanowisko, 
    ksiegowosc.pensja.kwota 
FROM 
    ksiegowosc.wynagrodzenie
JOIN 
    ksiegowosc.pracownicy ON ksiegowosc.wynagrodzenie.id_pracownika = ksiegowosc.pracownicy.id_pracownika
JOIN
    ksiegowosc.pensja ON ksiegowosc.wynagrodzenie.id_pensji = ksiegowosc.pensja.id_pensji
JOIN
    ksiegowosc.premia ON ksiegowosc.wynagrodzenie.id_premii = ksiegowosc.premia.id_premii
WHERE 
    ksiegowosc.pensja.kwota > 2000 AND ksiegowosc.premia.kwota = 0;

--Wyświetl pracowników, których pierwsza litera imienia zaczyna się na literę ‘J’. 
SELECT id_pracownika, imie , nazwisko
FROM ksiegowosc.pracownicy
WHERE imie LIKE 'J%'; -- % - dowolny ciag znakow 

--Wyświetl pracowników, których nazwisko zawiera literę ‘n’ oraz imię kończy się na literę ‘a’. 
SELECT id_pracownika, imie , nazwisko
FROM ksiegowosc.pracownicy
WHERE imie LIKE '%a' AND nazwisko LIKE '%n%';

--Wyświetl imię i nazwisko pracowników oraz liczbę ich nadgodzin, przyjmując, iż standardowy czas pracy to 160 h miesięcznie. 
SELECT
	ksiegowosc.pracownicy.imie, 
    ksiegowosc.pracownicy.nazwisko,
	CASE
        WHEN SUM(ksiegowosc.godziny.liczba_godzin) > 160 THEN SUM(ksiegowosc.godziny.liczba_godzin) - 160
        ELSE 0
    END AS liczba_nadgodzin
FROM
	ksiegowosc.godziny
JOIN 
	ksiegowosc.pracownicy ON ksiegowosc.pracownicy.id_pracownika = ksiegowosc.godziny.id_pracownika
GROUP BY
	ksiegowosc.pracownicy.imie,
	ksiegowosc.pracownicy.nazwisko;

--Imie i nazwisko pracownikow ktorych pensja jest w przedziale 1500-3000
SELECT 
    ksiegowosc.pracownicy.imie, 
    ksiegowosc.pracownicy.nazwisko,  
    ksiegowosc.pensja.kwota 
FROM 
    ksiegowosc.wynagrodzenie
JOIN 
    ksiegowosc.pracownicy ON ksiegowosc.wynagrodzenie.id_pracownika = ksiegowosc.pracownicy.id_pracownika
JOIN
    ksiegowosc.pensja ON ksiegowosc.wynagrodzenie.id_pensji = ksiegowosc.pensja.id_pensji
WHERE 
    ksiegowosc.pensja.kwota > 1500 AND ksiegowosc.pensja.kwota < 3000;

--Wyświetl imię i nazwisko pracowników, którzy pracowali w nadgodzinach i nie otrzymali premii.
SELECT
	ksiegowosc.pracownicy.imie, 
    ksiegowosc.pracownicy.nazwisko, 
	ksiegowosc.premia.kwota,
	ksiegowosc.godziny.liczba_godzin
FROM
	ksiegowosc.wynagrodzenie
JOIN
	ksiegowosc.pracownicy ON ksiegowosc.wynagrodzenie.id_pracownika = ksiegowosc.pracownicy.id_pracownika
JOIN
	ksiegowosc.premia ON ksiegowosc.wynagrodzenie.id_premii = ksiegowosc.premia.id_premii
JOIN
	ksiegowosc.godziny ON ksiegowosc.wynagrodzenie.id_godziny = ksiegowosc.godziny.id_godziny
WHERE
	ksiegowosc.premia.kwota = 400
GROUP BY
	ksiegowosc.pracownicy.imie, 
    ksiegowosc.pracownicy.nazwisko,
	ksiegowosc.premia.kwota,
	ksiegowosc.godziny.liczba_godzin
HAVING
	SUM(ksiegowosc.godziny.liczba_godzin)>160;

--Uszereguj pracownikow wedlug pensji
SELECT 
    ksiegowosc.pracownicy.imie, 
    ksiegowosc.pracownicy.nazwisko, 
	ksiegowosc.pensja.stanowisko,
    ksiegowosc.pensja.kwota
FROM 
    ksiegowosc.wynagrodzenie
JOIN 
    ksiegowosc.pracownicy ON ksiegowosc.wynagrodzenie.id_pracownika = ksiegowosc.pracownicy.id_pracownika
JOIN
    ksiegowosc.pensja ON ksiegowosc.wynagrodzenie.id_pensji = ksiegowosc.pensja.id_pensji
ORDER BY
	ksiegowosc.pensja.kwota DESC;

--Uszereguj pracownikow wedlug pensji i premii malejaco
SELECT 
    ksiegowosc.pracownicy.imie, 
    ksiegowosc.pracownicy.nazwisko,
	ksiegowosc.pensja.stanowisko,
    ksiegowosc.pensja.kwota,
	ksiegowosc.premia.kwota
FROM 
    ksiegowosc.wynagrodzenie
JOIN 
    ksiegowosc.pracownicy ON ksiegowosc.wynagrodzenie.id_pracownika = ksiegowosc.pracownicy.id_pracownika
JOIN
    ksiegowosc.pensja ON ksiegowosc.wynagrodzenie.id_pensji = ksiegowosc.pensja.id_pensji
JOIN
    ksiegowosc.premia ON ksiegowosc.wynagrodzenie.id_premii = ksiegowosc.premia.id_premii
ORDER BY
	(ksiegowosc.pensja.kwota + ksiegowosc.premia.kwota) ASC;

--Zlicz i pogrupuj pracowników według pola ‘stanowisko’. 
SELECT
    ksiegowosc.pensja.stanowisko,
    COUNT(*) AS liczba_pracownikow
FROM
    ksiegowosc.pensja
GROUP BY
    ksiegowosc.pensja.stanowisko;

--Policz średnią, minimalną i maksymalną płacę dla stanowiska ‘Informatyk’
SELECT
	ksiegowosc.pensja.stanowisko,
	AVG(ksiegowosc.pensja.kwota) AS srednia_pensja,
	MIN(ksiegowosc.pensja.kwota) AS minimalna_pensja,
	MAX(ksiegowosc.pensja.kwota) AS maksymalna_pensja
FROM
	ksiegowosc.pensja
WHERE
	ksiegowosc.pensja.stanowisko = 'Informatyk'
GROUP BY
    ksiegowosc.pensja.stanowisko;

--Policz sumę wszystkich wynagrodzeń. 
SELECT
	SUM(ksiegowosc.pensja.kwota) AS suma_wynagrodzen
FROM
	ksiegowosc.pensja;

--Policz sumę wynagrodzeń w ramach danego stanowiska
SELECT
	ksiegowosc.pensja.stanowisko,
	SUM(ksiegowosc.pensja.kwota) AS suma_wynagrodzen
FROM
	ksiegowosc.pensja
GROUP BY
	ksiegowosc.pensja.stanowisko;

--Wyznacz liczbę premii przyznanych dla pracowników danego stanowiska
SELECT
    pensja.stanowisko,
    SUM(premia.kwota) AS suma_kwot_premii
FROM
    ksiegowosc.pensja
JOIN
    ksiegowosc.wynagrodzenie ON pensja.id_pensji = wynagrodzenie.id_pensji
JOIN
    ksiegowosc.premia ON wynagrodzenie.id_premii = premia.id_premii
GROUP BY
    pensja.stanowisko;

--Usuń wszystkich pracowników mających pensję mniejszą niż 1200 zł
DELETE FROM ksiegowosc.pracownicy
WHERE id_pracownika IN (
    SELECT ksiegowosc.pracownicy.id_pracownika
    FROM ksiegowosc.wynagrodzenie 
    JOIN ksiegowosc.pracownicy ON ksiegowosc.wynagrodzenie.id_pracownika = ksiegowosc.pracownicy.id_pracownika
	JOIN ksiegowosc.pensja ON ksiegowosc.wynagrodzenie.id_pensji = ksiegowosc.pensja.id_pensji
    WHERE ksiegowosc.pensja.kwota < 1200
);

SELECT *
FROM ksiegowosc.pracownicy

--Zmodyfikuj numer telefonu w tabeli pracownicy, dodając do niego kierunkowy dla Polski  w nawiasie (+48) 
/*
UPDATE ksiegowosc.pracownicy
SET telefon = '(+48)' + telefon

SELECT *
FROM ksiegowosc.pracownicy;
*/

--Zmodyfikuj atrybut telefon w tabeli pracownicy tak, aby numer oddzielony był myślnikami wg wzoru: ‘555-222-333’ 
/*
--SUBSTRING(nazwa_kolumny, znak od którego zaczynamy wybieranie, ile znakow wybieramy)

UPDATE ksiegowosc.pracownicy
SET telefon = SUBSTRING(ksiegowosc.pracownicy.telefon, 1, 5)+' '+SUBSTRING(ksiegowosc.pracownicy.telefon, 6, 3)+'-'+SUBSTRING(ksiegowosc.pracownicy.telefon, 9, 3)+'-'+SUBSTRING(ksiegowosc.pracownicy.telefon, 12, 3)
*/
SELECT *
FROM ksiegowosc.pracownicy;

--Wyświetl dane pracownika, którego nazwisko jest najdłuższe, używając dużych liter 
SELECT 
	UPPER(ksiegowosc.pracownicy.imie),
	UPPER(ksiegowosc.pracownicy.nazwisko),
	UPPER(ksiegowosc.pracownicy.adres)
FROM ksiegowosc.pracownicy
WHERE LEN(UPPER(nazwisko)) = (
    SELECT MAX(LEN(UPPER(nazwisko)))
    FROM ksiegowosc.pracownicy
	);

--Wyświetl dane pracowników i ich pensje zakodowane przy pomocy algorytmu md5

SELECT 
    HASHBYTES('MD5', ksiegowosc.pracownicy.imie) AS imie,
	HASHBYTES('MD5', ksiegowosc.pracownicy.nazwisko) AS nazwisko,
	HASHBYTES('MD5',CONVERT(VARCHAR(20), ksiegowosc.pensja.kwota)) AS pensja
FROM 
    ksiegowosc.pracownicy
JOIN 
    ksiegowosc.wynagrodzenie ON ksiegowosc.pracownicy.id_pracownika = ksiegowosc.wynagrodzenie.id_pracownika
JOIN 
    ksiegowosc.pensja ON ksiegowosc.wynagrodzenie.id_pensji = ksiegowosc.pensja.id_pensji


--Wyświetl pracowników, ich pensje oraz premie. Wykorzystaj złączenie lewostronne. 
  SELECT 
    ksiegowosc.pracownicy.imie, 
    ksiegowosc.pracownicy.nazwisko, 
    ksiegowosc.pensja.kwota AS pensja, 
    ksiegowosc.premia.kwota AS kwota_premii
FROM 
    ksiegowosc.pracownicy
LEFT JOIN 
    ksiegowosc.wynagrodzenie wyn ON ksiegowosc.pracownicy.id_pracownika = wyn.id_pracownika
LEFT JOIN 
    ksiegowosc.pensja ON wyn.id_pensji = ksiegowosc.pensja.id_pensji
LEFT JOIN 
    ksiegowosc.premia ON wyn.id_premii = ksiegowosc.premia.id_premii;

--wygeneruj raport (zapytanie), które zwróci w wyniki treść wg poniższego szablonu: 
--Pracownik Jan Nowak, w dniu 7.08.2017 otrzymał pensję całkowitą na kwotę 7540 zł, gdzie 
--wynagrodzenie zasadnicze wynosiło: 5000 zł, premia: 2000 zł, nadgodziny: 540 zł

SELECT 
    CONCAT('Pracownik ', ksiegowosc.pracownicy.imie, ' ', ksiegowosc.pracownicy.nazwisko, 
           ', w dniu ', ksiegowosc.wynagrodzenie.data_,
           ' otrzymał pensję całkowitą na kwotę ', ksiegowosc.pensja.kwota + ksiegowosc.premia.kwota,
           ' zł, gdzie wynagrodzenie zasadnicze wynosiło: ', ksiegowosc.pensja.kwota, ' zł, premia: ',
           ksiegowosc.premia.kwota, ' zł, nadgodziny: ', 
           CASE
               WHEN SUM(ksiegowosc.godziny.liczba_godzin) > 160 THEN (SUM(ksiegowosc.godziny.liczba_godzin) - 160) * 30
               ELSE 0
           END , ' zł'
    ) AS raport
FROM 
    ksiegowosc.wynagrodzenie
JOIN 
    ksiegowosc.pracownicy ON ksiegowosc.wynagrodzenie.id_pracownika = ksiegowosc.pracownicy.id_pracownika
JOIN 
    ksiegowosc.pensja ON ksiegowosc.wynagrodzenie.id_pensji = ksiegowosc.pensja.id_pensji
JOIN 
    ksiegowosc.premia ON ksiegowosc.wynagrodzenie.id_premii = ksiegowosc.premia.id_premii
JOIN 
    ksiegowosc.godziny ON ksiegowosc.wynagrodzenie.id_godziny = ksiegowosc.godziny.id_godziny
GROUP BY
    ksiegowosc.pracownicy.imie, ksiegowosc.pracownicy.nazwisko, ksiegowosc.wynagrodzenie.data_,
    ksiegowosc.pensja.kwota, ksiegowosc.premia.kwota;
