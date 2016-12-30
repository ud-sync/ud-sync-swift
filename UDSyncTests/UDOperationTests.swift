import XCTest
@testable import UDSync

class UDOperationSetup: XCTestCase {

    let standardOperation: [String: String] = [
        "id":        "1",
        "name":      "delete",
        "record_id": "1234",
        "entity":    "User",
        "date":      "2015-10-21T10:00:00Z"
    ]

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }
}

class UDOperationTests: UDOperationSetup {
    func testIsDelete() {
        XCTAssertTrue(UDOperation(operationHash:  ["name": "delete" as AnyObject]).isDelete())
        XCTAssertFalse(UDOperation(operationHash: ["name": "save" as AnyObject]).isDelete())
    }

    func testRecordId() {
        XCTAssertEqual("1234", UDOperation(operationHash: standardOperation as [String : AnyObject]).recordId())
    }

    func testEntity() {
        XCTAssertEqual("User", UDOperation(operationHash: standardOperation as [String : AnyObject] ).entity())
    }
}
