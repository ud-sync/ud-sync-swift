Scenario: user deletes ItemA in Device1, Device2 needs to get a list of deleted
records since its last fetch (datetime) so it can delete ItemA.

For CDSync to work, it needs to be able to fetch that list from the server
according to the following specification.

```
GET /operations?since=2015-10-20T10:00:00Z

{
  "operations": [{
    "id": "operation-unique-id1",
    "name": "delete",
    "record-id": "record-id1",
    "entity": "user",
    "date": "2015-10-21T10:00:00Z"
  }, {
    "id": "operation-unique-id2",
    "name": "save",
    "record-id": "record-id2",
    "entity": "post",
    "date": "2015-10-21T10:00:00Z"
  }]
}
```

The operation can be a **delete** or **save**. When it's a **delete**, CDSync
will remove that record locally automatically.
