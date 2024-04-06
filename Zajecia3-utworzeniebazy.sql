CREATE DATABASE firma;
GO

USE firma;
GO

CREATE SCHEMA rozliczenia;
GO

CREATE TABLE rozliczenia.pracownicy
(
    id_pracownika int PRIMARY KEY,
    imie varchar(30) NOT NULL,
    nazwisko varchar(30) NOT NULL,
    adres varchar(100) NOT NULL,
    telefon varchar(20) NOT NULL
);

CREATE TABLE rozliczenia.godziny
(
    id_godziny int PRIMARY KEY,
    data_ date NOT NULL,
    liczba_godzin int NOT NULL,
    id_pracownika int NOT NULL
);

CREATE TABLE rozliczenia.pensje
(
    id_pensji int PRIMARY KEY,
    stanowisko varchar(50) NOT NULL,
    kwota decimal(10,2) NOT NULL,
    id_premii int NOT NULL
);

CREATE TABLE rozliczenia.premie
(
    id_premii int PRIMARY KEY,
    rodzaj varchar(30) NOT NULL,
    kwota decimal(10,2) NOT NULL
);

GO

ALTER TABLE rozliczenia.godziny
ADD CONSTRAINT FK_godziny_pracownicy FOREIGN KEY (id_pracownika) REFERENCES rozliczenia.pracownicy(id_pracownika);

GO

ALTER TABLE rozliczenia.pensje
ADD CONSTRAINT FK_pensje_premie FOREIGN KEY (id_premii) REFERENCES rozliczenia.premie(id_premii);

GO

INSERT INTO rozliczenia.pracownicy (id_pracownika, imie, nazwisko, adres, telefon)
VALUES 
(1, 'Jan', 'Kowalski', 'ul. Wiejska 1', '123456789'),
(2, 'Anna', 'Nowak', 'ul. Kwiatowa 5', '987654321'),
(3, 'Piotr', 'Wiœniewski', 'ul. Leœna 10', '555444333'),
(4, 'Maria', 'D¹browska', 'ul. Szkolna 7', '111222333'),
(5, 'Adam', 'Lis', 'ul. Parkowa 3', '777888999'),
(6, 'Karolina', 'Zaj¹c', 'ul. Polna 12', '444555666'),
(7, 'Kamil', 'Wójcik', 'ul. Zielona 8', '999888777'),
(8, 'Ewa', 'Kaczmarek', 'ul. Ogrodowa 15', '333222111'),
(9, 'Tomasz', 'Wojciechowski', 'ul. Miodowa 9', '666777888'),
(10, 'Aleksandra', 'Jankowska', 'ul. Nowa 6', '222333444');

GO

INSERT INTO rozliczenia.godziny (id_godziny, data_, liczba_godzin, id_pracownika)
VALUES 
(1, '2024-04-01', 8, 1),
(2, '2024-04-01', 7, 2),
(3, '2024-04-02', 6, 3),
(4, '2024-04-02', 8, 4),
(5, '2024-04-03', 8, 5),
(6, '2024-04-03', 7, 6),
(7, '2024-04-04', 6, 7),
(8, '2024-04-04', 8, 8),
(9, '2024-04-05', 8, 9),
(10, '2024-04-05', 7, 10);

GO

INSERT INTO rozliczenia.premie (id_premii, rodzaj, kwota)
VALUES 
(1, 'Premia kwartalna', 500.00),
(2, 'Premia za wyniki', 700.00),
(3, 'Premia roczna', 1000.00),
(4, 'Premia uznaniowa', 800.00),
(5, 'Premia za sta¿ pracy', 600.00),
(6, 'Premia za osi¹gniêcia', 900.00),
(7, 'Premia œwi¹teczna', 400.00),
(8, 'Premia motywacyjna', 600.00),
(9, 'Premia jubileuszowa', 1200.00),
(10, 'Premia œwi¹teczna', 400.00);

GO

INSERT INTO rozliczenia.pensje (id_pensji, stanowisko, kwota, id_premii)
VALUES 
(1, 'Specjalista ds. sprzeda¿y', 4500.00, 1),
(2, 'Ksiêgowy', 3800.00, 2),
(3, 'Informatyk', 5000.00, 3),
(4, 'Asystentka biura', 3200.00, 4),
(5, 'Administrator systemów', 5500.00, 5),
(6, 'Doradca klienta', 4000.00, 6),
(7, 'Analityk finansowy', 4800.00, 7),
(8, 'Kierownik magazynu', 4200.00, 8),
(9, 'Specjalista ds. HR', 4700.00, 9),
(10, 'Pracownik produkcji', 3500.00, 10);
