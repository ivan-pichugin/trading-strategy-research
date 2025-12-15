WITH tradetime AS (
    SELECT
        ticker,
        entry_tm,
        exit_tm,
        EXTRACT(EPOCH FROM (exit_tm::timestamp - entry_tm::timestamp))::int AS time_in_trade,
        r_realized,
        SUM(r_realized) OVER () AS total_r_realized
    FROM "1R" r 
    WHERE EXTRACT(EPOCH FROM (exit_tm::timestamp - entry_tm::timestamp))::int BETWEEN 1 AND 100000
)
SELECT
    COUNT(*) AS total_trades
    , COUNT(*) FILTER (WHERE r_realized > 0) AS pos_trades
    , COUNT(*) FILTER (WHERE r_realized < 0) AS neg_trades
    , COUNT(*) FILTER (WHERE r_realized > 0)::numeric / count(*) as probability
FROM tradetime;

