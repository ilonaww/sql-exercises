-- Pokaż wszystkie zamówienia w formie: klient, produkt, data, kwota
select a.Name as CustomerName, c.ProductName, b.OrderDate, b.Amount 
from Customers a 
left join Orders b on a.CustomerID = b.CustomerID
left join Products c on b.ProductID = c.ProductID

-- Policz ile każdy klient wydał łącznie
select a.Name as CustomerName, isnull(sum(b.Amount), 0) as TotalSpent
from Customers a 
left join Orders b on a.CustomerID = b.CustomerID
group by a.CustomerID, a.Name

-- Znajdź klienta, który wydał najwięcej
with Clients as(select a.Name, isnull(sum(b.Amount), 0) as TotalSum
from Customers a 
left join Orders b on b.CustomerID = a.CustomerID
group by a.CustomerID, a.Name)
select top 1 Name,TotalSum 
from Clients 
order by TotalSum DESC

-- Pokaż ile zamówień ma każdy produkt
select b.ProductName, count(a.orderID) as OrderCount
from Products b  
left join Orders a on a.ProductID = b.ProductID
group by b.ProductName

-- Pokaż, którzy klienci wydają WIĘCEJ niż średnia wartość wszystkich klientów
with CustomerAmount as (select b.CustomerID, b.Name, sum(a.amount) as TotalAmount
from Orders a
left join Customers b on b.CustomerID = a.CustomerID
group by b.CustomerID, b.Name)
select Name as CustomerName, TotalAmount 
from CustomerAmount 
where TotalAmount > (select avg(TotalAmount) as AvgAmount from CustomerAmount)
order by TotalAmount DESC

