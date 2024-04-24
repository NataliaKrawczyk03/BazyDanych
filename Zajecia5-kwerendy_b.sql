USE firma2

--a.Zmodyfikuj numer telefonu w tabeli pracownicy, dodaj¹c do niego kierunkowy dla Polski  w nawiasie (+48) 
/*
UPDATE ksiegowosc.pracownicy
SET telefon = '(+48)' + telefon

SELECT *
FROM ksiegowosc.pracownicy;
*/

--b.Zmodyfikuj atrybut telefon w tabeli pracownicy tak, aby numer oddzielony by³ myœlnikami wg wzoru: ‘555-222-333’ 
/*
--SUBSTRING(nazwa_kolumny, znak od którego zaczynamy wybieranie, ile znakow wybieramy)

UPDATE ksiegowosc.pracownicy
SET telefon = SUBSTRING(ksiegowosc.pracownicy.telefon, 1, 5)+' '+SUBSTRING(ksiegowosc.pracownicy.telefon, 6, 3)+'-'+SUBSTRING(ksiegowosc.pracownicy.telefon, 9, 3)+'-'+SUBSTRING(ksiegowosc.pracownicy.telefon, 12, 3)
*/
SELECT *
FROM ksiegowosc.pracownicy;

--c.Wyœwietl dane pracownika, którego nazwisko jest najd³u¿sze, u¿ywaj¹c du¿ych liter 
SELECT 
	UPPER(ksiegowosc.pracownicy.imie),
	UPPER(ksiegowosc.pracownicy.nazwisko),
	UPPER(ksiegowosc.pracownicy.adres)
FROM ksiegowosc.pracownicy
WHERE LEN(UPPER(nazwisko)) = (
    SELECT MAX(LEN(UPPER(nazwisko)))
    FROM ksiegowosc.pracownicy
	);

--d. Wyœwietl dane pracowników i ich pensje zakodowane przy pomocy algorytmu md5

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




--e.Wyœwietl pracowników, ich pensje oraz premie. Wykorzystaj z³¹czenie lewostronne. 
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

--f. wygeneruj raport (zapytanie), które zwróci w wyniki treœæ wg poni¿szego szablonu: 
--Pracownik Jan Nowak, w dniu 7.08.2017 otrzyma³ pensjê ca³kowit¹ na kwotê 7540 z³, gdzie 
--wynagrodzenie zasadnicze wynosi³o: 5000 z³, premia: 2000 z³, nadgodziny: 540 z³

SELECT 
    CONCAT('Pracownik ', ksiegowosc.pracownicy.imie, ' ', ksiegowosc.pracownicy.nazwisko, 
           ', w dniu ', ksiegowosc.wynagrodzenie.data_,
           ' otrzyma³ pensjê ca³kowit¹ na kwotê ', ksiegowosc.pensja.kwota + ksiegowosc.premia.kwota,
           ' z³, gdzie wynagrodzenie zasadnicze wynosi³o: ', ksiegowosc.pensja.kwota, ' z³, premia: ',
           ksiegowosc.premia.kwota, ' z³, nadgodziny: ', 
           CASE
               WHEN SUM(ksiegowosc.godziny.liczba_godzin) > 160 THEN (SUM(ksiegowosc.godziny.liczba_godzin) - 160) * 30
               ELSE 0
           END , ' z³'
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

