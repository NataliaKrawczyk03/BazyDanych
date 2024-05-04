--USE AdventureWorks2022
--GO

--1.Napisz procedur� wypisuj�c� do konsoli ci�g Fibonacciego. Procedura musi przyjmowa� jako argument wej�ciowy liczb� n. Generowanie ci�gu Fibonacciego musi zosta� zaimplementowane jako osobna funkcja, wywo�ywana przez procedur�. 

--@cos deklaracja zmiennej
--dbo. database owner domy�lny schemat dla bazy danych

/*
--funkcja
CREATE FUNCTION dbo.Fibonacci2(@n INT)
RETURNS VARCHAR(200)
AS
BEGIN
    DECLARE @a INT = 0;
    DECLARE @b INT = 1;
    DECLARE @result VARCHAR(255) = '';

    WHILE @n > 0
    BEGIN
        SET @result = @result + CAST(@a AS VARCHAR(10)) + ', '; --CAST zamiana typ�w zmiennych
        SET @a = @a + @b;
        SET @b = @a - @b;
        SET @n = @n - 1;
    END;

    RETURN @result;
END;
GO

--procedura
CREATE PROCEDURE dbo.Fibonacciciag2(@n INT)
AS
BEGIN
    DECLARE @ciag VARCHAR(255);
    SET @ciag = dbo.Fibonacci2(@n);
    SELECT 'Ciag Fibonacciego do ' + CAST(@n AS VARCHAR(10)) + ': ' + @ciag AS result;
END;
GO
*/
EXEC dbo.Fibonacciciag2 4;


--2.Napisz trigger DML, kt�ry po wprowadzeniu danych do tabeli Persons zmodyfikuje nazwisko tak, aby by�o napisane du�ymi literami.  
--inserted to specjalna tabela, kt�ra jest dost�pna wewn�trz triggera i zawiera wiersze dodane przez ostatni� operacj� INSERT

/*CREATE TRIGGER duzenazwisko
ON Person.Person
AFTER INSERT
AS
BEGIN

    UPDATE Person.Person
    SET LastName = UPPER(inserted.LastName)
    FROM Person.Person
    JOIN inserted ON Person.Person.BusinessEntityID = inserted.BusinessEntityID;
END;
*/

--z powodu prblemu ze wstawieniem wartosci do kolumny Demographics testuje trigger na innej tabeli

/*
CREATE TRIGGER zamiananaduze
ON Person.ContactType
AFTER INSERT
AS
BEGIN

    UPDATE Person.ContactType
    SET Name = UPPER(inserted.Name)
    FROM Person.ContactType
    JOIN inserted ON Person.ContactType.ContactTypeID = inserted.ContactTypeID;
END;
*/

/*
INSERT INTO Person.ContactType (Name,ModifiedDate )
VALUES ('ktos','02.03.2024');
*/

/*
SELECT * 
FROM Person.ContactType
WHERE Person.ContactType.Name = 'ktos';
*/

--3.Przygotuj trigger �taxRateMonitoring�, kt�ry wy�wietli komunikat o b��dzie, je�eli nast�pi zmiana warto�ci w polu �TaxRate� o wi�cej ni� 30%.

/*
CREATE TRIGGER taxRateMonitoring
ON Sales.SalesTaxRate
AFTER UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN deleted d ON i.SalesTaxRateID = d.SalesTaxRateID
        WHERE ABS(i.TaxRate - d.TaxRate) / d.TaxRate > 0.3
    )
    BEGIN
         DECLARE @ErrorMessage NVARCHAR(1000);
         SET @ErrorMessage = 'Zmiana warto�ci w polu TaxRate o wi�cej ni� 30'
         RAISERROR(@ErrorMessage, 16, 1);
    END
END;
*/

/*
UPDATE Sales.SalesTaxRate
SET TaxRate = TaxRate * 1.4 
WHERE SalesTaxRateID = 1
*/