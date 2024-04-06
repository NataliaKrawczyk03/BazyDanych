SELECT 
    data_,
    DATEPART(WEEKDAY, data_) AS dzien_tygodnia,
    DATEPART(MONTH, data_) AS miesiac
FROM rozliczenia.godziny;