# Library Management System — ER diagram

```mermaid
erDiagram
    direction LR
    member {
        bigint member_id PK
        text email UK
        date joined_on
        boolean active
    }
    book {
        bigint book_id PK
        text isbn UK
        text title
        integer publication_year "Optional"
    }
    loan {
        bigint loan_id PK
        bigint member_id FK
        bigint book_id FK
        date checked_out_on
        date due_on
        date returned_on "Optional"
    }
    member ||--o{ loan : "member_id"
    book ||--o{ loan : "book_id"
```

PK identifies a record; FK links to another table; UK marks a single-field unique value. The relationship ends show exactly one, zero or one, or zero or many records. Composite unique keys and conditional rules are listed in the schema and design.

[Diagram image](../images/Adebara_Adebimpe_301900848_ERDiagram.png)
