// Run once in mongosh against a fresh exercise database.
// These records are fictional events for the case study.
(async function () {
  db = db.getSiblingDB('portfolio_nosql');
  if ((await db.getCollectionNames()).includes("loan_events")) {
    throw new Error('The exercise collection already exists. Use a fresh database.');
  }

  // The validator checks the stable event fields while details can vary.
  await db.createCollection("loan_events", {
    validator: {
    "$jsonSchema": {
        "bsonType": "object",
        "required": [
            "_id",
            "schemaVersion",
            "simulation",
            "eventType",
            "occurredAt",
            "source",
            "embedded",
            "references",
            "details"
        ],
        "properties": {
            "_id": {
                "bsonType": "string",
                "minLength": 1
            },
            "schemaVersion": {
                "enum": [
                    1
                ]
            },
            "simulation": {
                "enum": [
                    true
                ]
            },
            "eventType": {
                "bsonType": "string",
                "enum": [
                    "loan_opened",
                    "loan_returned"
                ]
            },
            "occurredAt": {
                "bsonType": "date"
            },
            "source": {
                "bsonType": "object",
                "required": [
                    "entity",
                    "key",
                    "snapshot"
                ],
                "properties": {
                    "entity": {
                        "enum": [
                            "loan"
                        ]
                    },
                    "key": {
                        "bsonType": "object",
                        "required": [
                            "loan_id"
                        ]
                    },
                    "snapshot": {
                        "bsonType": "object"
                    }
                }
            },
            "embedded": {
                "bsonType": "object"
            },
            "references": {
                "bsonType": "object"
            },
            "details": {
                "bsonType": "object"
            }
        }
    }
},
    validationLevel: 'strict', validationAction: 'error'
  });

  // Insert the four example events and show their IDs.
  printjson(await db.getCollection("loan_events").insertMany([
    {
        "_id": "event_000001",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "loan_opened",
        "occurredAt": ISODate("2030-01-01T10:00:00Z"),
        "source": {
            "entity": "loan",
            "key": {
                "loan_id": 3001
            },
            "snapshot": {
                "loan_id": 3001,
                "member_id": 1001,
                "book_id": 2001,
                "checked_out_on": "2025-02-01",
                "due_on": "2025-02-15",
                "returned_on": null
            }
        },
        "embedded": {
            "member": [
                {
                    "key": {
                        "member_id": 1001
                    },
                    "snapshot": {
                        "member_id": 1001,
                        "email": "maya.chen@example.test",
                        "joined_on": "2024-01-15",
                        "active": true
                    },
                    "via": [
                        "loan.member_id → member"
                    ]
                }
            ],
            "book": [
                {
                    "key": {
                        "book_id": 2001
                    },
                    "snapshot": {
                        "book_id": 2001,
                        "isbn": "9780000000001",
                        "title": "The Quiet Observatory",
                        "publication_year": 2018
                    },
                    "via": [
                        "loan.book_id → book"
                    ]
                }
            ]
        },
        "references": {},
        "details": {
            "channel": "web"
        }
    },
    {
        "_id": "event_000002",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "loan_returned",
        "occurredAt": ISODate("2030-01-01T10:01:00Z"),
        "source": {
            "entity": "loan",
            "key": {
                "loan_id": 3001
            },
            "snapshot": {
                "loan_id": 3001,
                "member_id": 1001,
                "book_id": 2001,
                "checked_out_on": "2025-02-01",
                "due_on": "2025-02-15",
                "returned_on": null
            }
        },
        "embedded": {
            "member": [
                {
                    "key": {
                        "member_id": 1001
                    },
                    "snapshot": {
                        "member_id": 1001,
                        "email": "maya.chen@example.test",
                        "joined_on": "2024-01-15",
                        "active": true
                    },
                    "via": [
                        "loan.member_id → member"
                    ]
                }
            ],
            "book": [
                {
                    "key": {
                        "book_id": 2001
                    },
                    "snapshot": {
                        "book_id": 2001,
                        "isbn": "9780000000001",
                        "title": "The Quiet Observatory",
                        "publication_year": 2018
                    },
                    "via": [
                        "loan.book_id → book"
                    ]
                }
            ]
        },
        "references": {},
        "details": {
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "examples": {
                "return_note": "illustrative return_note",
                "client_context": "illustrative client_context"
            }
        }
    },
    {
        "_id": "event_000003",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "loan_opened",
        "occurredAt": ISODate("2030-01-01T10:02:00Z"),
        "source": {
            "entity": "loan",
            "key": {
                "loan_id": 3002
            },
            "snapshot": {
                "loan_id": 3002,
                "member_id": 1002,
                "book_id": 2002,
                "checked_out_on": "2025-01-10",
                "due_on": "2025-01-24",
                "returned_on": "2025-01-20"
            }
        },
        "embedded": {
            "member": [
                {
                    "key": {
                        "member_id": 1002
                    },
                    "snapshot": {
                        "member_id": 1002,
                        "email": "leo.martin@example.test",
                        "joined_on": "2024-03-02",
                        "active": true
                    },
                    "via": [
                        "loan.member_id → member"
                    ]
                }
            ],
            "book": [
                {
                    "key": {
                        "book_id": 2002
                    },
                    "snapshot": {
                        "book_id": 2002,
                        "isbn": "9780000000002",
                        "title": "A Map of Small Rivers",
                        "publication_year": 2021
                    },
                    "via": [
                        "loan.book_id → book"
                    ]
                }
            ]
        },
        "references": {},
        "details": {
            "channel": "web"
        }
    },
    {
        "_id": "event_000004",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "loan_returned",
        "occurredAt": ISODate("2030-01-01T10:03:00Z"),
        "source": {
            "entity": "loan",
            "key": {
                "loan_id": 3002
            },
            "snapshot": {
                "loan_id": 3002,
                "member_id": 1002,
                "book_id": 2002,
                "checked_out_on": "2025-01-10",
                "due_on": "2025-01-24",
                "returned_on": "2025-01-20"
            }
        },
        "embedded": {
            "member": [
                {
                    "key": {
                        "member_id": 1002
                    },
                    "snapshot": {
                        "member_id": 1002,
                        "email": "leo.martin@example.test",
                        "joined_on": "2024-03-02",
                        "active": true
                    },
                    "via": [
                        "loan.member_id → member"
                    ]
                }
            ],
            "book": [
                {
                    "key": {
                        "book_id": 2002
                    },
                    "snapshot": {
                        "book_id": 2002,
                        "isbn": "9780000000002",
                        "title": "A Map of Small Rivers",
                        "publication_year": 2021
                    },
                    "via": [
                        "loan.book_id → book"
                    ]
                }
            ]
        },
        "references": {},
        "details": {
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "examples": {
                "return_note": "illustrative return_note",
                "client_context": "illustrative client_context"
            }
        }
    }
]));
  await db.getCollection("loan_events").createIndex({eventType: 1, occurredAt: -1}, {name: 'event_type_time'});

  // 1. Find the first sample event type (up to five documents).
  printjson(await db.getCollection("loan_events").find({"eventType":"loan_opened"}).sort({_id:1}).limit(5).toArray());

  // 2. Find events for the first source record using nested key fields (up to five).
  printjson(await db.getCollection("loan_events").find({"source.key.loan_id":3001}).sort({_id:1}).limit(5).toArray());

  // 3. Find events in the sample time range using a MongoDB Date filter (up to five).
  printjson(await db.getCollection("loan_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray());

  // 4. Count documents for each event type.
  printjson(await db.getCollection("loan_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray());

  // A date stored as text should be rejected by the validator.
  try {
    await db.getCollection("loan_events").insertOne({...{
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "loan_opened",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "loan",
        "key": {
            "loan_id": 3001
        },
        "snapshot": {
            "loan_id": 3001,
            "member_id": 1001,
            "book_id": 2001,
            "checked_out_on": "2025-02-01",
            "due_on": "2025-02-15",
            "returned_on": null
        }
    },
    "embedded": {
        "member": [
            {
                "key": {
                    "member_id": 1001
                },
                "snapshot": {
                    "member_id": 1001,
                    "email": "maya.chen@example.test",
                    "joined_on": "2024-01-15",
                    "active": true
                },
                "via": [
                    "loan.member_id → member"
                ]
            }
        ],
        "book": [
            {
                "key": {
                    "book_id": 2001
                },
                "snapshot": {
                    "book_id": 2001,
                    "isbn": "9780000000001",
                    "title": "The Quiet Observatory",
                    "publication_year": 2018
                },
                "via": [
                    "loan.book_id → book"
                ]
            }
        ]
    },
    "references": {},
    "details": {
        "channel": "web"
    }
}, _id: 'invalid_date_example', occurredAt: 'not-a-date'});
  } catch (error) { print('Invalid date error: ' + error.code); }

  // Reusing an event ID should be rejected by the unique _id index.
  try { await db.getCollection("loan_events").insertOne({
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "loan_opened",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "loan",
        "key": {
            "loan_id": 3001
        },
        "snapshot": {
            "loan_id": 3001,
            "member_id": 1001,
            "book_id": 2001,
            "checked_out_on": "2025-02-01",
            "due_on": "2025-02-15",
            "returned_on": null
        }
    },
    "embedded": {
        "member": [
            {
                "key": {
                    "member_id": 1001
                },
                "snapshot": {
                    "member_id": 1001,
                    "email": "maya.chen@example.test",
                    "joined_on": "2024-01-15",
                    "active": true
                },
                "via": [
                    "loan.member_id → member"
                ]
            }
        ],
        "book": [
            {
                "key": {
                    "book_id": 2001
                },
                "snapshot": {
                    "book_id": 2001,
                    "isbn": "9780000000001",
                    "title": "The Quiet Observatory",
                    "publication_year": 2018
                },
                "via": [
                    "loan.book_id → book"
                ]
            }
        ]
    },
    "references": {},
    "details": {
        "channel": "web"
    }
}); }
  catch (error) { print('Duplicate ID error: ' + error.code); }

  print('Document count: ' + await db.getCollection("loan_events").countDocuments());
})().catch(error => { print(error.stack || String(error)); quit(1); });
