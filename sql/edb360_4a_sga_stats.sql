@@&&edb360_0g.tkprof.sql
DEF section_id = '4a';
DEF section_name = 'System Global Area (SGA) Statistics History';
EXEC DBMS_APPLICATION_INFO.SET_MODULE('&&edb360_prefix.','&&section_id.');
SPO &&edb360_main_report..html APP;
PRO <h2>&&section_id.. &&section_name.</h2>
PRO <ol start="&&report_sequence.">
SPO OFF;

DEF title = 'SGA Allocation';
DEF main_table = 'X$KSMSSINFO';
BEGIN
  :sql_text := q'[
select * from x$ksmssinfo
]';
END;
/
@@&&skip_ver_le_11.edb360_9a_pre_one.sql

DEF main_table = '&&cdb_awr_hist_prefix.SGASTAT';
DEF chartype = 'LineChart';
DEF stacked = '';
DEF vaxis = 'SGA Statistics in GBs';
DEF vbaseline = '';
DEF tit_01 = 'Total SGA allocated';
DEF tit_02 = 'Fixed SGA';
DEF tit_03 = 'Buffer Cache';
DEF tit_04 = 'Log Buffer';
DEF tit_05 = 'Shared IO Pool';
DEF tit_06 = 'Shared Pool';
DEF tit_07 = 'Large Pool';
DEF tit_08 = 'Java Pool';
DEF tit_09 = 'Streams Pool';
DEF tit_10 = '';
DEF tit_11 = '';
DEF tit_12 = '';
DEF tit_13 = '';
DEF tit_14 = '';
DEF tit_15 = '';
BEGIN
  :sql_text_backup := q'[
WITH
sgastat_denorm_1 AS (
SELECT /*+ &&sq_fact_hints. */ /* &&section_id..&&report_sequence. */
       snap_id,
       dbid,
       instance_number,
       SUM(bytes) sga_total,
       SUM(CASE WHEN pool IS NULL AND name = 'fixed_sga' THEN bytes ELSE 0 END) fixed_sga,
       SUM(CASE WHEN pool IS NULL AND name = 'buffer_cache' THEN bytes ELSE 0 END) buffer_cache,
       SUM(CASE WHEN pool IS NULL AND name = 'log_buffer' THEN bytes ELSE 0 END) log_buffer,
       SUM(CASE WHEN pool IS NULL AND name = 'shared_io_pool' THEN bytes ELSE 0 END) shared_io_pool,
       SUM(CASE pool WHEN 'shared pool' THEN bytes ELSE 0 END) shared_pool,
       SUM(CASE pool WHEN 'large pool' THEN bytes ELSE 0 END) large_pool,
       SUM(CASE pool WHEN 'java pool' THEN bytes ELSE 0 END) java_pool,
       SUM(CASE pool WHEN 'streams pool' THEN bytes ELSE 0 END) streams_pool
  FROM &&cdb_awr_hist_prefix.sgastat
 WHERE snap_id BETWEEN &&minimum_snap_id. AND &&maximum_snap_id.
   AND dbid = &&edb360_dbid.
   AND instance_number = @instance_number@
 GROUP BY
       snap_id,
       dbid,
       instance_number
), sgastat_denorm_2 AS (
SELECT /*+ &&sq_fact_hints. */ /* &&section_id..&&report_sequence. */
       h1.snap_id,
       h1.dbid,
       h1.instance_number,
       s1.begin_interval_time,
       s1.end_interval_time,
       ROUND((CAST(s1.end_interval_time AS DATE) - CAST(s1.begin_interval_time AS DATE)) * 24 * 60 * 60) interval_secs,
       h1.sga_total,
       h1.fixed_sga,
       h1.buffer_cache,
       h1.log_buffer,
       h1.shared_io_pool,
       h1.shared_pool,
       h1.large_pool,
       h1.java_pool,
       h1.streams_pool
  FROM sgastat_denorm_1 h0,
       sgastat_denorm_1 h1,
       &&cdb_awr_hist_prefix.snapshot s0,
       &&cdb_awr_hist_prefix.snapshot s1
 WHERE h1.snap_id = h0.snap_id + 1
   AND h1.dbid = h0.dbid
   AND h1.instance_number = h0.instance_number
   AND s0.snap_id = h0.snap_id
   AND s0.dbid = h0.dbid
   AND s0.instance_number = h0.instance_number
   AND s0.snap_id BETWEEN &&minimum_snap_id. AND &&maximum_snap_id.
   AND s0.dbid = &&edb360_dbid.
   AND s1.snap_id = h1.snap_id
   AND s1.dbid = h1.dbid
   AND s1.instance_number = h1.instance_number
   AND s1.snap_id = s0.snap_id + 1
   AND s1.startup_time = s0.startup_time
   AND s1.begin_interval_time > (s0.begin_interval_time + (1 / (24 * 60))) /* filter out snaps apart < 1 min */
), x as (
SELECT snap_id,
       TO_CHAR(MIN(begin_interval_time), 'YYYY-MM-DD HH24:MI:SS') begin_time,
       TO_CHAR(MIN(end_interval_time), 'YYYY-MM-DD HH24:MI:SS') end_time,
       ROUND(SUM(sga_total) / POWER(2,30), 3) sga_total,
       ROUND(SUM(fixed_sga) / POWER(2,30), 3) fixed_sga,
       ROUND(SUM(buffer_cache) / POWER(2,30), 3) buffer_cache,
       ROUND(SUM(log_buffer) / POWER(2,30), 3) log_buffer,
       ROUND(SUM(shared_io_pool) / POWER(2,30), 3) shared_io_pool,
       ROUND(SUM(shared_pool) / POWER(2,30), 3) shared_pool,
       ROUND(SUM(large_pool) / POWER(2,30), 3) large_pool,
       ROUND(SUM(java_pool) / POWER(2,30), 3) java_pool,
       ROUND(SUM(streams_pool) / POWER(2,30), 3) streams_pool,
       0 dummy_10,
       0 dummy_11,
       0 dummy_12,
       0 dummy_13,
       0 dummy_14,
       0 dummy_15
  FROM sgastat_denorm_2
 GROUP BY
       snap_id
)
SELECT x.*
FROM   x
 ORDER BY
       x.snap_id
]';
END;
/

DEF skip_lch = '';
DEF title = 'SGA Statistics for Cluster';
DEF abstract = '&&abstract_uom.';
DEF foot = 'Does not include Free SGA Memory Available. For memory pools resize review Memory Statistics reports instead.'
EXEC :sql_text := REPLACE(:sql_text_backup, '@instance_number@', 'instance_number');
@@&&is_single_instance.&&skip_diagnostics.edb360_9a_pre_one.sql

DEF skip_lch = '';
DEF title = 'SGA Statistics for Instance 1';
DEF abstract = '&&abstract_uom.';
DEF foot = 'Does not include Free SGA Memory Available. For memory pools resize review Memory Statistics reports instead.'
EXEC :sql_text := REPLACE(:sql_text_backup, '@instance_number@', '1');
@@&&skip_inst1.&&skip_diagnostics.edb360_9a_pre_one.sql

DEF skip_lch = '';
DEF title = 'SGA Statistics for Instance 2';
DEF abstract = '&&abstract_uom.';
DEF foot = 'Does not include Free SGA Memory Available. For memory pools resize review Memory Statistics reports instead.'
EXEC :sql_text := REPLACE(:sql_text_backup, '@instance_number@', '2');
@@&&skip_inst2.&&skip_diagnostics.edb360_9a_pre_one.sql

DEF skip_lch = '';
DEF title = 'SGA Statistics for Instance 3';
DEF abstract = '&&abstract_uom.';
DEF foot = 'Does not include Free SGA Memory Available. For memory pools resize review Memory Statistics reports instead.'
EXEC :sql_text := REPLACE(:sql_text_backup, '@instance_number@', '3');
@@&&skip_inst3.&&skip_diagnostics.edb360_9a_pre_one.sql

DEF skip_lch = '';
DEF title = 'SGA Statistics for Instance 4';
DEF abstract = '&&abstract_uom.';
DEF foot = 'Does not include Free SGA Memory Available. For memory pools resize review Memory Statistics reports instead.'
EXEC :sql_text := REPLACE(:sql_text_backup, '@instance_number@', '4');
@@&&skip_inst4.&&skip_diagnostics.edb360_9a_pre_one.sql

DEF skip_lch = '';
DEF title = 'SGA Statistics for Instance 5';
DEF abstract = '&&abstract_uom.';
DEF foot = 'Does not include Free SGA Memory Available. For memory pools resize review Memory Statistics reports instead.'
EXEC :sql_text := REPLACE(:sql_text_backup, '@instance_number@', '5');
@@&&skip_inst5.&&skip_diagnostics.edb360_9a_pre_one.sql

DEF skip_lch = '';
DEF title = 'SGA Statistics for Instance 6';
DEF abstract = '&&abstract_uom.';
DEF foot = 'Does not include Free SGA Memory Available. For memory pools resize review Memory Statistics reports instead.'
EXEC :sql_text := REPLACE(:sql_text_backup, '@instance_number@', '6');
@@&&skip_inst6.&&skip_diagnostics.edb360_9a_pre_one.sql

DEF skip_lch = '';
DEF title = 'SGA Statistics for Instance 7';
DEF abstract = '&&abstract_uom.';
DEF foot = 'Does not include Free SGA Memory Available. For memory pools resize review Memory Statistics reports instead.'
EXEC :sql_text := REPLACE(:sql_text_backup, '@instance_number@', '7');
@@&&skip_inst7.&&skip_diagnostics.edb360_9a_pre_one.sql

DEF skip_lch = '';
DEF title = 'SGA Statistics for Instance 8';
DEF abstract = '&&abstract_uom.';
DEF foot = 'Does not include Free SGA Memory Available. For memory pools resize review Memory Statistics reports instead.'
EXEC :sql_text := REPLACE(:sql_text_backup, '@instance_number@', '8');
@@&&skip_inst8.&&skip_diagnostics.edb360_9a_pre_one.sql


