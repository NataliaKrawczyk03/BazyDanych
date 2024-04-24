USE firma2

--k.Zlicz i pogrupuj pracownik�w wed�ug pola �stanowisko�. 
SELECT
    ksiegowosc.pensja.stanowisko,
    COUNT(*) AS liczba_pracownikow
FROM
    ksiegowosc.pensja
GROUP BY
    ksiegowosc.pensja.stanowisko;

--i.) Policz �redni�, minimaln� i maksymaln� p�ac� dla stanowiska �kierownik�
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

--m.Policz sum� wszystkich wynagrodze�. 
SELECT
	SUM(ksiegowosc.pensja.kwota) AS suma_wynagrodzen
FROM
	ksiegowosc.pensja;

--n.Policz sum� wynagrodze� w ramach danego stanowiska
SELECT
	ksiegowosc.pensja.stanowisko,
	SUM(ksiegowosc.pensja.kwota) AS suma_wynagrodzen
FROM
	ksiegowosc.pensja
GROUP BY
	ksiegowosc.pensja.stanowisko;

--o.Wyznacz liczb� premii przyznanych dla pracownik�w danego stanowiska
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

--p.Usu� wszystkich pracownik�w maj�cych pensj� mniejsz� ni� 1200 z�
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
