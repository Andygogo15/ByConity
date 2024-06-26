-- Tags: no-fasttest

SELECT '--JSONLength--';
SELECT JSONLength('{"a": "hello", "b": [-100, 200.0, 300]}'::Object('json'));
SELECT JSONLength('{"a": "hello", "b": [-100, 200.0, 300]}'::Object('json'), 'b');
SELECT JSONLength('{}'::Object('json'));

SELECT '--JSONHas--';
SELECT JSONHas('{"a": "hello", "b": [-100, 200.0, 300]}'::Object('json'), 'a');
SELECT JSONHas('{"a": "hello", "b": [-100, 200.0, 300]}'::Object('json'), 'b');
SELECT JSONHas('{"a": "hello", "b": [-100, 200.0, 300]}'::Object('json'), 'c');

SELECT '--isValidJSON--';
SELECT isValidJSON('{"a": "hello", "b": [-100, 200.0, 300]}'::Object('json'));

SELECT '--JSONKey--';
SELECT JSONKey('{"a": "hello", "b": [-100, 200.0, 300]}'::Object('json'), 1);
SELECT JSONKey('{"a": "hello", "b": [-100, 200.0, 300]}'::Object('json'), 2);
SELECT JSONKey('{"a": "hello", "b": [-100, 200.0, 300]}'::Object('json'), -1);
SELECT JSONKey('{"a": "hello", "b": [-100, 200.0, 300]}'::Object('json'), -2);

SELECT '--JSONType--';
SELECT JSONType('{"a": "hello", "b": [-100, 200.0, 300]}'::Object('json'));
SELECT JSONType('{"a": "hello", "b": [-100, 200.0, 300]}'::Object('json'), 'b');

SELECT '--JSONExtract<numeric>--';
SELECT JSONExtractInt('{"a": "hello", "b": [-100, 200.0, 300]}'::Object('json'), 'b', 1);
SELECT JSONExtractFloat('{"a": "hello", "b": [-100, 200.0, 300]}'::Object('json'), 'b', 2);
SELECT JSONExtractUInt('{"a": "hello", "b": [-100, 200.0, 300]}'::Object('json'), 'b', -1);
SELECT JSONExtractBool('{"passed": true}'::Object('json'), 'passed');

SELECT '--JSONExtractString--';
SELECT JSONExtractString('{"a": "hello", "b": [-100, 200.0, 300]}'::Object('json'), 'a');
SELECT JSONExtractString('{"a": "hello", "b": [-100, 200.0, 300]}'::Object('json'), 1);
select JSONExtractString('{"abc":"\\n\\u0000"}'::Object('json'), 'abc');
select JSONExtractString('{"abc":"\\u263a"}'::Object('json'), 'abc');