--dmk begin SGASTAT per PDB per INSTANCE
DEF main_table = '&&cdb_awr_hist_prefix.SGASTAT';

COL con_id_01 NEW_V con_id_01;
COL con_id_02 NEW_V con_id_02;
COL con_id_03 NEW_V con_id_03;
COL con_id_04 NEW_V con_id_04;
COL con_id_05 NEW_V con_id_05;
COL con_id_06 NEW_V con_id_06;
COL con_id_07 NEW_V con_id_07;
COL con_id_08 NEW_V con_id_08;
COL con_id_09 NEW_V con_id_09;
COL con_id_10 NEW_V con_id_10;
COL con_id_11 NEW_V con_id_11;
COL con_id_12 NEW_V con_id_12;
COL con_id_13 NEW_V con_id_13;
COL con_id_14 NEW_V con_id_14;
COL con_id_15 NEW_V con_id_15;

COL con_name_01 NEW_V con_name_01;
COL con_name_02 NEW_V con_name_02;
COL con_name_03 NEW_V con_name_03;
COL con_name_04 NEW_V con_name_04;
COL con_name_05 NEW_V con_name_05;
COL con_name_06 NEW_V con_name_06;
COL con_name_07 NEW_V con_name_07;
COL con_name_08 NEW_V con_name_08;
COL con_name_09 NEW_V con_name_09;
COL con_name_10 NEW_V con_name_10;
COL con_name_11 NEW_V con_name_11;
COL con_name_12 NEW_V con_name_12;
COL con_name_13 NEW_V con_name_13;
COL con_name_14 NEW_V con_name_14;
COL con_name_15 NEW_V con_name_15;

DEF tit_01 = '';
DEF tit_02 = '';
DEF tit_03 = '';
DEF tit_04 = '';
DEF tit_05 = '';
DEF tit_06 = '';
DEF tit_07 = '';
DEF tit_08 = '';
DEF tit_09 = '';
DEF tit_10 = '';
DEF tit_11 = '';
DEF tit_12 = '';
DEF tit_13 = '';
DEF tit_14 = '';
DEF tit_15 = '';

WITH x AS (
SELECT &&skip_noncdb.con_id,
       &&skip_cdb.TO_NUMBER(null) con_id,
       SUM(bytes) sga_total
  FROM &&cdb_awr_hist_prefix.sgastat
 WHERE snap_id BETWEEN &&minimum_snap_id. AND &&maximum_snap_id.
   AND dbid = &&edb360_dbid.
GROUP BY
       &&skip_noncdb.con_id,
       null
), fake as (select null name from dual
), y AS (
SELECT row_number() OVER (ORDER BY sga_total DESC) wrank,
       x.con_id, 'PDB_'||x.con_id||'_'||c.name con_name
FROM   x
       &&skip_noncdb.LEFT OUTER JOIN &&v_object_prefix.containers c ON c.con_id = x.con_id
       &&skip_cdb. cross join fake c
), z AS (
SELECT row_number() OVER (ORDER BY con_id) wrank,
       y.con_id, y.con_name
  FROM y
 WHERE wrank <= 15
)
SELECT NVL(MAX(CASE wrank WHEN 01 THEN con_id END),-1) con_id_01,
       NVL(MAX(CASE wrank WHEN 02 THEN con_id END),-1) con_id_02,
       NVL(MAX(CASE wrank WHEN 03 THEN con_id END),-1) con_id_03,
       NVL(MAX(CASE wrank WHEN 04 THEN con_id END),-1) con_id_04,
       NVL(MAX(CASE wrank WHEN 05 THEN con_id END),-1) con_id_05,
       NVL(MAX(CASE wrank WHEN 06 THEN con_id END),-1) con_id_06,
       NVL(MAX(CASE wrank WHEN 07 THEN con_id END),-1) con_id_07,
       NVL(MAX(CASE wrank WHEN 08 THEN con_id END),-1) con_id_08,
       NVL(MAX(CASE wrank WHEN 09 THEN con_id END),-1) con_id_09,
       NVL(MAX(CASE wrank WHEN 10 THEN con_id END),-1) con_id_10,
       NVL(MAX(CASE wrank WHEN 11 THEN con_id END),-1) con_id_11,
       NVL(MAX(CASE wrank WHEN 12 THEN con_id END),-1) con_id_12,
       NVL(MAX(CASE wrank WHEN 13 THEN con_id END),-1) con_id_13,
       NVL(MAX(CASE wrank WHEN 14 THEN con_id END),-1) con_id_14,
       NVL(MAX(CASE wrank WHEN 15 THEN con_id END),-1) con_id_15,
       NVL(MAX(CASE wrank WHEN 01 THEN con_name END),'DUMMY_01') con_name_01,
       NVL(MAX(CASE wrank WHEN 02 THEN con_name END),'DUMMY_02') con_name_02,
       NVL(MAX(CASE wrank WHEN 03 THEN con_name END),'DUMMY_03') con_name_03,
       NVL(MAX(CASE wrank WHEN 04 THEN con_name END),'DUMMY_04') con_name_04,
       NVL(MAX(CASE wrank WHEN 05 THEN con_name END),'DUMMY_05') con_name_05,
       NVL(MAX(CASE wrank WHEN 06 THEN con_name END),'DUMMY_06') con_name_06,
       NVL(MAX(CASE wrank WHEN 07 THEN con_name END),'DUMMY_07') con_name_07,
       NVL(MAX(CASE wrank WHEN 08 THEN con_name END),'DUMMY_08') con_name_08,
       NVL(MAX(CASE wrank WHEN 09 THEN con_name END),'DUMMY_09') con_name_09,
       NVL(MAX(CASE wrank WHEN 10 THEN con_name END),'DUMMY_10') con_name_10,
       NVL(MAX(CASE wrank WHEN 11 THEN con_name END),'DUMMY_11') con_name_11,
       NVL(MAX(CASE wrank WHEN 12 THEN con_name END),'DUMMY_12') con_name_12,
       NVL(MAX(CASE wrank WHEN 13 THEN con_name END),'DUMMY_13') con_name_13,
       NVL(MAX(CASE wrank WHEN 14 THEN con_name END),'DUMMY_14') con_name_14,
       NVL(MAX(CASE wrank WHEN 15 THEN con_name END),'DUMMY_15') con_name_15,
       MAX(CASE wrank WHEN 01 THEN con_name END) tit_01,
       MAX(CASE wrank WHEN 02 THEN con_name END) tit_02,
       MAX(CASE wrank WHEN 03 THEN con_name END) tit_03,
       MAX(CASE wrank WHEN 04 THEN con_name END) tit_04,
       MAX(CASE wrank WHEN 05 THEN con_name END) tit_05,
       MAX(CASE wrank WHEN 06 THEN con_name END) tit_06,
       MAX(CASE wrank WHEN 07 THEN con_name END) tit_07,
       MAX(CASE wrank WHEN 08 THEN con_name END) tit_08,
       MAX(CASE wrank WHEN 09 THEN con_name END) tit_09,
       MAX(CASE wrank WHEN 10 THEN con_name END) tit_10,
       MAX(CASE wrank WHEN 11 THEN con_name END) tit_11,
       MAX(CASE wrank WHEN 12 THEN con_name END) tit_12,
       MAX(CASE wrank WHEN 13 THEN con_name END) tit_13,
       MAX(CASE wrank WHEN 14 THEN con_name END) tit_14,
       MAX(CASE wrank WHEN 15 THEN con_name END) tit_15
  FROM z
 WHERE wrank <= 15;

DEF chartype = 'LineChart';
DEF stacked = '';
DEF vaxis = 'Total SGA Allocated (Gb) per PDB (GB)';
DEF vbaseline = '';
BEGIN
  :sql_text_backup := q'[
WITH
sgastat_denorm_1 AS (
SELECT /*+ &&sq_fact_hints. */ /* &&section_id..&&report_sequence. */
       snap_id,
       &&skip_noncdb.con_id,
       dbid,
       instance_number,
       SUM(bytes) sga_total
  FROM &&cdb_awr_hist_prefix.sgastat
 WHERE snap_id BETWEEN &&minimum_snap_id. AND &&maximum_snap_id.
   AND dbid = &&edb360_dbid.
   AND instance_number = @instance_number@ @sgastat_criteria@
 GROUP BY
       snap_id,
       &&skip_noncdb.con_id,
       dbid,
       instance_number
), sgastat_denorm_2 AS (
SELECT /*+ &&sq_fact_hints. */ /* &&section_id..&&report_sequence. */
       h1.snap_id,
       &&skip_noncdb.h1.con_id,
       h1.dbid,
       h1.instance_number,
       s1.begin_interval_time,
       s1.end_interval_time,
       ROUND((CAST(s1.end_interval_time AS DATE) - CAST(s1.begin_interval_time AS DATE)) * 24 * 60 * 60) interval_secs,
       h1.sga_total
  FROM sgastat_denorm_1 h0,
       sgastat_denorm_1 h1,
       &&cdb_awr_hist_prefix.snapshot s0,
       &&cdb_awr_hist_prefix.snapshot s1
 WHERE h1.snap_id = h0.snap_id + 1
   AND h1.dbid = h0.dbid
   &&skip_noncdb.and h1.con_id = h0.con_id
   AND h1.instance_number = h0.instance_number
   AND s0.snap_id = h0.snap_id
   AND s0.dbid = h0.dbid
   AND s0.instance_number = h0.instance_number
   AND s0.snap_id BETWEEN &&minimum_snap_id. AND &&maximum_snap_id.
   AND s0.dbid = &&edb360_dbid.
   AND s1.snap_id = h1.snap_id
   AND s1.dbid = h1.dbid
   AND s1.instance_number = h1.instance_number
   AND s1.snap_id = s0.snap_id + 1
   AND s1.startup_time = s0.startup_time
   AND s1.begin_interval_time > (s0.begin_interval_time + (1 / (24 * 60))) /* filter out snaps apart < 1 min */
), x AS (
SELECT snap_id, con_id,
       TO_CHAR(MIN(begin_interval_time), 'YYYY-MM-DD HH24:MI:SS') begin_time,
       TO_CHAR(MIN(end_interval_time), 'YYYY-MM-DD HH24:MI:SS') end_time,
       ROUND(SUM(sga_total) / POWER(2,30), 3) sga_total
  FROM sgastat_denorm_2
 GROUP BY
       snap_id, con_id
), y AS (
SELECT *
  FROM x
       PIVOT(AVG(NVL(sga_total,0)) FOR con_id IN(
 &&con_id_01 &&con_name_01
,&&con_id_02 &&con_name_02
,&&con_id_03 &&con_name_03
,&&con_id_04 &&con_name_04
,&&con_id_05 &&con_name_05
,&&con_id_06 &&con_name_06
,&&con_id_07 &&con_name_07
,&&con_id_08 &&con_name_08
,&&con_id_09 &&con_name_09
,&&con_id_10 &&con_name_10
,&&con_id_11 &&con_name_11
,&&con_id_12 &&con_name_12
,&&con_id_13 &&con_name_13
,&&con_id_14 &&con_name_14
,&&con_id_15 &&con_name_15
))
)
select snap_id, begin_time, end_time
, NVL(&&con_name_01,0) &&con_name_01
, NVL(&&con_name_02,0) &&con_name_02
, NVL(&&con_name_03,0) &&con_name_03
, NVL(&&con_name_04,0) &&con_name_04
, NVL(&&con_name_05,0) &&con_name_05
, NVL(&&con_name_06,0) &&con_name_06
, NVL(&&con_name_07,0) &&con_name_07
, NVL(&&con_name_08,0) &&con_name_08
, NVL(&&con_name_09,0) &&con_name_09
, NVL(&&con_name_10,0) &&con_name_10
, NVL(&&con_name_11,0) &&con_name_11
, NVL(&&con_name_12,0) &&con_name_12
, NVL(&&con_name_13,0) &&con_name_13
, NVL(&&con_name_14,0) &&con_name_14
, NVL(&&con_name_15,0) &&con_name_15
from y
ORDER BY snap_id
]';
END;
/

