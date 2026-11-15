-- Show related loan, member, book records (up to 20).
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

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
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

-- Find loan records where returned_on matches null (up to 20).
SELECT * FROM portfolio."loan"
WHERE "returned_on" IS NOT DISTINCT FROM NULL
ORDER BY "loan_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT * FROM portfolio."loan"
WHERE "returned_on" IS NOT DISTINCT FROM NULL
ORDER BY "loan_id"
LIMIT 20;

-- Count loan records for each member_id (up to 20 groups).
SELECT "member_id", count(*) AS record_count
FROM portfolio."loan"
GROUP BY "member_id"
ORDER BY record_count DESC, "member_id" NULLS LAST
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT "member_id", count(*) AS record_count
FROM portfolio."loan"
GROUP BY "member_id"
ORDER BY record_count DESC, "member_id" NULLS LAST
LIMIT 20;
