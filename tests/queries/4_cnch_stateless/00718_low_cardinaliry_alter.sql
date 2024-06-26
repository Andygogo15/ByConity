

drop table if exists tab;
create table tab (a String, b LowCardinality(UInt32)) engine = CnchMergeTree order by a;
insert into tab values ('a', 1);
select *, toTypeName(b) from tab;
alter table tab modify column b UInt32;
-- wait task finish
SELECT sleepEachRow(3) FROM numbers(30) FORMAT Null;

select *, toTypeName(b) from tab;
alter table tab modify column b LowCardinality(UInt32);
-- wait task finish
SELECT sleepEachRow(3) FROM numbers(30) FORMAT Null;

select *, toTypeName(b) from tab;
alter table tab modify column b StringWithDictionary;
-- wait task finish
SELECT sleepEachRow(3) FROM numbers(30) FORMAT Null;

select *, toTypeName(b) from tab;
alter table tab modify column b LowCardinality(UInt32);
-- wait task finish
SELECT sleepEachRow(3) FROM numbers(30) FORMAT Null;

select *, toTypeName(b) from tab;
alter table tab modify column b String;
-- wait task finish
SELECT sleepEachRow(3) FROM numbers(30) FORMAT Null;

select *, toTypeName(b) from tab;
alter table tab modify column b LowCardinality(UInt32);
-- wait task finish
SELECT sleepEachRow(3) FROM numbers(30) FORMAT Null;

select *, toTypeName(b) from tab;
drop table if exists tab;