DEF skip_lch = '';
DEF title = 'Total SGA Allocated (Gb) per PDB for Cluster';
DEF abstract = '&&abstract_uom.';
DEF foot = 'Does not include Free SGA Memory Available. For memory pools resize review Memory Statistics reports instead.'
EXEC :sql_text_backup2 := REPLACE(:sql_text_backup, '@instance_number@', 'instance_number');
EXEC :sql_text := REPLACE(:sql_text_backup2, '@sgastat_criteria@', '');

@@&&skip_noncdb.&&is_single_instance.&&skip_diagnostics.edb360_9a_pre_one.sql

DEF skip_lch = '';
DEF title = 'Total SGA Allocated (Gb) per PDB for Instance 1';
DEF abstract = '&&abstract_uom.';
DEF foot = 'Does not include Free SGA Memory Available. For memory pools resize review Memory Statistics reports instead.'
EXEC :sql_text_backup2 := REPLACE(:sql_text_backup, '@instance_number@', '1');
EXEC :sql_text := REPLACE(:sql_text_backup2, '@sgastat_criteria@', '');
@@&&skip_noncdb.&&skip_inst1.&&skip_diagnostics.edb360_9a_pre_one.sql

DEF skip_lch = '';
DEF title = 'Total SGA Allocated (Gb) per PDB for Instance 2';
DEF abstract = '&&abstract_uom.';
DEF foot = 'Does not include Free SGA Memory Available. For memory pools resize review Memory Statistics reports instead.'
EXEC :sql_text_backup2 := REPLACE(:sql_text_backup, '@instance_number@', '2');
EXEC :sql_text := REPLACE(:sql_text_backup2, '@sgastat_criteria@', '');
@@&&skip_noncdb.&&skip_inst2.&&skip_diagnostics.edb360_9a_pre_one.sql

DEF skip_lch = '';
DEF title = 'Total SGA Allocated (Gb) per PDB for Instance 3';
DEF abstract = '&&abstract_uom.';
DEF foot = 'Does not include Free SGA Memory Available. For memory pools resize review Memory Statistics reports instead.'
EXEC :sql_text_backup2 := REPLACE(:sql_text_backup, '@instance_number@', '3');
EXEC :sql_text := REPLACE(:sql_text_backup2, '@sgastat_criteria@', '');
@@&&skip_noncdb.&&skip_inst3.&&skip_diagnostics.edb360_9a_pre_one.sql

DEF skip_lch = '';
DEF title = 'Total SGA Allocated (Gb) per PDB for Instance 4';
DEF abstract = '&&abstract_uom.';
DEF foot = 'Does not include Free SGA Memory Available. For memory pools resize review Memory Statistics reports instead.'
EXEC :sql_text_backup2 := REPLACE(:sql_text_backup, '@instance_number@', '4');
EXEC :sql_text := REPLACE(:sql_text_backup2, '@sgastat_criteria@', '');
@@&&skip_noncdb.&&skip_inst4.&&skip_diagnostics.edb360_9a_pre_one.sql

DEF skip_lch = '';
DEF title = 'Total SGA Allocated (Gb) per PDB for Instance 5';
DEF abstract = '&&abstract_uom.';
DEF foot = 'Does not include Free SGA Memory Available. For memory pools resize review Memory Statistics reports instead.'
EXEC :sql_text_backup2 := REPLACE(:sql_text_backup, '@instance_number@', '5');
EXEC :sql_text := REPLACE(:sql_text_backup2, '@sgastat_criteria@', '');
@@&&skip_noncdb.&&skip_inst5.&&skip_diagnostics.edb360_9a_pre_one.sql

DEF skip_lch = '';
DEF title = 'Total SGA Allocated (Gb) per PDB for Instance 6';
DEF abstract = '&&abstract_uom.';
DEF foot = 'Does not include Free SGA Memory Available. For memory pools resize review Memory Statistics reports instead.'
EXEC :sql_text_backup2 := REPLACE(:sql_text_backup, '@instance_number@', '6');
EXEC :sql_text := REPLACE(:sql_text_backup2, '@sgastat_criteria@', '');
@@&&skip_noncdb.&&skip_inst6.&&skip_diagnostics.edb360_9a_pre_one.sql

DEF skip_lch = '';
DEF title = 'Total SGA Allocated (Gb) per PDB for Instance 7';
DEF abstract = '&&abstract_uom.';
DEF foot = 'Does not include Free SGA Memory Available. For memory pools resize review Memory Statistics reports instead.'
EXEC :sql_text_backup2 := REPLACE(:sql_text_backup, '@instance_number@', '7');
EXEC :sql_text := REPLACE(:sql_text_backup2, '@sgastat_criteria@', '');
@@&&skip_noncdb.&&skip_inst7.&&skip_diagnostics.edb360_9a_pre_one.sql

DEF skip_lch = '';
DEF title = 'Total SGA Allocated (Gb) per PDB for Instance 8';
DEF abstract = '&&abstract_uom.';
DEF foot = 'Does not include Free SGA Memory Available. For memory pools resize review Memory Statistics reports instead.'
EXEC :sql_text_backup2 := REPLACE(:sql_text_backup, '@instance_number@', '8');
EXEC :sql_text := REPLACE(:sql_text_backup2, '@sgastat_criteria@', '');
@@&&skip_noncdb.&&skip_inst8.&&skip_diagnostics.edb360_9a_pre_one.sql



DEF skip_lch = '';
DEF title = 'Total Shared Pool Allocated (Gb) per PDB for Cluster';
DEF abstract = '&&abstract_uom.';
DEF foot = 'Does not include Free SGA Memory Available. For memory pools resize review Memory Statistics reports instead.'
EXEC :sql_text_backup2 := REPLACE(:sql_text_backup, '@instance_number@', 'instance_number');
EXEC :sql_text := REPLACE(:sql_text_backup2, '@sgastat_criteria@', 'AND pool = ''shared pool''');

@@&&skip_noncdb.&&is_single_instance.&&skip_diagnostics.edb360_9a_pre_one.sql

DEF skip_lch = '';
DEF title = 'Shared Pool Allocated (Gb) per PDB for Instance 1';
DEF abstract = '&&abstract_uom.';
DEF foot = 'Does not include Free SGA Memory Available. For memory pools resize review Memory Statistics reports instead.'
EXEC :sql_text_backup2 := REPLACE(:sql_text_backup, '@instance_number@', '1');
EXEC :sql_text := REPLACE(:sql_text_backup2, '@sgastat_criteria@', 'AND pool = ''shared pool''');
@@&&skip_noncdb.&&skip_inst1.&&skip_diagnostics.edb360_9a_pre_one.sql

DEF skip_lch = '';
DEF title = 'Shared Pool Allocated (Gb) per PDB for Instance 2';
DEF abstract = '&&abstract_uom.';
DEF foot = 'Does not include Free SGA Memory Available. For memory pools resize review Memory Statistics reports instead.'
EXEC :sql_text_backup2 := REPLACE(:sql_text_backup, '@instance_number@', '2');
EXEC :sql_text := REPLACE(:sql_text_backup2, '@sgastat_criteria@', 'AND pool = ''shared pool''');
@@&&skip_noncdb.&&skip_inst2.&&skip_diagnostics.edb360_9a_pre_one.sql

DEF skip_lch = '';
DEF title = 'Shared Pool Allocated (Gb) per PDB for Instance 3';
DEF abstract = '&&abstract_uom.';
DEF foot = 'Does not include Free SGA Memory Available. For memory pools resize review Memory Statistics reports instead.'
EXEC :sql_text_backup2 := REPLACE(:sql_text_backup, '@instance_number@', '3');
EXEC :sql_text := REPLACE(:sql_text_backup2, '@sgastat_criteria@', 'AND pool = ''shared pool''');
@@&&skip_noncdb.&&skip_inst3.&&skip_diagnostics.edb360_9a_pre_one.sql

