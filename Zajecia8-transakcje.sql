--1. Napisz zapytanie, kt�re wykorzystuje transakcj� (zaczyna j�), a nast�pnie 
--aktualizuje cen� produktu o ProductID r�wnym 680 w tabeli Production.Product
 --o 10%inast�pnie zatwierdza transakcj�.

USE AdventureWorks2022;
 
SELECT 
	ProductID,
	ListPrice,
	Name
FROM Production.Product
WHERE ProductID = 680;

BEGIN TRANSACTION; --rozpoczecie transjacji

UPDATE Production.Product
SET ListPrice = ListPrice * 1.10
WHERE ProductID = 680;

COMMIT TRANSACTION; --zatwierdzenie transakcji

SELECT 
	ProductID,
	ListPrice,
	Name
FROM Production.Product
WHERE ProductID = 680;

--2.Napisz zapytanie, kt�re zaczyna transakcj�, usuwa produkt o ProductID r�wnym
 --707 z tabeli Production. Product, ale nast�pnie wycofuje transakcj�.

SELECT * FROM Production.Product
WHERE ProductID = 707;

BEGIN TRANSACTION;

-- Usuni�cie 
DELETE FROM Production.Product
WHERE ProductID = 707;

-- Sprawdzenie
SELECT * FROM Production.Product
WHERE ProductID = 707;

-- Wycofanie
ROLLBACK TRANSACTION;

--3.Napisz zapytanie, kt�re zaczyna transakcj�, dodaje nowy produkt do tabeli Production.Product, a nast�pnie zatwierdza transakcj�.

BEGIN TRANSACTION;

SELECT *
FROM Production.Product
WHERE Name = 'New Product';

INSERT INTO Production.Product (
    Name,
    ProductNumber,
    MakeFlag,
    FinishedGoodsFlag,
    Color,
    SafetyStockLevel,
    ReorderPoint,
    StandardCost,
    ListPrice,
    Size,
    SizeUnitMeasureCode,
    WeightUnitMeasureCode,
    Weight,
    DaysToManufacture,
    ProductLine,
    Class,
    Style,
    ProductSubcategoryID,
    ProductModelID,
    SellStartDate,
    SellEndDate,
    DiscontinuedDate,
    rowguid,
    ModifiedDate
) VALUES (
    'New Product',  
    'NP-001',  
    1, 
	1,
    'Red',   
    100,           
    50,                 
    10.00,              
    20.00,             
    'L',         
    'CM',         
    'G',         
    1.00,    
    5,    
    'T', 
    'H',  
    'M', 
    1,  
    1,                  
    GETDATE(),           
    NULL,                
    NULL,
    NEWID(),
    GETDATE()

);

SELECT *
FROM Production.Product
WHERE Name = 'New Product';

COMMIT TRANSACTION;

--4.Napisz zapytanie, kt�re zaczyna transakcj� i aktualizuje StandardCost wszystkich
 --produkt�w w tabeli Production.Product o 10%, je�eli suma wszystkich
 --StandardCost po aktualizacji nie przekracza 50000. W przeciwnym razie zapytanie
 --powinno wycofa� transakcj�.

 BEGIN TRANSACTION;


UPDATE Production.Product
SET StandardCost = StandardCost * 1.10;

DECLARE @TotalStandardCost MONEY;

SELECT @TotalStandardCost = SUM(StandardCost) FROM Production.Product;

IF @TotalStandardCost <= 50000
BEGIN
    COMMIT;
    PRINT 'Transakcja si� powiod�a, ��czny koszt to:'+ CAST(@TotalStandardCost AS NVARCHAR(50));
END
ELSE
BEGIN
    ROLLBACK;
    PRINT 'Transakcja si� nie powiod�a, ��czny koszt to: ' + CAST(@TotalStandardCost AS NVARCHAR(50));
END;


--5.Napisz zapytanie SQL, kt�re zaczyna transakcj� i pr�buje doda� nowy produkt do
 --tabeli Production.Product. Je�li ProductNumber ju� istnieje w tabeli, zapytanie
 --powinno wycofa� transakcj�.

