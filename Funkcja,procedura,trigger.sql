--USE AdventureWorks2022
--GO

--1.Napisz procedurê wypisuj¹c¹ do konsoli ci¹g Fibonacciego. Procedura musi przyjmowaæ jako argument wejœciowy liczbê n. Generowanie ci¹gu Fibonacciego musi zostaæ zaimplementowane jako osobna funkcja, wywo³ywana przez procedurê. 

--@cos deklaracja zmiennej
--dbo. database owner domyœlny schemat dla bazy danych

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
        SET @result = @result + CAST(@a AS VARCHAR(10)) + ', '; --CAST zamiana typów zmiennych
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


--2.Napisz trigger DML, który po wprowadzeniu danych do tabeli Persons zmodyfikuje nazwisko tak, aby by³o napisane du¿ymi literami.  
--inserted to specjalna tabela, która jest dostêpna wewn¹trz triggera i zawiera wiersze dodane przez ostatni¹ operacjê INSERT

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

--3.Przygotuj trigger ‘taxRateMonitoring’, który wyœwietli komunikat o b³êdzie, je¿eli nast¹pi zmiana wartoœci w polu ‘TaxRate’ o wiêcej ni¿ 30%.

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
         SET @ErrorMessage = 'Zmiana wartoœci w polu TaxRate o wiêcej ni¿ 30'
         RAISERROR(@ErrorMessage, 16, 1);
    END
END;
*/

/*
UPDATE Sales.SalesTaxRate
SET TaxRate = TaxRate * 1.4 
WHERE SalesTaxRateID = 1
*/
