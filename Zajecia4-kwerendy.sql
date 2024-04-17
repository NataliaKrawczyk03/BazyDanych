USE firma2

-- a.Wyœwietl tylko id pracownika oraz jego nazwisko. 
SELECT id_pracownika, nazwisko
FROM ksiegowosc.pracownicy;

--b.Wyœwietl pracowników których p³aca jest wiêksza niz 1000
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

--c.Wyœwietl pracowników nieposiadaj¹cych premii których p³aca jest wieksza niz 2000
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

--d.Wyœwietl pracowników, których pierwsza litera imienia zaczyna siê na literê ‘J’. 
SELECT id_pracownika, imie , nazwisko
FROM ksiegowosc.pracownicy
WHERE imie LIKE 'J%'; -- % - dowolny ciag znakow 

--e. Wyœwietl pracowników, których nazwisko zawiera literê ‘n’ oraz imiê koñczy siê na literê ‘a’. 
SELECT id_pracownika, imie , nazwisko
FROM ksiegowosc.pracownicy
WHERE imie LIKE '%a' AND nazwisko LIKE '%n%';

--f.Wyœwietl imiê i nazwisko pracowników oraz liczbê ich nadgodzin, przyjmuj¹c, i¿ standardowy czas pracy to 160 h miesiêcznie. 
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

--h.Wyœwietl imiê i nazwisko pracowników, którzy pracowali w nadgodzinach i nie otrzymali premii.
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