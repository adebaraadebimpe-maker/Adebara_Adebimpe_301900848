# Library Management System — normalisation

The example uses the saved sample records. The full set of fields is in the design and schema.

## Starting grouped records

| member_id | loan records (list) |
| --- | --- |
| 1001 | [3001] |
| 1002 | [3002] |


The record IDs are grouped in a list. In 1NF, each record has its own row and each cell holds one value.

## 1NF: one value per cell

| loan.loan_id | loan.member_id | loan.book_id | member.member_id | member.email | book.book_id | book.isbn |
| --- | --- | --- | --- | --- | --- | --- |
| 3001 | 1001 | 2001 | 1001 | maya.chen@example.test | 2001 | 9780000000001 |
| 3002 | 1002 | 2002 | 1002 | leo.martin@example.test | 2002 | 9780000000002 |

Key: loan_id.

## 2NF: depend on the whole key

The declared candidate keys do not introduce a partial dependency here, so the 1NF rows stay unchanged at this step.

## loan_example

| loan.loan_id | loan.member_id | loan.book_id | member.member_id | member.email | book.book_id | book.isbn |
| --- | --- | --- | --- | --- | --- | --- |
| 3001 | 1001 | 2001 | 1001 | maya.chen@example.test | 2001 | 9780000000001 |
| 3002 | 1002 | 2002 | 1002 | leo.martin@example.test | 2002 | 9780000000002 |

## 3NF: store each entity’s details once

The entity keys determine their own descriptions. Related records keep foreign keys rather than repeating those descriptions.

## member

| member_id | email | joined_on | active |
| --- | --- | --- | --- |
| 1001 | maya.chen@example.test | 2024-01-15 | true |
| 1002 | leo.martin@example.test | 2024-03-02 | true |

## book

| book_id | isbn | title | publication_year |
| --- | --- | --- | --- |
| 2001 | 9780000000001 | The Quiet Observatory | 2018 |
| 2002 | 9780000000002 | A Map of Small Rivers | 2021 |
| 2003 | 9780000000003 | Gardens After Rain | NULL |

## loan

| loan_id | member_id | book_id | checked_out_on | due_on | returned_on |
| --- | --- | --- | --- | --- | --- |
| 3001 | 1001 | 2001 | 2025-02-01 | 2025-02-15 | NULL |
| 3002 | 1002 | 2002 | 2025-01-10 | 2025-01-24 | 2025-01-20 |

## Dependencies

- member: (member_id) → email, joined_on, active
- book: (book_id) → isbn, title, publication_year
- loan: (loan_id) → member_id, book_id, checked_out_on, due_on, returned_on

Joining the decomposed sample tables reproduces the original 2 example rows. The design assumes the declared keys describe the relevant business dependencies.