DEF skip_lch = '';
DEF title = 'Shared Pool Allocated (Gb) per PDB for Instance 4';
DEF abstract = '&&abstract_uom.';
DEF foot = 'Does not include Free SGA Memory Available. For memory pools resize review Memory Statistics reports instead.'
EXEC :sql_text_backup2 := REPLACE(:sql_text_backup, '@instance_number@', '4');
EXEC :sql_text := REPLACE(:sql_text_backup2, '@sgastat_criteria@', 'AND pool = ''shared pool''');
@@&&skip_noncdb.&&skip_inst4.&&skip_diagnostics.edb360_9a_pre_one.sql

DEF skip_lch = '';
DEF title = 'Shared Pool Allocated (Gb) per PDB for Instance 5';
DEF abstract = '&&abstract_uom.';
DEF foot = 'Does not include Free SGA Memory Available. For memory pools resize review Memory Statistics reports instead.'
EXEC :sql_text_backup2 := REPLACE(:sql_text_backup, '@instance_number@', '5');
EXEC :sql_text := REPLACE(:sql_text_backup2, '@sgastat_criteria@', 'AND pool = ''shared pool''');
@@&&skip_noncdb.&&skip_inst5.&&skip_diagnostics.edb360_9a_pre_one.sql

DEF skip_lch = '';
DEF title = 'Shared Pool Allocated (Gb) per PDB for Instance 6';
DEF abstract = '&&abstract_uom.';
DEF foot = 'Does not include Free SGA Memory Available. For memory pools resize review Memory Statistics reports instead.'
EXEC :sql_text_backup2 := REPLACE(:sql_text_backup, '@instance_number@', '6');
EXEC :sql_text := REPLACE(:sql_text_backup2, '@sgastat_criteria@', 'AND pool = ''shared pool''');
@@&&skip_noncdb.&&skip_inst6.&&skip_diagnostics.edb360_9a_pre_one.sql

DEF skip_lch = '';
DEF title = 'Shared Pool Allocated (Gb) per PDB for Instance 7';
DEF abstract = '&&abstract_uom.';
DEF foot = 'Does not include Free SGA Memory Available. For memory pools resize review Memory Statistics reports instead.'
EXEC :sql_text_backup2 := REPLACE(:sql_text_backup, '@instance_number@', '7');
EXEC :sql_text := REPLACE(:sql_text_backup2, '@sgastat_criteria@', 'AND pool = ''shared pool''');
@@&&skip_noncdb.&&skip_inst7.&&skip_diagnostics.edb360_9a_pre_one.sql

DEF skip_lch = '';
DEF title = 'Shared Pool Allocated (Gb) per PDB for Instance 8';
DEF abstract = '&&abstract_uom.';
DEF foot = 'Does not include Free SGA Memory Available. For memory pools resize review Memory Statistics reports instead.'
EXEC :sql_text_backup2 := REPLACE(:sql_text_backup, '@instance_number@', '8');
EXEC :sql_text := REPLACE(:sql_text_backup2, '@sgastat_criteria@', 'AND pool = ''shared pool''');
@@&&skip_noncdb.&&skip_inst8.&&skip_diagnostics.edb360_9a_pre_one.sql




DEF skip_lch = '';
DEF title = 'Total Large Pool Allocated (Gb) per PDB for Cluster';
DEF abstract = '&&abstract_uom.';
DEF foot = 'Does not include Free SGA Memory Available. For memory pools resize review Memory Statistics reports instead.'
EXEC :sql_text_backup2 := REPLACE(:sql_text_backup, '@instance_number@', 'instance_number');
EXEC :sql_text := REPLACE(:sql_text_backup2, '@sgastat_criteria@', 'AND pool = ''large pool''');

@@&&skip_noncdb.&&is_single_instance.&&skip_diagnostics.edb360_9a_pre_one.sql

DEF skip_lch = '';
DEF title = 'Large Pool Allocated (Gb) per PDB for Instance 1';
DEF abstract = '&&abstract_uom.';
DEF foot = 'Does not include Free SGA Memory Available. For memory pools resize review Memory Statistics reports instead.'
EXEC :sql_text_backup2 := REPLACE(:sql_text_backup, '@instance_number@', '1');
EXEC :sql_text := REPLACE(:sql_text_backup2, '@sgastat_criteria@', 'AND pool = ''large pool''');
@@&&skip_noncdb.&&skip_inst1.&&skip_diagnostics.edb360_9a_pre_one.sql

DEF skip_lch = '';
DEF title = 'Large Pool Allocated (Gb) per PDB for Instance 2';
DEF abstract = '&&abstract_uom.';
DEF foot = 'Does not include Free SGA Memory Available. For memory pools resize review Memory Statistics reports instead.'
EXEC :sql_text_backup2 := REPLACE(:sql_text_backup, '@instance_number@', '2');
EXEC :sql_text := REPLACE(:sql_text_backup2, '@sgastat_criteria@', 'AND pool = ''large pool''');
@@&&skip_noncdb.&&skip_inst2.&&skip_diagnostics.edb360_9a_pre_one.sql

DEF skip_lch = '';
DEF title = 'Large Pool Allocated (Gb) per PDB for Instance 3';
DEF abstract = '&&abstract_uom.';
DEF foot = 'Does not include Free SGA Memory Available. For memory pools resize review Memory Statistics reports instead.'
EXEC :sql_text_backup2 := REPLACE(:sql_text_backup, '@instance_number@', '3');
EXEC :sql_text := REPLACE(:sql_text_backup2, '@sgastat_criteria@', 'AND pool = ''large pool''');
@@&&skip_noncdb.&&skip_inst3.&&skip_diagnostics.edb360_9a_pre_one.sql

DEF skip_lch = '';
DEF title = 'Large Pool Allocated (Gb) per PDB for Instance 4';
DEF abstract = '&&abstract_uom.';
DEF foot = 'Does not include Free SGA Memory Available. For memory pools resize review Memory Statistics reports instead.'
EXEC :sql_text_backup2 := REPLACE(:sql_text_backup, '@instance_number@', '4');
EXEC :sql_text := REPLACE(:sql_text_backup2, '@sgastat_criteria@', 'AND pool = ''large pool''');
@@&&skip_noncdb.&&skip_inst4.&&skip_diagnostics.edb360_9a_pre_one.sql

DEF skip_lch = '';
DEF title = 'Large Pool Allocated (Gb) per PDB for Instance 5';
DEF abstract = '&&abstract_uom.';
DEF foot = 'Does not include Free SGA Memory Available. For memory pools resize review Memory Statistics reports instead.'
EXEC :sql_text_backup2 := REPLACE(:sql_text_backup, '@instance_number@', '5');
EXEC :sql_text := REPLACE(:sql_text_backup2, '@sgastat_criteria@', 'AND pool = ''large pool''');
@@&&skip_noncdb.&&skip_inst5.&&skip_diagnostics.edb360_9a_pre_one.sql

DEF skip_lch = '';
DEF title = 'Large Pool Allocated (Gb) per PDB for Instance 6';
DEF abstract = '&&abstract_uom.';
DEF foot = 'Does not include Free SGA Memory Available. For memory pools resize review Memory Statistics reports instead.'
EXEC :sql_text_backup2 := REPLACE(:sql_text_backup, '@instance_number@', '6');
EXEC :sql_text := REPLACE(:sql_text_backup2, '@sgastat_criteria@', 'AND pool = ''large pool''');
@@&&skip_noncdb.&&skip_inst6.&&skip_diagnostics.edb360_9a_pre_one.sql

DEF skip_lch = '';
DEF title = 'Large Pool Allocated (Gb) per PDB for Instance 7';
DEF abstract = '&&abstract_uom.';
DEF foot = 'Does not include Free SGA Memory Available. For memory pools resize review Memory Statistics reports instead.'
EXEC :sql_text_backup2 := REPLACE(:sql_text_backup, '@instance_number@', '7');
EXEC :sql_text := REPLACE(:sql_text_backup2, '@sgastat_criteria@', 'AND pool = ''large pool''');
@@&&skip_noncdb.&&skip_inst7.&&skip_diagnostics.edb360_9a_pre_one.sql

DEF skip_lch = '';
DEF title = 'Large Pool Allocated (Gb) per PDB for Instance 8';
DEF abstract = '&&abstract_uom.';
DEF foot = 'Does not include Free SGA Memory Available. For memory pools resize review Memory Statistics reports instead.'
EXEC :sql_text_backup2 := REPLACE(:sql_text_backup, '@instance_number@', '8');
EXEC :sql_text := REPLACE(:sql_text_backup2, '@sgastat_criteria@', 'AND pool = ''large pool''');
@@&&skip_noncdb.&&skip_inst8.&&skip_diagnostics.edb360_9a_pre_one.sql

DEF skip_lch = '';
DEF title = 'Total Java Pool Allocated (Gb) per PDB for Cluster';
DEF abstract = '&&abstract_uom.';
DEF foot = 'Does not include Free SGA Memory Available. For memory pools resize review Memory Statistics reports instead.'
EXEC :sql_text_backup2 := REPLACE(:sql_text_backup, '@instance_number@', 'instance_number');
EXEC :sql_text := REPLACE(:sql_text_backup2, '@sgastat_criteria@', 'AND pool = ''java pool''');

@@&&skip_noncdb.&&is_single_instance.&&skip_diagnostics.edb360_9a_pre_one.sql

DEF skip_lch = '';
DEF title = 'Java Pool Allocated (Gb) per PDB for Instance 1';
DEF abstract = '&&abstract_uom.';
DEF foot = 'Does not include Free SGA Memory Available. For memory pools resize review Memory Statistics reports instead.'
EXEC :sql_text_backup2 := REPLACE(:sql_text_backup, '@instance_number@', '1');
EXEC :sql_text := REPLACE(:sql_text_backup2, '@sgastat_criteria@', 'AND pool = ''java pool''');
@@&&skip_noncdb.&&skip_inst1.&&skip_diagnostics.edb360_9a_pre_one.sql

