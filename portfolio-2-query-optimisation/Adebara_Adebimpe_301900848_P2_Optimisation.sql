-- A separate performance table using the case's loan.returned_on type.
-- Only this field and a lab row ID are copied. Business constraints stay in Portfolio 1.
-- Generated values are for measuring a selective lookup, not complete case records.
CREATE SCHEMA query_lab;
CREATE TABLE query_lab."loan" AS
SELECT "returned_on", 0::bigint AS "lab_row_id" FROM portfolio."loan" WITH NO DATA;
INSERT INTO query_lab."loan" ("returned_on", "lab_row_id")
SELECT (DATE '2030-01-01' + (g % 1000)::integer), g FROM generate_series(1, 20000) AS g;
ANALYZE query_lab."loan";

-- Before: warm the lookup, then measure it three times.
SELECT "lab_row_id", "returned_on"
FROM query_lab."loan"
WHERE "returned_on" = (DATE '2030-01-01' + (42 % 1000)::integer)
ORDER BY "lab_row_id";
EXPLAIN (ANALYZE, BUFFERS)
SELECT "lab_row_id", "returned_on"
FROM query_lab."loan"
WHERE "returned_on" = (DATE '2030-01-01' + (42 % 1000)::integer)
ORDER BY "lab_row_id";
EXPLAIN (ANALYZE, BUFFERS)
SELECT "lab_row_id", "returned_on"
FROM query_lab."loan"
WHERE "returned_on" = (DATE '2030-01-01' + (42 % 1000)::integer)
ORDER BY "lab_row_id";
EXPLAIN (ANALYZE, BUFFERS)
SELECT "lab_row_id", "returned_on"
FROM query_lab."loan"
WHERE "returned_on" = (DATE '2030-01-01' + (42 % 1000)::integer)
ORDER BY "lab_row_id";

CREATE INDEX p2_filter_idx ON query_lab."loan" USING btree ("returned_on");

-- After: run the same lookup and repeat the measurements.
SELECT "lab_row_id", "returned_on"
FROM query_lab."loan"
WHERE "returned_on" = (DATE '2030-01-01' + (42 % 1000)::integer)
ORDER BY "lab_row_id";
EXPLAIN (ANALYZE, BUFFERS)
SELECT "lab_row_id", "returned_on"
FROM query_lab."loan"
WHERE "returned_on" = (DATE '2030-01-01' + (42 % 1000)::integer)
ORDER BY "lab_row_id";
EXPLAIN (ANALYZE, BUFFERS)
SELECT "lab_row_id", "returned_on"
FROM query_lab."loan"
WHERE "returned_on" = (DATE '2030-01-01' + (42 % 1000)::integer)
ORDER BY "lab_row_id";
EXPLAIN (ANALYZE, BUFFERS)
SELECT "lab_row_id", "returned_on"
FROM query_lab."loan"
WHERE "returned_on" = (DATE '2030-01-01' + (42 % 1000)::integer)
ORDER BY "lab_row_id";
