[![Build
Status](https://travis-ci.org/ud-sync/ud-sync-swift.svg?branch=master)](https://travis-ci.org/ud-sync/ud-sync-swift)

# UDSync for Swift

**tl;dr:** UDSync comes with handy features to support the most common
scenarios for offline-first applications.

--------

Often times we have to build offline first mobile applications or use real time
notifications and end up building custom solutions over and over.
That guarantees we won't be stuck with outdated libs.

UDSync is not a database.

You will want to use the respective server-side libs to make your life
easier: [ud-sync-rails](https://github.com/ud-sync/ud-sync-rails)

## Features

| Feature | Description |
|---|---|
| Synchronization offline | Save records offline and UDSync will add it to the queue and automatically send it to the server once internet comes back. |
| Synchronize deletions | In an offline-first app, when DeviceA deleted a record, DeviceB needs to know about that when it comes online. UDSync help with that. |


## Installation

In your Podfile, use

```ruby
pod 'UDSync'
```

## Usage

### Synchronize offline

`UDSync` object will coordinate all the synchronization with different
services.

For instance, if your project uses CoreData and saves data in an HTTP
server, you'll command `UDSync` to save in both and it will make sure data
is pushed, even when no internet is available. If there's not internet, it will
still save the CoreData object, but will store the HTTP operation for later.
When internet comes back, `UDSync` will keep trying to push that object online
automatically.

What you have to do is something along these lines:

```swift
// 1. create the clients you will want following the UDClientProtocol
class HttpClient: UDClientProtocol {
  open function save() -> UDSyncPromise {
    // You specify how you want to save data to the web. This method is called
    // by UDSync to push data.
  }

  // ... other required methods
}

class CoreDataClient: UDSyncClientProtocol { /* ... */ }
class RealmClient: UDSyncClientProtocol { /* ... */ }

// 2. Configure UDSync
UDSync.configure(
  syncStores: RealmClient,
  asyncStores: [HttpClient, CoreDataClient]
)

// 3. When you want to save some new data (e.g user form), call `push()`
let ud = UDSync(values: ["name": "John"])
ud.push()

// 4. When you want to load new data from the server
UDSync.pull(source: HttpClient)
```

See the [Getting Started](docs/getting-started.md) for details on what
each client should implement.

### Synchronize deletions

Given DeviceA deleted a RecordN while DeviceB was offline, when DeviceB comes
online it has to delete RecordN. We keep track of all save/delete operations in
the server and expose it via the `GET /ud_sync/operations` endpoint.

```
GET /operations

{
  "operations": [{
    "id": "operation-unique-id1",
    "name": "delete",
    "record_id": "record-id1",
    "entity": "user",
    "date": "2015-10-21T10:00:00Z"
  }, {
    "id": "operation-unique-id2",
    "name": "save",
    "record_id": "record-id2",
    "entity": "post",
    "date": "2015-10-21T10:00:00Z"
  }]
}
```

Based on that, you know what to delete.

In your Swift application, use this piece of code:

```swift
// 1. fetch all operations
UDSentinel.sharedInstance.fetchOperations("http://api.myserver.com", accessToken: "") { (operations) in

    // `operations` is an array of UDOperation instances. Each UDOperation
    // responds to (check its test file for more details):
    //
    //   operation.entity() -> the name of the entity that was updated or deleted
    //   operation.operationName() -> either `delete` or `save`
    //   operation.recordId()

    // 2. iterate over each operation
    for operation in operations {
        if operation.operationName() == "delete" {
            if operation.entity() == "Customer" {
                // 3a. delete the record locally

                // Customer class here is your own code
                let id = operation.recordId()
                Customer.find(id).destroy()
            } else if operation.entity() == "Deal" {
                // 3b. delete the record according to the entity name
                //
                // ...
            }
        }
    }
}
```

## License

It's [MIT](https://github.com/ud-sync/ud-sync-swift/blob/master/LICENSE),
so do what you wish with it.

## Author

Alexandre de Oliveira ([@kurko](https://twitter.com/kurko))