DEF skip_lch = '';
DEF title = 'Java Pool Allocated (Gb) per PDB for Instance 2';
DEF abstract = '&&abstract_uom.';
DEF foot = 'Does not include Free SGA Memory Available. For memory pools resize review Memory Statistics reports instead.'
EXEC :sql_text_backup2 := REPLACE(:sql_text_backup, '@instance_number@', '2');
EXEC :sql_text := REPLACE(:sql_text_backup2, '@sgastat_criteria@', 'AND pool = ''java pool''');
@@&&skip_noncdb.&&skip_inst2.&&skip_diagnostics.edb360_9a_pre_one.sql

DEF skip_lch = '';
DEF title = 'Java Pool Allocated (Gb) per PDB for Instance 3';
DEF abstract = '&&abstract_uom.';
DEF foot = 'Does not include Free SGA Memory Available. For memory pools resize review Memory Statistics reports instead.'
EXEC :sql_text_backup2 := REPLACE(:sql_text_backup, '@instance_number@', '3');
EXEC :sql_text := REPLACE(:sql_text_backup2, '@sgastat_criteria@', 'AND pool = ''java pool''');
@@&&skip_noncdb.&&skip_inst3.&&skip_diagnostics.edb360_9a_pre_one.sql

DEF skip_lch = '';
DEF title = 'Java Pool Allocated (Gb) per PDB for Instance 4';
DEF abstract = '&&abstract_uom.';
DEF foot = 'Does not include Free SGA Memory Available. For memory pools resize review Memory Statistics reports instead.'
EXEC :sql_text_backup2 := REPLACE(:sql_text_backup, '@instance_number@', '4');
EXEC :sql_text := REPLACE(:sql_text_backup2, '@sgastat_criteria@', 'AND pool = ''java pool''');
@@&&skip_noncdb.&&skip_inst4.&&skip_diagnostics.edb360_9a_pre_one.sql

DEF skip_lch = '';
DEF title = 'Java Pool Allocated (Gb) per PDB for Instance 5';
DEF abstract = '&&abstract_uom.';
DEF foot = 'Does not include Free SGA Memory Available. For memory pools resize review Memory Statistics reports instead.'
EXEC :sql_text_backup2 := REPLACE(:sql_text_backup, '@instance_number@', '5');
EXEC :sql_text := REPLACE(:sql_text_backup2, '@sgastat_criteria@', 'AND pool = ''java pool''');
@@&&skip_noncdb.&&skip_inst5.&&skip_diagnostics.edb360_9a_pre_one.sql

DEF skip_lch = '';
DEF title = 'Java Pool Allocated (Gb) per PDB for Instance 6';
DEF abstract = '&&abstract_uom.';
DEF foot = 'Does not include Free SGA Memory Available. For memory pools resize review Memory Statistics reports instead.'
EXEC :sql_text_backup2 := REPLACE(:sql_text_backup, '@instance_number@', '6');
EXEC :sql_text := REPLACE(:sql_text_backup2, '@sgastat_criteria@', 'AND pool = ''java pool''');
@@&&skip_noncdb.&&skip_inst6.&&skip_diagnostics.edb360_9a_pre_one.sql

DEF skip_lch = '';
DEF title = 'Java Pool Allocated (Gb) per PDB for Instance 7';
DEF abstract = '&&abstract_uom.';
DEF foot = 'Does not include Free SGA Memory Available. For memory pools resize review Memory Statistics reports instead.'
EXEC :sql_text_backup2 := REPLACE(:sql_text_backup, '@instance_number@', '7');
EXEC :sql_text := REPLACE(:sql_text_backup2, '@sgastat_criteria@', 'AND pool = ''java pool''');
@@&&skip_noncdb.&&skip_inst7.&&skip_diagnostics.edb360_9a_pre_one.sql

DEF skip_lch = '';
DEF title = 'Java Pool Allocated (Gb) per PDB for Instance 8';
DEF abstract = '&&abstract_uom.';
DEF foot = 'Does not include Free SGA Memory Available. For memory pools resize review Memory Statistics reports instead.'
EXEC :sql_text_backup2 := REPLACE(:sql_text_backup, '@instance_number@', '8');
EXEC :sql_text := REPLACE(:sql_text_backup2, '@sgastat_criteria@', 'AND pool = ''java pool''');
@@&&skip_noncdb.&&skip_inst8.&&skip_diagnostics.edb360_9a_pre_one.sql


DEF skip_lch = '';
DEF title = 'Streams Pool Allocated (Gb) per PDB for Cluster';
DEF abstract = '&&abstract_uom.';
DEF foot = 'Does not include Free SGA Memory Available. For memory pools resize review Memory Statistics reports instead.'
EXEC :sql_text_backup2 := REPLACE(:sql_text_backup, '@instance_number@', 'instance_number');
EXEC :sql_text := REPLACE(:sql_text_backup2, '@sgastat_criteria@', 'AND pool = ''streams pool''');

@@&&skip_noncdb.&&is_single_instance.&&skip_diagnostics.edb360_9a_pre_one.sql

DEF skip_lch = '';
DEF title = 'Streams Pool Allocated (Gb) per PDB for Instance 1';
DEF abstract = '&&abstract_uom.';
DEF foot = 'Does not include Free SGA Memory Available. For memory pools resize review Memory Statistics reports instead.'
EXEC :sql_text_backup2 := REPLACE(:sql_text_backup, '@instance_number@', '1');
EXEC :sql_text := REPLACE(:sql_text_backup2, '@sgastat_criteria@', 'AND pool = ''streams pool''');
@@&&skip_noncdb.&&skip_inst1.&&skip_diagnostics.edb360_9a_pre_one.sql

DEF skip_lch = '';
DEF title = 'Streams Pool Allocated (Gb) per PDB for Instance 2';
DEF abstract = '&&abstract_uom.';
DEF foot = 'Does not include Free SGA Memory Available. For memory pools resize review Memory Statistics reports instead.'
EXEC :sql_text_backup2 := REPLACE(:sql_text_backup, '@instance_number@', '2');
EXEC :sql_text := REPLACE(:sql_text_backup2, '@sgastat_criteria@', 'AND pool = ''streams pool''');
@@&&skip_noncdb.&&skip_inst2.&&skip_diagnostics.edb360_9a_pre_one.sql

DEF skip_lch = '';
DEF title = 'Streams Pool Allocated (Gb) per PDB for Instance 3';
DEF abstract = '&&abstract_uom.';
DEF foot = 'Does not include Free SGA Memory Available. For memory pools resize review Memory Statistics reports instead.'
EXEC :sql_text_backup2 := REPLACE(:sql_text_backup, '@instance_number@', '3');
EXEC :sql_text := REPLACE(:sql_text_backup2, '@sgastat_criteria@', 'AND pool = ''streams pool''');
@@&&skip_noncdb.&&skip_inst3.&&skip_diagnostics.edb360_9a_pre_one.sql

DEF skip_lch = '';
DEF title = 'Streams Pool Allocated (Gb) per PDB for Instance 4';
DEF abstract = '&&abstract_uom.';
DEF foot = 'Does not include Free SGA Memory Available. For memory pools resize review Memory Statistics reports instead.'
EXEC :sql_text_backup2 := REPLACE(:sql_text_backup, '@instance_number@', '4');
EXEC :sql_text := REPLACE(:sql_text_backup2, '@sgastat_criteria@', 'AND pool = ''streams pool''');
@@&&skip_noncdb.&&skip_inst4.&&skip_diagnostics.edb360_9a_pre_one.sql

DEF skip_lch = '';
DEF title = 'Streams Pool Allocated (Gb) per PDB for Instance 5';
DEF abstract = '&&abstract_uom.';
DEF foot = 'Does not include Free SGA Memory Available. For memory pools resize review Memory Statistics reports instead.'
EXEC :sql_text_backup2 := REPLACE(:sql_text_backup, '@instance_number@', '5');
EXEC :sql_text := REPLACE(:sql_text_backup2, '@sgastat_criteria@', 'AND pool = ''streams pool''');
@@&&skip_noncdb.&&skip_inst5.&&skip_diagnostics.edb360_9a_pre_one.sql

DEF skip_lch = '';
DEF title = 'Streams Pool Allocated (Gb) per PDB for Instance 6';
DEF abstract = '&&abstract_uom.';
DEF foot = 'Does not include Free SGA Memory Available. For memory pools resize review Memory Statistics reports instead.'
EXEC :sql_text_backup2 := REPLACE(:sql_text_backup, '@instance_number@', '6');
EXEC :sql_text := REPLACE(:sql_text_backup2, '@sgastat_criteria@', 'AND pool = ''streams pool''');
@@&&skip_noncdb.&&skip_inst6.&&skip_diagnostics.edb360_9a_pre_one.sql

DEF skip_lch = '';
DEF title = 'Streams Pool Allocated (Gb) per PDB for Instance 7';
DEF abstract = '&&abstract_uom.';
DEF foot = 'Does not include Free SGA Memory Available. For memory pools resize review Memory Statistics reports instead.'
EXEC :sql_text_backup2 := REPLACE(:sql_text_backup, '@instance_number@', '7');
EXEC :sql_text := REPLACE(:sql_text_backup2, '@sgastat_criteria@', 'AND pool = ''streams pool''');
@@&&skip_noncdb.&&skip_inst7.&&skip_diagnostics.edb360_9a_pre_one.sql

DEF skip_lch = '';
DEF title = 'Streams Pool Allocated (Gb) per PDB for Instance 8';
DEF abstract = '&&abstract_uom.';
DEF foot = 'Does not include Free SGA Memory Available. For memory pools resize review Memory Statistics reports instead.'
EXEC :sql_text_backup2 := REPLACE(:sql_text_backup, '@instance_number@', '8');
EXEC :sql_text := REPLACE(:sql_text_backup2, '@sgastat_criteria@', 'AND pool = ''streams pool''');
@@&&skip_noncdb.&&skip_inst8.&&skip_diagnostics.edb360_9a_pre_one.sql

--dmk end SGASTAT per PDB per INSTANCE



-- Find subpools anywhere in the cluster that have the largest changes.
-- 1st Grouped by Instance because the variances happen inside each instance only.
-- 2nd looking for the max standard deviation in any instance.

