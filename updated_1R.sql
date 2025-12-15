WITH base AS (
    SELECT
        ticker,
        entry_tm,
        exit_tm,
        EXTRACT(EPOCH FROM (exit_tm::timestamp - entry_tm::timestamp))::int AS time_in_trade,
        r_realized
    FROM "1R"
    WHERE EXTRACT(EPOCH FROM (exit_tm::timestamp - entry_tm::timestamp))::int >= 1
),

append_part AS (
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
    SELECT
        ticker,
        entry_tm,
        exit_tm,
        EXTRACT(EPOCH FROM (exit_tm::timestamp - entry_tm::timestamp))::int AS time_in_trade,

        -- замена r_realized = 2 → 1
        CASE 
            WHEN r_realized = 2 THEN 1
            ELSE r_realized
        END AS r_realized

    FROM (
        SELECT *,
               COUNT(*) OVER (PARTITION BY trade_date, ticker) AS one_only
        FROM cte
    ) t
    WHERE one_only = 1
)

SELECT
    ticker,
    entry_tm,
    exit_tm,
    time_in_trade,
    r_realized,
    SUM(r_realized) OVER () AS total_r_realized,
    SUM(r_realized) OVER (ORDER BY entry_tm) AS step_pnl,
    ROW_NUMBER() OVER (ORDER BY entry_tm) AS point_index
FROM (
    SELECT * FROM base
    UNION ALL
    SELECT * FROM append_part
) x
ORDER BY entry_tm;
