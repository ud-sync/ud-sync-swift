## Architecture

Your codebase architecture will have 3 components:

1. local store: your code that handles local storage.
2. server operations: your code that sends data to the server.
3. CDSync in between both as a queue.

For every new record in the local store, CDSync will enqueue the server
operation and process it. If the operation fails, CDSync will try again.
Meanwhile, users can continue using your application normally.

For example, when a record is deleted locally, you are going to call your own
class (1) to delete it (e.g CoreData, Realm). This code needs to call CDSync (2),
which will automatically call the server operations objects (e.g AFNetworking,
Alamofire, Spine).

## Download and Upload

Data travels two ways:

1. from the device to the server
2. from the server to the device

Because of that, you have to plug CDSync both ways. For that, you have to obey
some protocols:

1. `ServerResourceProtocol`: your code that pushes and downloads data from
  the server need to implement this protocol.

2. `LocalResourceProtocol`: your code that saves and retrieves data locally
  (e.g CoreData, Realm) have to implement this protocol.