DEF title = 'Subpools in the Shared Pool with largest changes';
DEF main_table = '&&cdb_awr_hist_prefix.SGASTAT';
DEF foot = '';

BEGIN
  :sql_text := q'[
WITH calc AS (
SELECT /*+ &&sq_fact_hints. */ /* &&section_id..&&report_sequence. */
       dbid,
	   &&skip_noncdb.con_id,
       instance_number,
       name,
       stddev(bytes) standard_dev
  FROM &&cdb_awr_hist_prefix.sgastat
 WHERE pool='shared pool'
   AND snap_id BETWEEN &&minimum_snap_id. AND &&maximum_snap_id.
   AND dbid = &&edb360_dbid.
 GROUP BY
       dbid,
	   &&skip_noncdb.con_id,
       instance_number,
       name
), calc2 AS (
SELECT /*+ &&sq_fact_hints. */
       dbid,
	   &&skip_noncdb.con_id,
       name,
       max(standard_dev) standard_dev
  FROM calc
 WHERE standard_dev>0
 GROUP BY
       dbid,
	   &&skip_noncdb.con_id,
       name
), ranked AS (
SELECT /*+ &&sq_fact_hints. */ /* &&section_id..&&report_sequence. */
       ROW_NUMBER () OVER (ORDER BY x.standard_dev DESC) srank,
       ROUND(x.standard_dev / 1024 / 1024, 1) mb_std_deviation,
       &&skip_noncdb.x.con_id,
	   x.name subpool_name
	   &&skip_noncdb.,c.name con_name
  FROM calc2 x
       &&skip_noncdb.LEFT OUTER JOIN &&v_object_prefix.containers c ON c.con_id = x.con_id
)
SELECT * FROM ranked ORDER BY srank
]';
END;
/
DEF skip_lch = 'Y';
@@edb360_9a_pre_one.sql

-- Only interested in showing the ones with the largest changes.
COL subpool_01 NEW_V subpool_01;
COL subpool_02 NEW_V subpool_02;
COL subpool_03 NEW_V subpool_03;
COL subpool_04 NEW_V subpool_04;
COL subpool_05 NEW_V subpool_05;
COL subpool_06 NEW_V subpool_06;
COL subpool_07 NEW_V subpool_07;
COL subpool_08 NEW_V subpool_08;
COL subpool_09 NEW_V subpool_09;
COL subpool_10 NEW_V subpool_10;


WITH
calc AS (
SELECT /*+ &&sq_fact_hints. */
       dbid,
	   &&skip_noncdb.con_id,
       instance_number,
       name,
       stddev(bytes) standard_dev
  FROM &&cdb_awr_hist_prefix.sgastat
 WHERE pool='shared pool'
   AND name <>'free memory'
   AND snap_id BETWEEN &&minimum_snap_id. AND &&maximum_snap_id.
   AND dbid = &&edb360_dbid.
 GROUP BY
       dbid,
	   &&skip_noncdb.con_id,
       instance_number,
       name
),calc2 AS (
SELECT /*+ &&sq_fact_hints. */
       dbid,
	   &&skip_noncdb.con_id,
       name,
       max(standard_dev) standard_dev
  FROM calc
 WHERE standard_dev>0
 GROUP BY
       dbid,
	   &&skip_noncdb.con_id,
       name
),ranked AS (
SELECT /*+ &&sq_fact_hints. */
       ROW_NUMBER () OVER (ORDER BY standard_dev DESC) srank,
       ROUND(standard_dev / 1024 / 1024, 1) mb_deviation,
       &&skip_noncdb.con_id,
       name subpool_name
  FROM calc2
)
SELECT MIN(CASE srank WHEN 01 THEN subpool_name &&skip_noncdb.||':'||con_id
           END) subpool_01
      ,MIN(CASE srank WHEN 02 THEN subpool_name &&skip_noncdb.||':'||con_id
           END) subpool_02
      ,MIN(CASE srank WHEN 03 THEN subpool_name &&skip_noncdb.||':'||con_id
           END) subpool_03
      ,MIN(CASE srank WHEN 04 THEN subpool_name &&skip_noncdb.||':'||con_id
           END) subpool_04
      ,MIN(CASE srank WHEN 05 THEN subpool_name &&skip_noncdb.||':'||con_id
	       END) subpool_05
      ,MIN(CASE srank WHEN 06 THEN subpool_name &&skip_noncdb.||':'||con_id
	       END) subpool_06
      ,MIN(CASE srank WHEN 07 THEN subpool_name &&skip_noncdb.||':'||con_id
	       END) subpool_07
      ,MIN(CASE srank WHEN 08 THEN subpool_name &&skip_noncdb.||':'||con_id
	       END) subpool_08
      ,MIN(CASE srank WHEN 09 THEN subpool_name &&skip_noncdb.||':'||con_id
	       END) subpool_09
      ,MIN(CASE srank WHEN 10 THEN subpool_name &&skip_noncdb.||':'||con_id
           END) subpool_10
  FROM ranked;

COL tit_subpool_01 NEW_V tit_subpool_01;
COL tit_subpool_02 NEW_V tit_subpool_02;
COL tit_subpool_03 NEW_V tit_subpool_03;
COL tit_subpool_04 NEW_V tit_subpool_04;
COL tit_subpool_05 NEW_V tit_subpool_05;
COL tit_subpool_06 NEW_V tit_subpool_06;
COL tit_subpool_07 NEW_V tit_subpool_07;
COL tit_subpool_08 NEW_V tit_subpool_08;
COL tit_subpool_09 NEW_V tit_subpool_09;
COL tit_subpool_10 NEW_V tit_subpool_10;

SELECT  CASE WHEN length('&&subpool_01.')>30 THEN substr('1)'||'&&subpool_01.',1,30) ELSE '&&subpool_01.' END tit_subpool_01,
        CASE WHEN length('&&subpool_02.')>30 THEN substr('2)'||'&&subpool_02.',1,30) ELSE '&&subpool_02.' END tit_subpool_02,
        CASE WHEN length('&&subpool_03.')>30 THEN substr('3)'||'&&subpool_03.',1,30) ELSE '&&subpool_03.' END tit_subpool_03,
        CASE WHEN length('&&subpool_04.')>30 THEN substr('4)'||'&&subpool_04.',1,30) ELSE '&&subpool_04.' END tit_subpool_04,
        CASE WHEN length('&&subpool_05.')>30 THEN substr('5)'||'&&subpool_05.',1,30) ELSE '&&subpool_05.' END tit_subpool_05,
        CASE WHEN length('&&subpool_06.')>30 THEN substr('6)'||'&&subpool_06.',1,30) ELSE '&&subpool_06.' END tit_subpool_06,
        CASE WHEN length('&&subpool_07.')>30 THEN substr('7)'||'&&subpool_07.',1,30) ELSE '&&subpool_07.' END tit_subpool_07,
        CASE WHEN length('&&subpool_08.')>30 THEN substr('8)'||'&&subpool_08.',1,30) ELSE '&&subpool_08.' END tit_subpool_08,
        CASE WHEN length('&&subpool_09.')>30 THEN substr('9)'||'&&subpool_09.',1,30) ELSE '&&subpool_09.' END tit_subpool_09,
        CASE WHEN length('&&subpool_10.')>30 THEN substr('A)'||'&&subpool_10.',1,30) ELSE '&&subpool_10.' END tit_subpool_10        
  FROM DUAL;
  
COL predexpr NEW_V predexpr
COL predqexpr NEW_V predqexpr
SELECT 'subpool' &&skip_noncdb.||'||'':''||con_id'
       predexpr
,      'name' &&skip_noncdb.||'||'''':''''||con_id'
       predqexpr
FROM DUAL;

DEF main_table = '&&cdb_awr_hist_prefix.SGASTAT';
DEF chartype = 'LineChart';
DEF stacked = '';
DEF vaxis = 'Allocation in MBs';
DEF vbaseline = '';

COL tit_01 NEW_V tit_01
COL tit_02 NEW_V tit_02
COL tit_03 NEW_V tit_03
COL tit_04 NEW_V tit_04
COL tit_05 NEW_V tit_05
COL tit_06 NEW_V tit_06
COL tit_07 NEW_V tit_07
COL tit_08 NEW_V tit_08

SELECT NVL2('&&inst1_present.','Inst 1','') tit_01,
       NVL2('&&inst2_present.','Inst 2','') tit_02,
       NVL2('&&inst3_present.','Inst 3','') tit_03,
       NVL2('&&inst4_present.','Inst 4','') tit_04,
       NVL2('&&inst5_present.','Inst 5','') tit_05,
       NVL2('&&inst6_present.','Inst 6','') tit_06,
       NVL2('&&inst7_present.','Inst 7','') tit_07,
       NVL2('&&inst8_present.','Inst 8','') tit_08
  FROM DUAL;

DEF tit_09 = '';
DEF tit_10 = '';
DEF tit_11 = '';
DEF tit_12 = '';
DEF tit_13 = '';
DEF tit_14 = '';
DEF tit_15 = '';

BEGIN
  :sql_text_backup := q'[
