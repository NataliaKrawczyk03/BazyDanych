USE firma2

-- a.Wy�wietl tylko id pracownika oraz jego nazwisko. 
SELECT id_pracownika, nazwisko
FROM ksiegowosc.pracownicy;

--b.Wy�wietl pracownik�w kt�rych p�aca jest wi�ksza niz 1000
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

--c.Wy�wietl pracownik�w nieposiadaj�cych premii kt�rych p�aca jest wieksza niz 2000
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

--d.Wy�wietl pracownik�w, kt�rych pierwsza litera imienia zaczyna si� na liter� �J�. 
SELECT id_pracownika, imie , nazwisko
FROM ksiegowosc.pracownicy
WHERE imie LIKE 'J%'; -- % - dowolny ciag znakow 

--e. Wy�wietl pracownik�w, kt�rych nazwisko zawiera liter� �n� oraz imi� ko�czy si� na liter� �a�. 
SELECT id_pracownika, imie , nazwisko
FROM ksiegowosc.pracownicy
WHERE imie LIKE '%a' AND nazwisko LIKE '%n%';

--f.Wy�wietl imi� i nazwisko pracownik�w oraz liczb� ich nadgodzin, przyjmuj�c, i� standardowy czas pracy to 160 h miesi�cznie. 
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

--g.Imie i nazwisko pracownikow ktorych pensja jest w przedziale 1500-3000
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

--h.Wy�wietl imi� i nazwisko pracownik�w, kt�rzy pracowali w nadgodzinach i nie otrzymali premii.
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

--i.Uszereguj pracownikow wedlug pensji
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

--j.Uszereguj pracownikow wedlug pensji i premii malejaco
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