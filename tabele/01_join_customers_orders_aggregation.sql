CREATE TABLE Customers (
    CustomerID INT,
    Name VARCHAR(100),
    City VARCHAR(100)
);

CREATE TABLE Orders (
    OrderID INT,
    CustomerID INT,
    OrderDate DATE,
    Amount DECIMAL(10,2)
);