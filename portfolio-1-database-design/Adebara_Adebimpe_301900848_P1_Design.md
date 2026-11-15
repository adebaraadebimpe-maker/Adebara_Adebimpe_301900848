# Library Management System — database design

My case study records member, book, loan.

## Users

- Library staff managing member accounts and book loans
- Students querying circulation and overdue-loan information

## Main operations

- Register members and catalogue books.
- Record checkouts and returns while retaining loan history.
- Join loan records to members and books to display checkout details.
- Filter loans to find unreturned books whose due date has passed.
- Aggregate loan counts by book by joining loan records to books.
- Separate benchmark plan: generate 20000 synthetic loan rows, run the same overdue-loan filter with and without a B-tree index on loan.returned_on, and compare the selected access plans and row counts.
- Use only invented member details, book details, and loan records in exercises.

## Entities

| Entity | Information stored |
| --- | --- |
| member | Stores a library member's identifying and account details. |
| book | Stores catalogued book details used by the circulation system. |
| loan | Records a member's checkout and return dates for a book. |

## member

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| member_id | BIGINT | PK | Yes |
| email | TEXT | Unique | Yes |
| joined_on | DATE |  | Yes |
| active | BOOLEAN |  | Yes |
- Unique key: (email).

## book

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| book_id | BIGINT | PK | Yes |
| isbn | TEXT | Unique | Yes |
| title | TEXT |  | Yes |
| publication_year | INTEGER |  | No |
- Unique key: (isbn).

## loan

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| loan_id | BIGINT | PK | Yes |
| member_id | BIGINT | FK | Yes |
| book_id | BIGINT | FK | Yes |
| checked_out_on | DATE |  | Yes |
| due_on | DATE |  | Yes |
| returned_on | DATE |  | No |
- member_id → member.member_id
- book_id → book.book_id

## Relationships and business rules

- Every member must have a non-null email address that is unique among members.
- Every catalogued book must have a non-null ISBN that is unique among books.
- Every loan must refer to an existing member.
- Every loan must refer to an existing book.
- A loan's due date must be on or after its checkout date.
- Among loans with no return date, each book may appear at most once; this database-enforced partial unique rule prevents simultaneous active loans for the same book.

## Assumptions

- Each member has one email address, and each book has one ISBN; both are unique within this model.
- Identifiers are opaque values assigned from a shared global namespace, so every entity has a globally unique single-column primary key.
- A book may have at most one unreturned loan at a time; returned loans remain in the history.
- The partial unique rule on active loans is enforced by the database and is the concurrency rule for checkout attempts.

