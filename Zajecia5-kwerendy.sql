USE firma2

--k.Zlicz i pogrupuj pracowników wed³ug pola ‘stanowisko’. 
SELECT
    ksiegowosc.pensja.stanowisko,
    COUNT(*) AS liczba_pracownikow
FROM
    ksiegowosc.pensja
GROUP BY
    ksiegowosc.pensja.stanowisko;

--i.) Policz œredni¹, minimaln¹ i maksymaln¹ p³acê dla stanowiska ‘kierownik’
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

--m.Policz sumê wszystkich wynagrodzeñ. 
SELECT
	SUM(ksiegowosc.pensja.kwota) AS suma_wynagrodzen
FROM
	ksiegowosc.pensja;

--n.Policz sumê wynagrodzeñ w ramach danego stanowiska
SELECT
	ksiegowosc.pensja.stanowisko,
	SUM(ksiegowosc.pensja.kwota) AS suma_wynagrodzen
FROM
	ksiegowosc.pensja
GROUP BY
	ksiegowosc.pensja.stanowisko;

--o.Wyznacz liczbê premii przyznanych dla pracowników danego stanowiska
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

--p.Usuñ wszystkich pracowników maj¹cych pensjê mniejsz¹ ni¿ 1200 z³
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