WITH
sgastat_denorm_1 AS (
SELECT /*+ &&sq_fact_hints. */ /* &&section_id..&&report_sequence. */
       snap_id,
       dbid,
       instance_number,
       SUM(bytes) allocated
  FROM &&cdb_awr_hist_prefix.sgastat
 WHERE snap_id BETWEEN &&minimum_snap_id. AND &&maximum_snap_id.
   AND dbid = &&edb360_dbid.
   AND pool = 'shared pool'
   AND @filter_predicate@
 GROUP BY
       snap_id,
       dbid,
       instance_number
), sgastat_denorm_2 AS (
SELECT /*+ &&sq_fact_hints. */
       h1.snap_id,
       h1.dbid,
       h1.instance_number,
       s1.begin_interval_time,
       s1.end_interval_time,
       ROUND((CAST(s1.end_interval_time AS DATE) - CAST(s1.begin_interval_time AS DATE)) * 24 * 60 * 60) interval_secs,
       h1.allocated
  FROM sgastat_denorm_1 h0,
       sgastat_denorm_1 h1,
       &&cdb_awr_hist_prefix.snapshot s0,
       &&cdb_awr_hist_prefix.snapshot s1
 WHERE h1.snap_id = h0.snap_id + 1
   AND h1.dbid = h0.dbid
   AND h1.instance_number = h0.instance_number
   AND s0.snap_id = h0.snap_id
   AND s0.dbid = h0.dbid
   AND s0.instance_number = h0.instance_number
   AND s0.snap_id BETWEEN &&minimum_snap_id. AND &&maximum_snap_id.
   AND s0.dbid = &&edb360_dbid.
   AND s1.snap_id = h1.snap_id
   AND s1.dbid = h1.dbid
   AND s1.instance_number = h1.instance_number
   AND s1.snap_id = s0.snap_id + 1
   AND s1.startup_time = s0.startup_time
   AND s1.begin_interval_time > (s0.begin_interval_time + (1 / (24 * 60))) /* filter out snaps apart < 1 min */
)
SELECT snap_id,
       TO_CHAR(MIN(begin_interval_time), 'YYYY-MM-DD HH24:MI:SS') begin_time,
       TO_CHAR(MIN(end_interval_time), 'YYYY-MM-DD HH24:MI:SS') end_time,
       0 dummy_01, --ROUND(SUM(CASE instance_number WHEN 1 THEN allocated ELSE 0 END)/POWER(2,20), 3) inst_01,
       0 dummy_02, --ROUND(SUM(CASE instance_number WHEN 2 THEN allocated ELSE 0 END)/POWER(2,20), 3) inst_02,
       0 dummy_03, --ROUND(SUM(CASE instance_number WHEN 3 THEN allocated ELSE 0 END)/POWER(2,20), 3) inst_03,
       0 dummy_04, --ROUND(SUM(CASE instance_number WHEN 4 THEN allocated ELSE 0 END)/POWER(2,20), 3) inst_04,
       0 dummy_05, --ROUND(SUM(CASE instance_number WHEN 5 THEN allocated ELSE 0 END)/POWER(2,20), 3) inst_05,
       0 dummy_06, --ROUND(SUM(CASE instance_number WHEN 6 THEN allocated ELSE 0 END)/POWER(2,20), 3) inst_06,
       0 dummy_07, --ROUND(SUM(CASE instance_number WHEN 7 THEN allocated ELSE 0 END)/POWER(2,20), 3) inst_07,
       0 dummy_08, --ROUND(SUM(CASE instance_number WHEN 8 THEN allocated ELSE 0 END)/POWER(2,20), 3) inst_08,
       0 dummy_09,
       0 dummy_10,
       0 dummy_11,
       0 dummy_12,
       0 dummy_13,
       0 dummy_14,
       0 dummy_15
  FROM sgastat_denorm_2
 GROUP BY
       snap_id
 ORDER BY
       snap_id
]';

 :sql_text_backup:=(CASE WHEN '&&inst1_present' IS NOT NULL THEN REPLACE(:sql_text_backup,'0 dummy_01, --','') ELSE :sql_text_backup END);
 :sql_text_backup:=(CASE WHEN '&&inst2_present' IS NOT NULL THEN REPLACE(:sql_text_backup,'0 dummy_02, --','') ELSE :sql_text_backup END);
 :sql_text_backup:=(CASE WHEN '&&inst3_present' IS NOT NULL THEN REPLACE(:sql_text_backup,'0 dummy_03, --','') ELSE :sql_text_backup END);
 :sql_text_backup:=(CASE WHEN '&&inst4_present' IS NOT NULL THEN REPLACE(:sql_text_backup,'0 dummy_04, --','') ELSE :sql_text_backup END);
 :sql_text_backup:=(CASE WHEN '&&inst5_present' IS NOT NULL THEN REPLACE(:sql_text_backup,'0 dummy_05, --','') ELSE :sql_text_backup END);
 :sql_text_backup:=(CASE WHEN '&&inst6_present' IS NOT NULL THEN REPLACE(:sql_text_backup,'0 dummy_06, --','') ELSE :sql_text_backup END);
 :sql_text_backup:=(CASE WHEN '&&inst7_present' IS NOT NULL THEN REPLACE(:sql_text_backup,'0 dummy_07, --','') ELSE :sql_text_backup END);
 :sql_text_backup:=(CASE WHEN '&&inst8_present' IS NOT NULL THEN REPLACE(:sql_text_backup,'0 dummy_08, --','') ELSE :sql_text_backup END);

for i in (select instance_number n from &&gv_object_prefix.instance order by 1) loop
 :sql_text_backup:=REPLACE(:sql_text_backup,'0 dummy_'||to_char(i.n,'fm09')||', --','');
END LOOP;
END;
/

DEF skip_lch = '';
DEF skip_all = 'Y';
SELECT NULL skip_all FROM dual WHERE '&&subpool_01' is not null;
DEF title = 'Memory allocation for "&&subpool_01"';
DEF abstract = '&&abstract_uom.';
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', '&&predqexpr = ''&&subpool_01''');
@@&&skip_all.&&skip_diagnostics.edb360_9a_pre_one.sql

DEF skip_lch = '';
DEF skip_all = 'Y';
SELECT NULL skip_all FROM dual WHERE '&&subpool_02' is not null;
DEF title = 'Memory allocation for "&&subpool_02"';
DEF abstract = '&&abstract_uom.';
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', '&&predqexpr = ''&&subpool_02''');
@@&&skip_all.&&skip_diagnostics.edb360_9a_pre_one.sql

DEF skip_lch = '';
DEF skip_all = 'Y';
SELECT NULL skip_all FROM dual WHERE '&&subpool_03' is not null;
DEF title = 'Memory allocation for "&&subpool_03"';
DEF abstract = '&&abstract_uom.';
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', '&&predqexpr = ''&&subpool_03''');
@@&&skip_all.&&skip_diagnostics.edb360_9a_pre_one.sql

DEF skip_lch = '';
DEF skip_all = 'Y';
SELECT NULL skip_all FROM dual WHERE '&&subpool_04' is not null;
DEF title = 'Memory allocation for "&&subpool_04"';
DEF abstract = '&&abstract_uom.';
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', '&&predqexpr = ''&&subpool_04''');
@@&&skip_all.&&skip_diagnostics.edb360_9a_pre_one.sql

DEF skip_lch = '';
DEF skip_all = 'Y';
SELECT NULL skip_all FROM dual WHERE '&&subpool_05' is not null;
DEF title = 'Memory allocation for "&&subpool_05"';
DEF abstract = '&&abstract_uom.';
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', '&&predqexpr = ''&&subpool_05''');
@@&&skip_all.&&skip_diagnostics.edb360_9a_pre_one.sql

DEF skip_lch = '';
DEF skip_all = 'Y';
SELECT NULL skip_all FROM dual WHERE '&&subpool_06' is not null;
DEF title = 'Memory allocation for "&&subpool_06"';
DEF abstract = '&&abstract_uom.';
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', '&&predqexpr = ''&&subpool_06''');
@@&&skip_all.&&skip_diagnostics.edb360_9a_pre_one.sql

DEF skip_lch = '';
DEF skip_all = 'Y';
SELECT NULL skip_all FROM dual WHERE '&&subpool_07' is not null;
DEF title = 'Memory allocation for "&&subpool_07"';
DEF abstract = '&&abstract_uom.';
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', '&&predqexpr = ''&&subpool_07''');
@@&&skip_all.&&skip_diagnostics.edb360_9a_pre_one.sql

DEF skip_lch = '';
DEF skip_all = 'Y';
SELECT NULL skip_all FROM dual WHERE '&&subpool_08' is not null;
DEF title = 'Memory allocation for "&&subpool_08"';
DEF abstract = '&&abstract_uom.';
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', '&&predqexpr = ''&&subpool_08''');
@@&&skip_all.&&skip_diagnostics.edb360_9a_pre_one.sql

DEF skip_lch = '';
DEF skip_all = 'Y';
SELECT NULL skip_all FROM dual WHERE '&&subpool_09' is not null;
DEF title = 'Memory allocation for "&&subpool_09"';
DEF abstract = '&&abstract_uom.';
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', '&&predqexpr = ''&&subpool_09''');
@@&&skip_all.&&skip_diagnostics.edb360_9a_pre_one.sql

DEF skip_lch = '';
DEF skip_all = 'Y';
SELECT NULL skip_all FROM dual WHERE '&&subpool_10' is not null;
DEF title = 'Memory allocation for "&&subpool_10"';
DEF abstract = '&&abstract_uom.';
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', '&&predqexpr = ''&&subpool_10''');
@@&&skip_all.&&skip_diagnostics.edb360_9a_pre_one.sql