BEGIN TRANSACTION;

DECLARE @ProductNumber NVARCHAR(25);
SET @ProductNumber = 'AR-5381'; 


IF EXISTS (SELECT * FROM Production.Product WHERE ProductNumber = @ProductNumber)
BEGIN
    
    ROLLBACK;
    PRINT 'Transakcja si� nie powiod�a: ProductNumber ju� istnieje.';
END
ELSE
BEGIN
    INSERT INTO Production.Product (
        Name,
        ProductNumber,
        MakeFlag,
        FinishedGoodsFlag,
        Color,
        SafetyStockLevel,
        ReorderPoint,
        StandardCost,
        ListPrice,
        Size,
        SizeUnitMeasureCode,
        WeightUnitMeasureCode,
        Weight,
        DaysToManufacture,
        ProductLine,
        Class,
        Style,
        ProductSubcategoryID,
        ProductModelID,
        SellStartDate,
        SellEndDate,
        DiscontinuedDate,
        rowguid,
        ModifiedDate
    ) VALUES (
        'New Product',  
		@ProductNumber,  
		1, 
		1,
		'Red',   
		100,           
		50,                 
		10.00,              
		20.00,             
		'L',         
		'CM',         
		'G',         
		1.00,    
		5,    
		'T', 
		'H',  
		'M', 
		1,  
		1,                  
		GETDATE(),           
		NULL,                
		NULL,
		NEWID(),
		GETDATE()     
    );
   
    ROLLBACK;
    PRINT 'Transakcja si� powiod�a: Produkt zosta� dodany.';
END;


--6.Napisz zapytanie SQL, kt�re zaczyna transakcj� i aktualizuje warto�� OrderQty
 --dla ka�dego zam�wienia w tabeli Sales.SalesOrderDetail. Je�eli kt�rykolwiek z
 --zam�wie� maOrderQty r�wn� 0, zapytanie powinno wycofa� transakcj�.

BEGIN TRANSACTION;

IF EXISTS (SELECT * FROM Sales.SalesOrderDetail WHERE OrderQty = 0)
BEGIN
    ROLLBACK;
    PRINT 'Transakcja si� nie powiod�a: Jeden z rekord�w ma OrderQty r�wn� 0.';
END
ELSE
BEGIN
    UPDATE Sales.SalesOrderDetail
    SET OrderQty = OrderQty + 1  ; -- przyk�adowa aktualizacja

    COMMIT;
    PRINT 'Transakcja si� powiod�a: OrderQty zosta�y zaktualizowane.';
END;


--7.Napisz zapytanie SQL, kt�re zaczyna transakcj� i usuwa wszystkie produkty,
 --kt�rych StandardCost jest wy�szy ni� �redni koszt wszystkich produkt�w w tabeli
 --Production.Product. Je�eli liczba produkt�w do usuni�cia przekracza 10,
 --zapytanie powinno wycofa� transakcj�.

BEGIN TRANSACTION;

DECLARE @AverageStandardCost MONEY;
SELECT @AverageStandardCost = AVG(StandardCost) FROM Production.Product;

DECLARE @ProductsToDeleteCount INT;
SELECT @ProductsToDeleteCount = COUNT(*) --zliczenie wszystkich 
FROM Production.Product
WHERE StandardCost > @AverageStandardCost;

IF @ProductsToDeleteCount > 10
BEGIN
    ROLLBACK;
    PRINT 'Transakcja si� nie powiod�a: Liczba produkt�w do usuni�cia przekracza 10. Wynosi:'+ CAST(@ProductsToDeleteCount AS NVARCHAR(50));
END
ELSE
BEGIN
    DELETE FROM Production.Product
    WHERE StandardCost > @AverageStandardCost;

    COMMIT;
    PRINT 'Transakcja si� powiod�a: Produkty zosta�y usuni�te.';
END;
