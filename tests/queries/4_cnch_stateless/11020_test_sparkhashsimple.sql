--- reference data is generated by spark-3.2

select 'int8 type';
select n, sparkHashSimple(n) from (select toInt8(number) as n from (select number from system.numbers limit 10 offset 1)) order by n format CSV;

select 'int16 type';
select n, sparkHashSimple(n) from (select toInt16(number) as n from (select number from system.numbers limit 10 offset 1)) order by n format CSV;

select 'int32 type';
select n, sparkHashSimple(n) from (select toInt32(number) as n from (select number from system.numbers limit 10 offset 1)) order by n format CSV;

select 'int64 type';
select n, sparkHashSimple(n) from (select toInt64(number) as n from (select number from system.numbers limit 10 offset 1)) order by n format CSV;

select 'large int32';
select n, sparkHashSimple(n) from (select toInt32(number) as n from (select number from system.numbers limit 10 offset 1000000001)) order by n format CSV;

select 'large int64';
select n, sparkHashSimple(n) from (select toInt64(number) as n from (select number from system.numbers limit 10 offset 10000000001)) order by n format CSV;

-- String Type
select 'convert int32 as string';
select n, sparkHashSimple(n) from (select toString(toInt32(number)) as n from (select number from system.numbers limit 10 offset 1)) order by n format CSV;


select 'convert large int64 as string';
select n, sparkHashSimple(n) from (select toString(toInt64(number)) as n from (select number from system.numbers limit 10 offset 10000000001)) order by n format CSV;