DEF skip_lch = '';
DEF skip_all = '';
DEF title = 'Free Memory in Shared Pool';
DEF vaxis = 'Free Memory in MBs';
DEF main_table = '&&cdb_awr_hist_prefix.sgastat';
DEF abstract = '&&abstract_uom.';
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', 'name = ''free memory''');
@@&&skip_diagnostics.edb360_9a_pre_one.sql

BEGIN
  :sql_text_backup := q'[
WITH
sgastat_denorm_1 AS (
SELECT /*+ &&sq_fact_hints. */ /* &&section_id..&&report_sequence. */
       &&skip_noncdb.con_id,
       snap_id,
       dbid,
       name subpool,
       instance_number,
       SUM(bytes) allocated
  FROM &&cdb_awr_hist_prefix.sgastat
 WHERE snap_id BETWEEN &&minimum_snap_id. AND &&maximum_snap_id.
   AND dbid = &&edb360_dbid.
   AND pool = 'shared pool'
   AND @filter_predicate@
 GROUP BY
       &&skip_noncdb.con_id,
       snap_id,
       dbid,
       name,
       instance_number
), sgastat_denorm_2 AS (
SELECT /*+ &&sq_fact_hints. */
       h1.snap_id,
       h1.dbid,
       &&skip_noncdb.h1.con_id,
       h1.subpool,
       s1.begin_interval_time,
       s1.end_interval_time,
       ROUND((CAST(s1.end_interval_time AS DATE) - CAST(s1.begin_interval_time AS DATE)) * 24 * 60 * 60) interval_secs,
       h1.allocated
  FROM sgastat_denorm_1 h0,
       sgastat_denorm_1 h1,
       &&cdb_awr_hist_prefix.snapshot s0,
       &&cdb_awr_hist_prefix.snapshot s1
 WHERE h1.snap_id = h0.snap_id + 1
   &&skip_noncdb. AND h1.con_id = h0.con_id
   AND h1.dbid = h0.dbid
   AND h1.instance_number = h0.instance_number
   AND h1.subpool=h0.subpool
   AND s0.snap_id = h0.snap_id
   AND s0.dbid = h0.dbid
   AND s0.instance_number = h0.instance_number
   AND s0.snap_id BETWEEN &&minimum_snap_id. AND &&maximum_snap_id.
   AND s0.dbid = &&edb360_dbid.
   AND s1.snap_id = h1.snap_id
   AND s1.dbid = h1.dbid
   AND s1.instance_number = h1.instance_number
   AND s1.snap_id = s0.snap_id + 1
   AND s1.startup_time = s0.startup_time
   AND s1.begin_interval_time > (s0.begin_interval_time + (1 / (24 * 60))) /* filter out snaps apart < 1 min */
)
SELECT snap_id,
       TO_CHAR(MIN(begin_interval_time), 'YYYY-MM-DD HH24:MI:SS') begin_time,
       TO_CHAR(MIN(end_interval_time), 'YYYY-MM-DD HH24:MI:SS') end_time,
       ROUND(SUM(CASE subpool WHEN 'free memory' THEN allocated ELSE 0 END)/POWER(2,20), 3) free_memory,
       ROUND(SUM(CASE WHEN &&predexpr not in ('&&subpool_01.','&&subpool_02.','&&subpool_03.','&&subpool_04.',
           '&&subpool_05.','&&subpool_06.','&&subpool_07.','&&subpool_08.','&&subpool_09.','&&subpool_10.',
           'free memory' )
       THEN allocated ELSE 0 END)/POWER(2,20), 3) others,
                     ROUND(SUM(CASE &&predexpr WHEN '&&subpool_01.' THEN allocated ELSE 0 END)/POWER(2,20), 3) "&&tit_subpool_01.",
       0 dummy_02, --ROUND(SUM(CASE &&predexpr WHEN '&&subpool_02.' THEN allocated ELSE 0 END)/POWER(2,20), 3) "&&tit_subpool_02.",
       0 dummy_03, --ROUND(SUM(CASE &&predexpr WHEN '&&subpool_03.' THEN allocated ELSE 0 END)/POWER(2,20), 3) "&&tit_subpool_03.",
       0 dummy_04, --ROUND(SUM(CASE &&predexpr WHEN '&&subpool_04.' THEN allocated ELSE 0 END)/POWER(2,20), 3) "&&tit_subpool_04.",
       0 dummy_05, --ROUND(SUM(CASE &&predexpr WHEN '&&subpool_05.' THEN allocated ELSE 0 END)/POWER(2,20), 3) "&&tit_subpool_05.",
       0 dummy_06, --ROUND(SUM(CASE &&predexpr WHEN '&&subpool_06.' THEN allocated ELSE 0 END)/POWER(2,20), 3) "&&tit_subpool_06.",
       0 dummy_07, --ROUND(SUM(CASE &&predexpr WHEN '&&subpool_07.' THEN allocated ELSE 0 END)/POWER(2,20), 3) "&&tit_subpool_07.",
       0 dummy_08, --ROUND(SUM(CASE &&predexpr WHEN '&&subpool_08.' THEN allocated ELSE 0 END)/POWER(2,20), 3) "&&tit_subpool_08.",
       0 dummy_09, --ROUND(SUM(CASE &&predexpr WHEN '&&subpool_09.' THEN allocated ELSE 0 END)/POWER(2,20), 3) "&&tit_subpool_09.",
       0 dummy_10, --ROUND(SUM(CASE &&predexpr WHEN '&&subpool_10.' THEN allocated ELSE 0 END)/POWER(2,20), 3) "&&tit_subpool_10.",
        0 dummy_11,
       0 dummy_12,
       0 dummy_13
  FROM sgastat_denorm_2
 GROUP BY
       snap_id
 ORDER BY
       snap_id
]';

 :sql_text_backup:=(CASE WHEN '&&subpool_02.' IS NOT NULL THEN REPLACE(:sql_text_backup,'0 dummy_02, --','') ELSE :sql_text_backup END);
 :sql_text_backup:=(CASE WHEN '&&subpool_03.' IS NOT NULL THEN REPLACE(:sql_text_backup,'0 dummy_03, --','') ELSE :sql_text_backup END);
 :sql_text_backup:=(CASE WHEN '&&subpool_04.' IS NOT NULL THEN REPLACE(:sql_text_backup,'0 dummy_04, --','') ELSE :sql_text_backup END);
 :sql_text_backup:=(CASE WHEN '&&subpool_05.' IS NOT NULL THEN REPLACE(:sql_text_backup,'0 dummy_05, --','') ELSE :sql_text_backup END);
 :sql_text_backup:=(CASE WHEN '&&subpool_06.' IS NOT NULL THEN REPLACE(:sql_text_backup,'0 dummy_06, --','') ELSE :sql_text_backup END);
 :sql_text_backup:=(CASE WHEN '&&subpool_07.' IS NOT NULL THEN REPLACE(:sql_text_backup,'0 dummy_07, --','') ELSE :sql_text_backup END);
 :sql_text_backup:=(CASE WHEN '&&subpool_08.' IS NOT NULL THEN REPLACE(:sql_text_backup,'0 dummy_08, --','') ELSE :sql_text_backup END);
 :sql_text_backup:=(CASE WHEN '&&subpool_09.' IS NOT NULL THEN REPLACE(:sql_text_backup,'0 dummy_09, --','') ELSE :sql_text_backup END);
 :sql_text_backup:=(CASE WHEN '&&subpool_10.' IS NOT NULL THEN REPLACE(:sql_text_backup,'0 dummy_10, --','') ELSE :sql_text_backup END);

END;
/

SELECT 'Free memory' tit_01,
       'Others' tit_02,
        '&&tit_subpool_01.' tit_03,
        '&&tit_subpool_02.' tit_04,
        '&&tit_subpool_03.' tit_05,
        '&&tit_subpool_04.' tit_06,
        '&&tit_subpool_05.' tit_07,
        '&&tit_subpool_06.' tit_08,
        '&&tit_subpool_07.' tit_09,
        '&&tit_subpool_08.' tit_10,
        '&&tit_subpool_09.' tit_11,
        '&&tit_subpool_10.' tit_12        
  FROM DUAL;


DEF vaxis = 'Memory in MBs';
DEF chartype = 'AreaChart';
DEF stacked = 'isStacked: ''true'',';
DEF skip_lch = '';
DEF title = 'Memory allocations in Shared Pool for instance 1';
DEF abstract = '&&abstract_uom.';
--DEF foot = 'Does not include Free SGA Memory Available. For memory pools resize review Memory Statistics reports instead.'
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', 'instance_number = 1');
@@&&skip_inst1.&&skip_diagnostics.edb360_9a_pre_one.sql

DEF skip_lch = '';
DEF title = 'Memory allocations in Shared Pool for instance 2';
DEF abstract = '&&abstract_uom.';
--DEF foot = 'Does not include Free SGA Memory Available. For memory pools resize review Memory Statistics reports instead.'
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', 'instance_number = 2');
@@&&skip_inst2.&&skip_diagnostics.edb360_9a_pre_one.sql

DEF skip_lch = '';
DEF title = 'Memory allocations in Shared Pool for instance 3';
DEF abstract = '&&abstract_uom.';
--DEF foot = 'Does not include Free SGA Memory Available. For memory pools resize review Memory Statistics reports instead.'
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', 'instance_number = 3');
@@&&skip_inst3.&&skip_diagnostics.edb360_9a_pre_one.sql

DEF skip_lch = '';
DEF title = 'Memory allocations in Shared Pool for instance 4';
DEF abstract = '&&abstract_uom.';
--DEF foot = 'Does not include Free SGA Memory Available. For memory pools resize review Memory Statistics reports instead.'
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', 'instance_number = 4');
@@&&skip_inst4.&&skip_diagnostics.edb360_9a_pre_one.sql

DEF skip_lch = '';
DEF title = 'Memory allocations in Shared Pool for instance 5';
DEF abstract = '&&abstract_uom.';
--DEF foot = 'Does not include Free SGA Memory Available. For memory pools resize review Memory Statistics reports instead.'
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', 'instance_number = 5');
@@&&skip_inst5.&&skip_diagnostics.edb360_9a_pre_one.sql

DEF skip_lch = '';
DEF title = 'Memory allocations in Shared Pool for instance 6';
DEF abstract = '&&abstract_uom.';
--DEF foot = 'Does not include Free SGA Memory Available. For memory pools resize review Memory Statistics reports instead.'
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', 'instance_number = 6');
@@&&skip_inst6.&&skip_diagnostics.edb360_9a_pre_one.sql

DEF skip_lch = '';
DEF title = 'Memory allocations in Shared Pool for instance 7';
DEF abstract = '&&abstract_uom.';
--DEF foot = 'Does not include Free SGA Memory Available. For memory pools resize review Memory Statistics reports instead.'
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', 'instance_number = 7');
@@&&skip_inst7.&&skip_diagnostics.edb360_9a_pre_one.sql

DEF skip_lch = '';
DEF title = 'Memory allocations in Shared Pool for instance 8';
DEF abstract = '&&abstract_uom.';
--DEF foot = 'Does not include Free SGA Memory Available. For memory pools resize review Memory Statistics reports instead.'
EXEC :sql_text := REPLACE(:sql_text_backup, '@filter_predicate@', 'instance_number = 8');
@@&&skip_inst8.&&skip_diagnostics.edb360_9a_pre_one.sql

SPO &&edb360_main_report..html APP;
PRO </ol>
SPO OFF;
