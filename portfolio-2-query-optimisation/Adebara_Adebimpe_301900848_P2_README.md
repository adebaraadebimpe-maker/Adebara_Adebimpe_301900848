# Library Management System — SQL queries

## 1. Show related loan, member, book records (up to 20).

```sql
SELECT t0."loan_id" AS "loan_loan_id",
       t0."checked_out_on" AS "loan_checked_out_on",
       t1."member_id" AS "member_member_id",
       t1."email" AS "member_email",
       t2."book_id" AS "book_book_id",
       t2."isbn" AS "book_isbn"
FROM portfolio."loan" t0
JOIN portfolio."member" t1 ON t0."member_id" = t1."member_id"
JOIN portfolio."book" t2 ON t0."book_id" = t2."book_id"
ORDER BY t0."loan_id", t1."member_id", t2."book_id"
LIMIT 20;
```

| loan_loan_id | loan_checked_out_on | member_member_id | member_email | book_book_id | book_isbn |
| --- | --- | --- | --- | --- | --- |
| 3001 | 2025-02-01 | 1001 | maya.chen@example.test | 2001 | 9780000000001 |
| 3002 | 2025-01-10 | 1002 | leo.martin@example.test | 2002 | 9780000000002 |

## 2. Find loan records where returned_on matches null (up to 20).

```sql
SELECT * FROM portfolio."loan"
WHERE "returned_on" IS NOT DISTINCT FROM NULL
ORDER BY "loan_id"
LIMIT 20;
```

| loan_id | member_id | book_id | checked_out_on | due_on | returned_on |
| --- | --- | --- | --- | --- | --- |
| 3001 | 1001 | 2001 | 2025-02-01 | 2025-02-15 | NULL |

## 3. Count loan records for each member_id (up to 20 groups).

```sql
SELECT "member_id", count(*) AS record_count
FROM portfolio."loan"
GROUP BY "member_id"
ORDER BY record_count DESC, "member_id" NULLS LAST
LIMIT 20;
```

| member_id | record_count |
| --- | --- |
| 1001 | 1 |
| 1002 | 1 |


## Index comparison

| Phase | Median (ms) | Three runs (ms) | Plan nodes | Buffer hits |
| --- | --- | --- | --- | --- |
| Before index | 0.883 | 0.882, 1.005, 0.883 | Sort → Seq Scan | 112 |
| After index | 0.194 | 0.226, 0.194, 0.189 | Sort → Bitmap Heap Scan → Bitmap Index Scan | 25 |

The median execution time changed from 0.883 ms to 0.194 ms. The measured plan used p2_filter_idx. The results matched in both phases. An index adds storage and write-maintenance costs; timings depend on the selected lookup and environment.

## Execution plans

### Before index, run 1

```text
Sort (actual time=0.85..0.852 rows=20 loops=1)
  Seq Scan on loan (actual time=0.012..0.813 rows=20 loops=1)
Planning Time: 0.411 ms
Execution Time: 0.882 ms
```

### Before index, run 2

```text
Sort (actual time=0.973..0.975 rows=20 loops=1)
  Seq Scan on loan (actual time=0.011..0.938 rows=20 loops=1)
Planning Time: 0.356 ms
Execution Time: 1.005 ms
```

### Before index, run 3

```text
Sort (actual time=0.855..0.856 rows=20 loops=1)
  Seq Scan on loan (actual time=0.012..0.821 rows=20 loops=1)
Planning Time: 0.355 ms
Execution Time: 0.883 ms
```

### After index, run 1

```text
Sort (actual time=0.159..0.16 rows=20 loops=1)
  Bitmap Heap Scan on loan (actual time=0.027..0.12 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.018..0.018 rows=20 loops=1)
Planning Time: 0.588 ms
Execution Time: 0.226 ms
```

### After index, run 2

```text
Sort (actual time=0.137..0.139 rows=20 loops=1)
  Bitmap Heap Scan on loan (actual time=0.028..0.098 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.018..0.018 rows=20 loops=1)
Planning Time: 0.603 ms
Execution Time: 0.194 ms
```

### After index, run 3

```text
Sort (actual time=0.132..0.134 rows=20 loops=1)
  Bitmap Heap Scan on loan (actual time=0.027..0.096 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.018..0.018 rows=20 loops=1)
Planning Time: 0.549 ms
Execution Time: 0.189 ms
```

## Reproduce

Use a fresh database with the Portfolio 1 schema and sample data. Run Adebara_Adebimpe_301900848_P2_Queries.sql, then Adebara_Adebimpe_301900848_P2_Optimisation.sql. The optimisation script creates a separate performance table and runs EXPLAIN (ANALYZE, BUFFERS).

[Query screenshot](screenshots/Adebara_Adebimpe_301900848_P2_QueryResults.png) · [Index comparison](screenshots/Adebara_Adebimpe_301900848_P2_IndexComparison.png)

## References

- [PostgreSQL — EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)

