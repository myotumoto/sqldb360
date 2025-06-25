SPO 00002_edb360_335833_log.txt APP;
PRO PRO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
PRO PRO plan_table after calling sqld360
SELECT operation||' '||object_node||' '||remarks FROM plan_table WHERE statement_id = 'SQLD360_SQLID';
SPO OFF;
HOS zip -j edb360_335833_523132_20250305_1744 00002_edb360_335833_log.txt >> 00004_edb360_335833_log3.txt
HOS zip -j edb360_335833_523132_20250305_1744 00004_edb360_335833_log3.txt
HOS mv sqld360_335833_5rurx5xtjwcu2_523132_20250305_1821.zip sqld360_335833_5rurx5xtjwcu2_523132_20250305_1744.zip >> 00004_edb360_335833_log3.txt
HOS zip -mj edb360_335833_523132_20250305_1744 sqld360_335833_5rurx5xtjwcu2_523132_20250305_1744.zip >> 00004_edb360_335833_log3.txt
SPO 00002_edb360_335833_log.txt APP;
PRO PRO just in case individual file "mv" failed
HOS zip -mj edb360_335833_523132_20250305_1744 sqld360_*.zip >> 00004_edb360_335833_log3.txt
SPO OFF;
HOS zip -j edb360_335833_523132_20250305_1744 00002_edb360_335833_log.txt >> 00004_edb360_335833_log3.txt
HOS zip -j edb360_335833_523132_20250305_1744 00004_edb360_335833_log3.txt
SPO 00002_edb360_335833_log.txt APP;
PRO PRO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
PRO PRO changes PDB to DBRHU
ALTER SESSION SET CONTAINER = DBRHU;
PRO PRO ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SPO OFF;
HOS zip -j edb360_335833_523132_20250305_1744 00002_edb360_335833_log.txt >> 00004_edb360_335833_log3.txt
HOS zip -j edb360_335833_523132_20250305_1744 00004_edb360_335833_log3.txt
