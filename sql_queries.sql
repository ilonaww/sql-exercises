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

-- Pokaż, którzy klienci wydają więcej niż średnia wartość wszystkich klientów
with CustomerAmount as (select b.CustomerID, b.Name, sum(a.amount) as TotalAmount
from Orders a
left join Customers b on b.CustomerID = a.CustomerID
group by b.CustomerID, b.Name)
select Name as CustomerName, TotalAmount 
from CustomerAmount 
where TotalAmount > (select avg(TotalAmount) as AvgAmount from CustomerAmount)
order by TotalAmount DESC

-- Pokaż TOP 3 klientów według wydatków
select TOP 3 a.Name as CustomerName, sum(ISNULL(b.amount,0)) as TotalSpent
from Customers a
left join Orders b on a.CustomerID = b.CustomerID
group by a.CustomerID, a.Name
order by TotalSpent DESC

-- Pokaż klientów, którzy nie złożyli żadnego zamówienia
select a.Name as CustomerName, a.City
from Customers a
left join Orders b on a.CustomerID = b.CustomerID
where b.OrderID  is null

-- Pokaż dla każdego miasta: ile klientów jest; ile wydali łącznie
select a.City, count(DISTINCT a.CustomerID) as Customwers, isnull(sum(b.amount),0) as TotalAmount
from Customers a
left join Orders b on b.CustomerID = a.CustomerID
group by a.City

-- Dla każdego miasta pokaż najlepszego klienta (TOP 1) wg wydatków
with Citeis as (select a.City, a.Name as CustomerName, sum(b.Amount) as TotalSpent,
ROW_NUMBER() Over( partition by City order by sum(b.Amount) DESC) as Nr
from Customers a
left join Orders b on a.CustomerID = b.CustomerID
group by a.City, a.Name)

select a.City, a.CustomerName, a.TotalSpent
from Citeis a
where Nr = 1


-- Policzenie dla każdego klienta ile wydał i nadanie rankingu (od największego wydatku)
with CustomerTotal as (select a.CustomerID, a.Name as CustomerName, sum(b.Amount) as TotalSpent 
from Customers a
left join Orders b on a.CustomerID = b.CustomerID
group by a.CustomerID, a.Name )

select CustomerName, TotalSpent, Dense_Rank() over (order by TotalSpent DESC) as CustomerRank
from CustomerTotal



--Dla każdego klienta pokaż: miesiąc (i rok), łączną kwotę wydaną w danym miesiącu, wydatki z poprzedniego miesiąca, różnicę / porównanie (logicznie przez LAG)
with CustomersTotal as (select a.CustomerID, a.Name as CustomerName, year(b.OrderDate) * 100 + month(b.OrderDate) as YearMonth, sum(b.Amount) as TotalSpent 
from Customers a
inner join Orders b on a.CustomerID = b.CustomerID
group by year(b.OrderDate) * 100 + month(b.OrderDate), a.CustomerID, a.Name
)

select CustomerName, YearMonth, TotalSpent, lag(TotalSpent) over (PARTITION BY CustomerID order by YearMonth) as TotalSpentPreviousMonth
from CustomersTotal


--Dla każdego klienta pokaż ile wydał od początku historii do danego miesiąca
with CustomerSum as (select a.CustomerID, a.Name as CustomerName, YEAR(b.OrderDate) * 100 + MONTH(b.OrderDate) as YearMonth, sum(b.Amount) as TotalSpent 
from Customers a 
left join Orders b on a.CustomerID = b.CustomerID
group by a.CustomerID, a.Name, YEAR(b.OrderDate) * 100 + MONTH(b.OrderDate))

select CustomerName, YearMonth, TotalSpent, sum(TotalSpent) over (partition by CustomerID order by YearMonth) as RunningTotal
from CustomerSum