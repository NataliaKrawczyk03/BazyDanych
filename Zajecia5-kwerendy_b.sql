USE firma2

--a.Zmodyfikuj numer telefonu w tabeli pracownicy, dodaj�c do niego kierunkowy dla Polski  w nawiasie (+48) 
/*
UPDATE ksiegowosc.pracownicy
SET telefon = '(+48)' + telefon

SELECT *
FROM ksiegowosc.pracownicy;
*/

--b.Zmodyfikuj atrybut telefon w tabeli pracownicy tak, aby numer oddzielony by� my�lnikami wg wzoru: �555-222-333� 
/*
--SUBSTRING(nazwa_kolumny, znak od kt�rego zaczynamy wybieranie, ile znakow wybieramy)

UPDATE ksiegowosc.pracownicy
SET telefon = SUBSTRING(ksiegowosc.pracownicy.telefon, 1, 5)+' '+SUBSTRING(ksiegowosc.pracownicy.telefon, 6, 3)+'-'+SUBSTRING(ksiegowosc.pracownicy.telefon, 9, 3)+'-'+SUBSTRING(ksiegowosc.pracownicy.telefon, 12, 3)
*/
SELECT *
FROM ksiegowosc.pracownicy;

--c.Wy�wietl dane pracownika, kt�rego nazwisko jest najd�u�sze, u�ywaj�c du�ych liter 
SELECT 
	UPPER(ksiegowosc.pracownicy.imie),
	UPPER(ksiegowosc.pracownicy.nazwisko),
	UPPER(ksiegowosc.pracownicy.adres)
FROM ksiegowosc.pracownicy
WHERE LEN(UPPER(nazwisko)) = (
    SELECT MAX(LEN(UPPER(nazwisko)))
    FROM ksiegowosc.pracownicy
	);

--d. Wy�wietl dane pracownik�w i ich pensje zakodowane przy pomocy algorytmu md5

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




--e.Wy�wietl pracownik�w, ich pensje oraz premie. Wykorzystaj z��czenie lewostronne. 
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

--f. wygeneruj raport (zapytanie), kt�re zwr�ci w wyniki tre�� wg poni�szego szablonu: 
--Pracownik Jan Nowak, w dniu 7.08.2017 otrzyma� pensj� ca�kowit� na kwot� 7540 z�, gdzie 
--wynagrodzenie zasadnicze wynosi�o: 5000 z�, premia: 2000 z�, nadgodziny: 540 z�

SELECT 
    CONCAT('Pracownik ', ksiegowosc.pracownicy.imie, ' ', ksiegowosc.pracownicy.nazwisko, 
           ', w dniu ', ksiegowosc.wynagrodzenie.data_,
           ' otrzyma� pensj� ca�kowit� na kwot� ', ksiegowosc.pensja.kwota + ksiegowosc.premia.kwota,
           ' z�, gdzie wynagrodzenie zasadnicze wynosi�o: ', ksiegowosc.pensja.kwota, ' z�, premia: ',
           ksiegowosc.premia.kwota, ' z�, nadgodziny: ', 
           CASE
               WHEN SUM(ksiegowosc.godziny.liczba_godzin) > 160 THEN (SUM(ksiegowosc.godziny.liczba_godzin) - 160) * 30
               ELSE 0
           END , ' z�'
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

