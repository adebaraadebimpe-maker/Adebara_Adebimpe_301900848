-- Run these deliberately invalid statements one at a time, outside a transaction.
-- Each should fail at the named constraint; the sample rows should remain unchanged.

-- 1. member pk duplicate. Expected: pk_member, SQLSTATE 23505.
INSERT INTO portfolio."member" ("member_id", "email", "joined_on", "active")
VALUES (1001, 'new.member.pk@example.test', '2025-01-01', TRUE);

-- 2. member email duplicate. Expected: uq_member_0, SQLSTATE 23505.
INSERT INTO portfolio."member" ("member_id", "email", "joined_on", "active")
VALUES (9001, 'maya.chen@example.test', '2025-01-01', TRUE);

-- 3. member id not null. Expected: member_id, SQLSTATE 23502.
INSERT INTO portfolio."member" ("member_id", "email", "joined_on", "active")
VALUES (NULL, 'null.member.id@example.test', '2025-01-01', TRUE);

-- 4. member email not null. Expected: email, SQLSTATE 23502.
INSERT INTO portfolio."member" ("member_id", "email", "joined_on", "active")
VALUES (9002, NULL, '2025-01-01', TRUE);

-- 5. member joined on not null. Expected: joined_on, SQLSTATE 23502.
INSERT INTO portfolio."member" ("member_id", "email", "joined_on", "active")
VALUES (9003, 'null.member.joined@example.test', NULL, TRUE);

-- 6. member active not null. Expected: active, SQLSTATE 23502.
INSERT INTO portfolio."member" ("member_id", "email", "joined_on", "active")
VALUES (9004, 'null.member.active@example.test', '2025-01-01', NULL);

-- 7. book pk duplicate. Expected: pk_book, SQLSTATE 23505.
INSERT INTO portfolio."book" ("book_id", "isbn", "title", "publication_year")
VALUES (2001, '9780000000091', 'Duplicate Identifier Test', 2020);

-- 8. book isbn duplicate. Expected: uq_book_0, SQLSTATE 23505.
INSERT INTO portfolio."book" ("book_id", "isbn", "title", "publication_year")
VALUES (9005, '9780000000001', 'Duplicate ISBN Test', 2020);

-- 9. book id not null. Expected: book_id, SQLSTATE 23502.
INSERT INTO portfolio."book" ("book_id", "isbn", "title", "publication_year")
VALUES (NULL, '9780000000092', 'Null Book Identifier Test', 2020);

-- 10. book isbn not null. Expected: isbn, SQLSTATE 23502.
INSERT INTO portfolio."book" ("book_id", "isbn", "title", "publication_year")
VALUES (9006, NULL, 'Null ISBN Test', 2020);

-- 11. book title not null. Expected: title, SQLSTATE 23502.
INSERT INTO portfolio."book" ("book_id", "isbn", "title", "publication_year")
VALUES (9007, '9780000000093', NULL, 2020);

-- 12. loan pk duplicate. Expected: pk_loan, SQLSTATE 23505.
INSERT INTO portfolio."loan" ("loan_id", "member_id", "book_id", "checked_out_on", "due_on", "returned_on")
VALUES (3001, 1002, 2003, '2025-03-01', '2025-03-15', '2025-03-10');

-- 13. loan member fk missing. Expected: fk_loan_0, SQLSTATE 23503.
INSERT INTO portfolio."loan" ("loan_id", "member_id", "book_id", "checked_out_on", "due_on", "returned_on")
VALUES (9008, 9998, 2003, '2025-03-01', '2025-03-15', '2025-03-10');

-- 14. loan book fk missing. Expected: fk_loan_1, SQLSTATE 23503.
INSERT INTO portfolio."loan" ("loan_id", "member_id", "book_id", "checked_out_on", "due_on", "returned_on")
VALUES (9009, 1002, 9999, '2025-03-01', '2025-03-15', '2025-03-10');

-- 15. loan id not null. Expected: loan_id, SQLSTATE 23502.
INSERT INTO portfolio."loan" ("loan_id", "member_id", "book_id", "checked_out_on", "due_on", "returned_on")
VALUES (NULL, 1002, 2003, '2025-03-01', '2025-03-15', '2025-03-10');

-- 16. loan member id not null. Expected: member_id, SQLSTATE 23502.
INSERT INTO portfolio."loan" ("loan_id", "member_id", "book_id", "checked_out_on", "due_on", "returned_on")
VALUES (9010, NULL, 2003, '2025-03-01', '2025-03-15', '2025-03-10');

-- 17. loan book id not null. Expected: book_id, SQLSTATE 23502.
INSERT INTO portfolio."loan" ("loan_id", "member_id", "book_id", "checked_out_on", "due_on", "returned_on")
VALUES (9011, 1002, NULL, '2025-03-01', '2025-03-15', '2025-03-10');

-- 18. loan checked out not null. Expected: checked_out_on, SQLSTATE 23502.
INSERT INTO portfolio."loan" ("loan_id", "member_id", "book_id", "checked_out_on", "due_on", "returned_on")
VALUES (9012, 1002, 2003, NULL, '2025-03-15', '2025-03-10');

-- 19. loan due on not null. Expected: due_on, SQLSTATE 23502.
INSERT INTO portfolio."loan" ("loan_id", "member_id", "book_id", "checked_out_on", "due_on", "returned_on")
VALUES (9013, 1002, 2003, '2025-03-01', NULL, '2025-03-10');

-- 20. loan dates invalid. Expected: loan_dates_valid, SQLSTATE 23514.
INSERT INTO portfolio."loan" ("loan_id", "member_id", "book_id", "checked_out_on", "due_on", "returned_on")
VALUES (9014, 1002, 2003, '2025-03-15', '2025-03-01', '2025-03-10');

-- 21. active book duplicate. Expected: active_book_unique, SQLSTATE 23505.
INSERT INTO portfolio."loan" ("loan_id", "member_id", "book_id", "checked_out_on", "due_on", "returned_on")
VALUES (9015, 1002, 2001, '2025-03-01', '2025-03-15', NULL);
