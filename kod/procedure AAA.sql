/*
    Zadanie polega na stworzeniu procedury T-SQL zgodnej z SQL Server 2008,
    która generuje unikalne kombinacje dodatnich liczb całkowitych.

    Procedura przyjmuje dwa parametry:
    - @CountNumbers -> liczba elementów w kombinacji
    - @TargetSum    -> suma wszystkich elementów

    Wyniki powinny być zwracane w postaci liczb oddzielonych znakiem '+'.

    Przykładowe wywołanie:

    EXEC AAA 2,10

    Przykładowy wynik:
    1+9
    2+8
    3+7
    4+6
    5+5
*/
CREATE PROCEDURE AAA
    @Licznik INT,
    @Suma INT
AS
BEGIN
    ;WITH Liczby AS
    (
        SELECT 1 AS N
        UNION ALL
        SELECT N + 1
        FROM Liczby
        WHERE N < @Suma
    ),
    CTE AS
    (
        SELECT
            CAST(N AS VARCHAR(50)) AS Tekst,
            N AS Suma,
            1 AS Poziom,
            N AS Ostatnia 
        FROM Liczby

        UNION ALL

        SELECT
            CAST(C.Tekst + '+' + CAST(L.N AS VARCHAR(50)) AS VARCHAR(50)),
            C.Suma + L.N,
            C.Poziom + 1,
            L.N
        FROM CTE C
        JOIN Liczby L
            ON L.N >= C.Ostatnia   
        WHERE C.Poziom < @Licznik
    )

    SELECT Tekst
    FROM CTE
    WHERE Poziom = @Licznik
      AND Suma = @Suma;
END