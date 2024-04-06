EXEC sp_rename 'rozliczenia.pensje.kwota', 'kwota_brutto', 'COLUMN';

ALTER TABLE rozliczenia.pensje
ADD kwota_netto decimal(10,2);

UPDATE rozliczenia.pensje
SET kwota_netto = ROUND(kwota_brutto * 0.75, 2);