SET enable_shuffle_with_order = 1;
SELECT number, joined FROM system.numbers ANY LEFT JOIN (SELECT number * 2 AS number, number * 10 + 1 AS joined FROM system.numbers LIMIT 10) USING number LIMIT 10
