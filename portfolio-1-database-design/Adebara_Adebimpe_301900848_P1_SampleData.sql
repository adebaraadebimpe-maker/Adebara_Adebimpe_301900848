-- Fictional sample records for Library Management System.
BEGIN;
SET LOCAL standard_conforming_strings = on;
INSERT INTO portfolio."member" ("member_id", "email", "joined_on", "active") VALUES (1001, 'maya.chen@example.test', '2024-01-15', TRUE);
INSERT INTO portfolio."member" ("member_id", "email", "joined_on", "active") VALUES (1002, 'leo.martin@example.test', '2024-03-02', TRUE);
INSERT INTO portfolio."book" ("book_id", "isbn", "title", "publication_year") VALUES (2001, '9780000000001', 'The Quiet Observatory', 2018);
INSERT INTO portfolio."book" ("book_id", "isbn", "title", "publication_year") VALUES (2002, '9780000000002', 'A Map of Small Rivers', 2021);
INSERT INTO portfolio."book" ("book_id", "isbn", "title", "publication_year") VALUES (2003, '9780000000003', 'Gardens After Rain', NULL);
INSERT INTO portfolio."loan" ("loan_id", "member_id", "book_id", "checked_out_on", "due_on", "returned_on") VALUES (3001, 1001, 2001, '2025-02-01', '2025-02-15', NULL);
INSERT INTO portfolio."loan" ("loan_id", "member_id", "book_id", "checked_out_on", "due_on", "returned_on") VALUES (3002, 1002, 2002, '2025-01-10', '2025-01-24', '2025-01-20');
COMMIT;