SELECT '--JSONExtract (generic)--';
SELECT JSONExtract('{"a": "hello", "b": "world"}'::Object('json'), 'Map(String, String)');
SELECT JSONExtract('{"a": "hello", "b": "world"}'::Object('json'), 'Map(LowCardinality(String), String)');
-- SELECT JSONExtract('{"a": ["hello", 100.0], "b": ["world", 200]}'::Object('json'), 'Map(String, Tuple(String, Float64))');
-- expect {'a':('hello',100),'b':('world',200)}
SELECT JSONExtract('{"a": [100.0, 200], "b": [-100, 200.0, 300]}'::Object('json'), 'Map(String, Array(Float64))');
SELECT JSONExtract('{"a": "hello", "b": [-100, 200.0, 300]}'::Object('json'), 'Map(String, String)');
SELECT JSONExtract('{"a": "hello", "b": [-100, 200.0, 300]}'::Object('json'), 'Map(String, UInt8)');
SELECT JSONExtract('{"a": "hello", "b": [-100, 200.0, 300]}'::Object('json'), 'Map(UInt8, String)'); -- { serverError 43 }
SELECT JSONExtract('{"a": {"c": "hello"}, "b": {"d": "world"}}'::Object('json'), 'Map(String, Map(String, String))');
SELECT JSONExtract('{"a": {"c": "hello"}, "b": {"d": "world"}}'::Object('json'), 'a',  'Map(String, String)');
SELECT JSONExtract('{"a": {"c": "hello"}, "b": {"d": "world"}}'::Object('json'), 'Map(String, String)');
SELECT JSONExtract('{"a": "hello", "b": [-100, 200.0, 300]}'::Object('json'), 'Tuple(String, Array(Float64))');
SELECT JSONExtract('{"a": "hello", "b": [-100, 200.0, 300]}'::Object('json'), 'Tuple(a String, b Array(Float64))');
SELECT JSONExtract('{"a": "hello", "b": [-100, 200.0, 300]}'::Object('json'), 'Tuple(b Array(Float64), a String)');
SELECT JSONExtract('{"a": "hello", "b": [-100, 200.0, 300]}'::Object('json'), 'Tuple(a FixedString(6), c UInt8)');
SELECT JSONExtract('{"a": "hello", "b": [-100, 200.0, 300]}'::Object('json'), 'a', 'String');
SELECT JSONExtract('{"a": "hello", "b": [-100, 200.0, 300]}'::Object('json'), 'b', 'Array(Float32)');
SELECT JSONExtract('{"a": "hello", "b": [-100, 200.0, 300]}'::Object('json'), 'b', 'Array(Int8)');
SELECT JSONExtract('{"a": "hello", "b": [-100, 200.0, 300]}'::Object('json'), 'b', 'Array(Nullable(Int8))');
SELECT JSONExtract('{"a": "hello", "b": [-100, 200.0, 300]}'::Object('json'), 'b', 'Array(UInt8)');
SELECT JSONExtract('{"a": "hello", "b": [-100, 200.0, 300]}'::Object('json'), 'b', 'Array(Nullable(UInt8))');
SELECT JSONExtract('{"a": "hello", "b": [-100, 200.0, 300]}'::Object('json'), 'b', 1, 'Int8');
SELECT JSONExtract('{"a": "hello", "b": [-100, 200.0, 300]}'::Object('json'), 'b', 2, 'Int32');
SELECT JSONExtract('{"a": "hello", "b": [-100, 200.0, 300]}'::Object('json'), 'b', 4, 'Nullable(Int64)');
SELECT JSONExtract('{"passed": true}'::Object('json'), 'passed', 'UInt8');
SELECT JSONExtract('{"day": "Thursday"}'::Object('json'), 'day', 'Enum8(\'Sunday\' = 0, \'Monday\' = 1, \'Tuesday\' = 2, \'Wednesday\' = 3, \'Thursday\' = 4, \'Friday\' = 5, \'Saturday\' = 6)');
SELECT JSONExtract('{"day": 5}'::Object('json'), 'day', 'Enum8(\'Sunday\' = 0, \'Monday\' = 1, \'Tuesday\' = 2, \'Wednesday\' = 3, \'Thursday\' = 4, \'Friday\' = 5, \'Saturday\' = 6)');
SELECT JSONExtract('{"a":3,"b":5,"c":7}'::Object('json'), 'Tuple(a Int, b Int)');
SELECT JSONExtract('{"a":3,"b":5,"c":7}'::Object('json'), 'Tuple(c Int, a Int)');
SELECT JSONExtract('{"a":3,"b":5,"c":7}'::Object('json'), 'Tuple(b Int, d Int)');
SELECT JSONExtract('{"a":3,"b":5,"c":7}'::Object('json'), 'Tuple(Int, Int)');
SELECT JSONExtract('{"a":3}'::Object('json'), 'Tuple(Int, Int)');
SELECT JSONExtract('{"a":123456, "b":3.55}'::Object('json'), 'Tuple(a LowCardinality(Int32), b Decimal(5, 2))');
SELECT JSONExtract('{"a":1, "b":"417ddc5d-e556-4d27-95dd-a34d84e46a50"}'::Object('json'), 'Tuple(a Int8, b UUID)');
SELECT JSONExtract('{"a": "hello", "b": [-100, 200.0, 300]}'::Object('json'), 'a', 'LowCardinality(String)');
SELECT JSONExtract('{"a":3333.6333333333333333333333, "b":"test"}'::Object('json'), 'Tuple(a Decimal(10,1), b LowCardinality(String))');
SELECT JSONExtract('{"a":3333.6333333333333333333333, "b":"test"}'::Object('json'), 'Tuple(a Decimal(20,10), b LowCardinality(String))');
SELECT JSONExtract('{"a":123456.123456}'::Object('json'), 'a', 'Decimal(20, 4)') as a, toTypeName(a);
SELECT toDecimal64(123456789012345.12, 4), JSONExtract('{"a":123456789012345.12}'::Object('json'), 'a', 'Decimal(30, 4)');
SELECT toDecimal128(1234567890.12345678901234567890, 20), JSONExtract('{"a":1234567890.12345678901234567890, "b":"test"}'::Object('json'), 'Tuple(a Decimal(35,20), b LowCardinality(String))');
SELECT toDecimal256(1234567890.123456789012345678901234567890, 30), JSONExtract('{"a":1234567890.12345678901234567890, "b":"test"}'::Object('json'), 'Tuple(a Decimal(45,30), b LowCardinality(String))');
SELECT JSONExtract('{"a": 3}'::Object('json'), 'a', 'Decimal(5, 2)');

