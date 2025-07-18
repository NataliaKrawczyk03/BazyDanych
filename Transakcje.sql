--1. Napisz zapytanie, które wykorzystuje transakcję (zaczyna ją), a następnie 
--aktualizuje cenę produktu o ProductID równym 680 w tabeli Production.Product
 --o 10%inastępnie zatwierdza transakcję.

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

--2.Napisz zapytanie, które zaczyna transakcję, usuwa produkt o ProductID równym
 --707 z tabeli Production. Product, ale następnie wycofuje transakcję.

SELECT * FROM Production.Product
WHERE ProductID = 707;

BEGIN TRANSACTION;

-- Usunięcie 
DELETE FROM Production.Product
WHERE ProductID = 707;

-- Sprawdzenie
SELECT * FROM Production.Product
WHERE ProductID = 707;

-- Wycofanie
ROLLBACK TRANSACTION;

--3.Napisz zapytanie, które zaczyna transakcję, dodaje nowy produkt do tabeli Production.Product, a następnie zatwierdza transakcję.

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

--4.Napisz zapytanie, które zaczyna transakcję i aktualizuje StandardCost wszystkich
 --produktów w tabeli Production.Product o 10%, jeżeli suma wszystkich
 --StandardCost po aktualizacji nie przekracza 50000. W przeciwnym razie zapytanie
 --powinno wycofać transakcję.

 BEGIN TRANSACTION;


UPDATE Production.Product
SET StandardCost = StandardCost * 1.10;

DECLARE @TotalStandardCost MONEY;

SELECT @TotalStandardCost = SUM(StandardCost) FROM Production.Product;

IF @TotalStandardCost <= 50000
BEGIN
    COMMIT;
    PRINT 'Transakcja się powiodła, łączny koszt to:'+ CAST(@TotalStandardCost AS NVARCHAR(50));
END
ELSE
BEGIN
    ROLLBACK;
    PRINT 'Transakcja się nie powiodła, łączny koszt to: ' + CAST(@TotalStandardCost AS NVARCHAR(50));
END;


--5.Napisz zapytanie SQL, które zaczyna transakcję i próbuje dodać nowy produkt do
 --tabeli Production.Product. Jeśli ProductNumber już istnieje w tabeli, zapytanie
 --powinno wycofać transakcję.

BEGIN TRANSACTION;

DECLARE @ProductNumber NVARCHAR(25);
SET @ProductNumber = 'AR-5381'; 


IF EXISTS (SELECT * FROM Production.Product WHERE ProductNumber = @ProductNumber)
BEGIN
    
    ROLLBACK;
    PRINT 'Transakcja się nie powiodła: ProductNumber już istnieje.';
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
    PRINT 'Transakcja się powiodła: Produkt został dodany.';
END;


--6.Napisz zapytanie SQL, które zaczyna transakcję i aktualizuje wartość OrderQty
 --dla każdego zamówienia w tabeli Sales.SalesOrderDetail. Jeżeli którykolwiek z
 --zamówień maOrderQty równą 0, zapytanie powinno wycofać transakcję.

BEGIN TRANSACTION;

IF EXISTS (SELECT * FROM Sales.SalesOrderDetail WHERE OrderQty = 0)
BEGIN
    ROLLBACK;
    PRINT 'Transakcja się nie powiodła: Jeden z rekordów ma OrderQty równą 0.';
END
ELSE
BEGIN
    UPDATE Sales.SalesOrderDetail
    SET OrderQty = OrderQty + 1  ; -- przykładowa aktualizacja

    COMMIT;
    PRINT 'Transakcja się powiodła: OrderQty zostały zaktualizowane.';
END;


--7.Napisz zapytanie SQL, które zaczyna transakcję i usuwa wszystkie produkty,
 --których StandardCost jest wyższy niż średni koszt wszystkich produktów w tabeli
 --Production.Product. Jeżeli liczba produktów do usunięcia przekracza 10,
 --zapytanie powinno wycofać transakcję.

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
    PRINT 'Transakcja się nie powiodła: Liczba produktów do usunięcia przekracza 10. Wynosi:'+ CAST(@ProductsToDeleteCount AS NVARCHAR(50));
END
ELSE
BEGIN
    DELETE FROM Production.Product
    WHERE StandardCost > @AverageStandardCost;

    COMMIT;
    PRINT 'Transakcja się powiodła: Produkty zostały usunięte.';
END;
