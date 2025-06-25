COL hh_mm_ss NEW_V hh_mm_ss NOPRI FOR A8;
SELECT TO_CHAR(SYSDATE, 'HH24:MI:SS') hh_mm_ss FROM DUAL;
PRO PRO update log
SPO 00002_edb360_335833_log.txt APP;
PRO
PRO PRO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
PRO
PRO rank:1 sql_id:5rurx5xtjwcu2
SPO OFF;
HOS zip -j edb360_335833_523132_20250305_1744 00002_edb360_335833_log.txt >> 00004_edb360_335833_log3.txt
HOS zip -j edb360_335833_523132_20250305_1744 00004_edb360_335833_log3.txt
PRO PRO update main report1
SPO 00001_edb360_335833_index.html APP;
PRO <li title="pdb:DBRHU user: module:
PRO SELECT /*+ OPT_PARAM('_parallel_syspls_obey_force' 'false') */ KSPPCV.KSPPSTVL FROM X$KSPPCV KSPPCV, X$KSPPI KSPPI WHERE KSPPI.INDX = KSPPCV.INDX AND KSPPI.KSPPINM = :B1 ">
PRO rank:1 5rurx5xtjwcu2 cursors:230
SET HEAD OFF VER OFF FEED OFF ECHO OFF;
SELECT '*** time limit exceeded ***' FROM DUAL WHERE '&&edb360_bypass.' IS NOT NULL;
SPO OFF;
HOS zip -j edb360_335833_523132_20250305_1744 00001_edb360_335833_index.html >> 00004_edb360_335833_log3.txt
EXEC :repo_seq := :repo_seq + 1;
SELECT TO_CHAR(:repo_seq) report_sequence FROM DUAL;
SPO 00002_edb360_335833_log.txt APP;
PRO PRO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
PRO PRO changes PDB to DBRHU
ALTER SESSION SET CONTAINER = DBRHU;
PRO PRO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SPO OFF;
HOS zip -j edb360_335833_523132_20250305_1744 00002_edb360_335833_log.txt >> 00004_edb360_335833_log3.txt
HOS zip -j edb360_335833_523132_20250305_1744 00004_edb360_335833_log3.txt
COL edb360_bypass NEW_V edb360_bypass;
SELECT ' echo timeout ' edb360_bypass FROM DUAL WHERE (DBMS_UTILITY.GET_TIME - :edb360_time0) / 100  >  :edb360_max_seconds;
COL hh_mm_ss NEW_V hh_mm_ss NOPRI FOR A8;
SELECT TO_CHAR(SYSDATE, 'HH24:MI:SS') hh_mm_ss FROM DUAL;
PRO PRO update log
SPO 00002_edb360_335833_log.txt APP;
SET HEAD OFF TERM ON;
PRO &&hh_mm_ss. PLANX rank:1 SQL_ID:5rurx5xtjwcu2 TOP_type:top_not_shared
SELECT 'Elapsed Hours so far: '||ROUND((DBMS_UTILITY.GET_TIME - :edb360_time0) / 100 / 3600, 3) FROM DUAL;
SET HEAD ON TERM OFF;
SPO OFF;
@@&&edb360_bypass.sql/planx.sql Y 5rurx5xtjwcu2
PRO PRO update main report2
SPO 00001_edb360_335833_index.html APP;
PRO <a href="planx_5rurx5xtjwcu2_&&current_time..txt">planx(text)</a>
SPO OFF;
PRO PRO zip
HOS zip -mj edb360_335833_523132_20250305_1744 planx_5rurx5xtjwcu2_&&current_time..txt >> 00004_edb360_335833_log3.txt
HOS zip -j edb360_335833_523132_20250305_1744 00001_edb360_335833_index.html >> 00004_edb360_335833_log3.txt
PRO PRO update main report6
SPO 00001_edb360_335833_index.html APP;
PRO <a href="sqld360_335833_5rurx5xtjwcu2_523132_20250305_1744.zip">sqld360(zip)</a>
SPO OFF;
PRO PRO zip
HOS zip -j edb360_335833_523132_20250305_1744 00001_edb360_335833_index.html >> 00004_edb360_335833_log3.txt
PRO PRO update main report7
SPO 00001_edb360_335833_index.html APP;
PRO </li>
SPO OFF;
HOS zip -j edb360_335833_523132_20250305_1744 00001_edb360_335833_index.html >> 00004_edb360_335833_log3.txt
SPO 00002_edb360_335833_log.txt APP;
PRO PRO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
PRO PRO changes PDB to DBRHU
ALTER SESSION SET CONTAINER = DBRHU;
PRO PRO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SPO OFF;
HOS zip -j edb360_335833_523132_20250305_1744 00002_edb360_335833_log.txt >> 00004_edb360_335833_log3.txt
HOS zip -j edb360_335833_523132_20250305_1744 00004_edb360_335833_log3.txt
PRO
PRO PRO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
PRO PRO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
PRO
PRO prepares to execute sqld360
PRO PRO deleting content of global temporary table "plan_table" as preparation to execute sqld360
DELETE plan_table;
COL hh_mm_ss NEW_V hh_mm_ss NOPRI FOR A8;
SELECT TO_CHAR(SYSDATE, 'HH24:MI:SS') hh_mm_ss FROM DUAL;
PRO PRO update log
SPO 00002_edb360_335833_log.txt APP;
SET HEAD OFF TERM ON;
PRO &&hh_mm_ss. SQLD360 rank:1 SQL_ID:5rurx5xtjwcu2 TOP_type:top_not_shared
SELECT 'Elapsed Hours so far: '||ROUND((DBMS_UTILITY.GET_TIME - :edb360_time0) / 100 / 3600, 3) FROM DUAL;
SET HEAD ON TERM OFF;
SPO OFF;
PRO PRO prepares execution of sqld360
INSERT INTO plan_table (id, statement_id, operation, options, object_node, projection) SELECT 1, 'SQLD360_SQLID', '5rurx5xtjwcu2', '110031', 'DBRHU' , 'DBRHU' FROM DUAL WHERE (DBMS_UTILITY.GET_TIME - :edb360_time0) / 100  <  :edb360_max_seconds;
commit;
UNDEF 1
HOS zip -j edb360_335833_523132_20250305_1744 99930_edb360_335833_top_sql_driver.sql >> 00004_edb360_335833_log3.txt
SPO 00002_edb360_335833_log.txt APP;
PRO PRO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
PRO PRO plan_table content before calling sqld360
SELECT operation||' '||object_node||' '||options||' '||object_node FROM plan_table WHERE statement_id = 'SQLD360_SQLID';
SPO OFF;
HOS zip -j edb360_335833_523132_20250305_1744 00002_edb360_335833_log.txt >> 00004_edb360_335833_log3.txt
HOS zip -j edb360_335833_523132_20250305_1744 00004_edb360_335833_log3.txt
SPO 00002_edb360_335833_log.txt APP;
PRO PRO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
DEF;
PRO PRO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
PRO PRO calling eadam (ash) for top sql and peak snaps
COL edb360_bypass NEW_V edb360_bypass;
SELECT ' echo timeout ' edb360_bypass FROM DUAL WHERE (DBMS_UTILITY.GET_TIME - :edb360_time0) / 100  >  :edb360_max_seconds;
EXEC DBMS_APPLICATION_INFO.SET_MODULE('edb360','eadam');
SPO OFF;
HOS zip -j edb360_335833_523132_20250305_1744 00002_edb360_335833_log.txt >> 00004_edb360_335833_log3.txt
HOS zip -j edb360_335833_523132_20250305_1744 00004_edb360_335833_log3.txt
@@sql/&&edb360_bypass.edb360_7c_eadam.sql
SPO 00002_edb360_335833_log.txt APP;
PRO PRO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
PRO PRO seconds left on eDB360 before calling SQLd360
VAR edb360_secs2go NUMBER;
EXEC :edb360_secs2go := 0;
EXEC :edb360_secs2go := :edb360_max_seconds - ROUND((DBMS_UTILITY.GET_TIME - :edb360_time0) / 100);
PRINT :edb360_secs2go;
DEF edb360_secs2go = '0';
COL edb360_secs2go NEW_V edb360_secs2go FOR A8;
SELECT TO_CHAR(:edb360_secs2go) edb360_secs2go FROM DUAL;
PRO PRO calling sqld360
COL edb360_bypass NEW_V edb360_bypass;
SELECT ' echo timeout ' edb360_bypass FROM DUAL WHERE (DBMS_UTILITY.GET_TIME - :edb360_time0) / 100  >  :edb360_max_seconds;
EXEC DBMS_APPLICATION_INFO.SET_MODULE('edb360','sqld360');
SPO OFF;
HOS zip -j edb360_335833_523132_20250305_1744 00002_edb360_335833_log.txt >> 00004_edb360_335833_log3.txt
HOS zip -j edb360_335833_523132_20250305_1744 00004_edb360_335833_log3.txt
@@&&edb360_bypass.sqld360.sql
SPO 00002_edb360_335833_log.txt APP;
PRO PRO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
PRO PRO returns to original PDB
ALTER SESSION SET CONTAINER = DBRHU;
PRO PRO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SPO OFF;
HOS zip -j edb360_335833_523132_20250305_1744 00002_edb360_335833_log.txt >> 00004_edb360_335833_log3.txt
HOS zip -j edb360_335833_523132_20250305_1744 00004_edb360_335833_log3.txt
