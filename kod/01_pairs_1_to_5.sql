-- Rozwiązanie generuje wszystkie pary (A, B) z zakresu 1–5 spełniające warunki A ≤ B oraz A + B ≤ 5 przy użyciu rekurencyjnego CTE i JOIN-ów.
with Liczby as (
	Select 1 as n
	Union all
	select n + 1
	From Liczby
	where n < 6)

	SELECT a.N AS A, b.N AS B
	from Liczby a 
	join Liczby b on (a.n <= b.n) and (a.n+b.n <= 5) 

