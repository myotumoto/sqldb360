PRO Please Wait ...
DEF from_edb360='--'
INSERT INTO plan_table (statement_id, cost, cardinality) VALUES ('EDB360_SECS2GO', &&edb360_secs2go., &&edb360_secs2go.);
COMMIT;
DEF skip_tcb='--'
DEF sqld360_fromedb360_days='31'
COL secs2go_starttime NEW_V secs2go_starttime
COL skip_sqld360 NEW_V skip_sqld360
SELECT TO_CHAR(sysdate,'YYYYMMDDHH24MISS') secs2go_starttime,
CASE WHEN cardinality <= 0 THEN '--' ELSE NULL END skip_sqld360
FROM plan_table
WHERE statement_id = 'EDB360_SECS2GO';
ALTER SESSION SET CONTAINER=DBRHU;
DEF sqld360_container='DBRHU'
@@&&skip_sqld360.sql/sqld360_0a_main.sql 5rurx5xtjwcu2 T DBRHU
HOS unzip -l &&sqld360_main_filename._&&sqld360_file_time.
SET DEF @
UPDATE plan_table
SET cardinality = cardinality - ((sysdate - TO_DATE('@@secs2go_starttime.', 'YYYYMMDDHH24MISS'))*86400)
WHERE statement_id = 'EDB360_SECS2GO'
AND cardinality > 0;
COMMIT;
SET DEF &
