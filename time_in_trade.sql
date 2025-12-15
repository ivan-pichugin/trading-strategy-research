SELECT
    ticker
    , entry_tm
    , exit_tm
    , EXTRACT(EPOCH FROM (exit_tm::timestamp - entry_tm::timestamp))::int AS Time_In_Trade
    , r_realized
    , SUM(r_realized) OVER () AS total_r_realized
    , SUM(r_realized) OVER (ORDER BY entry_tm) step_pnl
    , ROW_NUMBER() OVER () AS point_index
FROM "1R" r 
where EXTRACT(EPOCH FROM (exit_tm::timestamp - entry_tm::timestamp))::int >= 1
ORDER BY entry_tm asc;


