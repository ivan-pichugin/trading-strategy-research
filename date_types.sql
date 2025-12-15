WITH cte AS (
    SELECT 
        TO_DATE("Date", 'MM/DD/YYYY') AS trade_date,
        *
    FROM "1R"
    WHERE EXTRACT(EPOCH FROM (exit_tm::timestamp - entry_tm::timestamp))::int >= 1

    UNION ALL

    SELECT 
        TO_DATE("Date", 'YYYY-MM-DD') AS trade_date,
        *
    FROM "2R"
    WHERE EXTRACT(EPOCH FROM (exit_tm::timestamp - entry_tm::timestamp))::int >= 1
)
select
	trade_date
	, ticker
	,exit_tm
	, entry_tm
	, r_realized 
	,r_multiple 
	, SUM(r_realized) over() as SUM
FROM cte
ORDER BY trade_date, ticker;