SELECT '--JSONExtractKeysAndValues--';
SELECT JSONExtractKeysAndValues('{"a": "hello", "b": [-100, 200.0, 300]}'::Object('json'), 'String');
SELECT JSONExtractKeysAndValues('{"a": "hello", "b": [-100, 200.0, 300]}'::Object('json'), 'Array(Float64)');
SELECT JSONExtractKeysAndValues('{"a": "hello", "b": "world"}'::Object('json'), 'String');
SELECT JSONExtractKeysAndValues('{"x": {"a": 5, "b": 7, "c": 11}}'::Object('json'), 'x', 'Int8');
SELECT JSONExtractKeysAndValues('{"a": "hello", "b": "world"}'::Object('json'), 'LowCardinality(String)');

SELECT '--JSONExtractRaw--';
SELECT JSONExtractRaw('{"a": "hello", "b": [-100, 200.0, 300]}'::Object('json'));
SELECT JSONExtractRaw('{"a": "hello", "b": [-100, 200.0, 300]}'::Object('json'), 'a');
SELECT JSONExtractRaw('{"a": "hello", "b": [-100, 200.0, 300]}'::Object('json'), 'b');
SELECT JSONExtractRaw('{"a": "hello", "b": [-100, 200.0, 300]}'::Object('json'), 'b', 1);
SELECT JSONExtractRaw('{"a": "hello", "b": [-100, 200.0, 300], "c":{"d":[121,144]}}'::Object('json'));
SELECT JSONExtractRaw('{"a": "hello", "b": [-100, 200.0, 300], "c":{"d":[121,144]}}'::Object('json'), 'c');
SELECT JSONExtractRaw('{"a": "hello", "b": [-100, 200.0, 300], "c":{"d":[121,144]}}'::Object('json'), 'c', 'd');
SELECT JSONExtractRaw('{"a": "hello", "b": [-100, 200.0, 300], "c":{"d":[121,144]}}'::Object('json'), 'c', 'd', 2);
SELECT JSONExtractRaw('{"a": "hello", "b": [-100, 200.0, 300], "c":{"d":[121,144]}}'::Object('json'), 'c', 'd', 3);
SELECT JSONExtractRaw('{"passed": true}'::Object('json'));
SELECT JSONExtractRaw('{}'::Object('json'));
SELECT JSONExtractRaw('{"abc":"\\n\\u0000"}'::Object('json'), 'abc');
SELECT JSONExtractRaw('{"abc":"\\u263a"}'::Object('json'), 'abc');

SELECT '--JSONExtractArrayRaw--';
SELECT JSONExtractArrayRaw(''::Object('json'));
SELECT JSONExtractArrayRaw('{"a": "hello", "b": "not_array"}'::Object('json'));
SELECT JSONExtractArrayRaw('{"arr": []}'::Object('json'), 'arr');
SELECT JSONExtractArrayRaw('{"a": "hello", "b": [-100, 200.0, 300]}'::Object('json'), 'b');
SELECT JSONExtractArrayRaw('{"arr": [1,2,3,4,5,"hello"]}'::Object('json'), 'arr');
SELECT JSONExtractArrayRaw(arrayJoin(JSONExtractArrayRaw('{"arr": [[1,2,3],[4,5,6]]}'::Object('json'), 'arr')));

SELECT '--JSONExtractKeysAndValuesRaw--';
SELECT JSONExtractKeysAndValuesRaw('{"a": "hello", "b": [-100, 200.0, 300]}'::Object('json'), 'a');
SELECT JSONExtractKeysAndValuesRaw('{"a": "hello", "b": [-100, 200.0, 300]}'::Object('json'), 'b');
SELECT JSONExtractKeysAndValuesRaw('{"a": "hello", "b": [-100, 200.0, 300]}'::Object('json'));
SELECT JSONExtractKeysAndValuesRaw('{"a": "hello", "b": [-100, 200.0, 300], "c":{"d":[121,144]}}'::Object('json'));
SELECT JSONExtractKeysAndValuesRaw('{"a": "hello", "b": [-100, 200.0, 300], "c":{"d":[121,144]}}'::Object('json'), 'c');

SELECT '--const/non-const mixed--';
SELECT JSONExtractString('{"arr": ["a", "b", "c", "d", "e"]}'::Object('json'), 'arr', idx) FROM (SELECT arrayJoin([1,2,3,4,5]) AS idx);
SELECT JSONExtractString(''::JSON, idx) FROM (SELECT arrayJoin([1023, 2147483647, -1, NULL, 100]) AS idx);
SELECT JSONExtractString(json::Object('json'), 's') FROM (SELECT arrayJoin(['{"s":"u"}', '{"s":"v"}']) AS json);
