import XCTest
@testable import UDSync

class CDOperationSetup: XCTestCase {

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

class CDOperationTests: CDOperationSetup {
    func testIsDelete() {
        XCTAssertTrue(CDOperation(operationHash:  ["name": "delete"]).isDelete())
        XCTAssertFalse(CDOperation(operationHash: ["name": "save"]).isDelete())
    }

    func testRecordId() {
        XCTAssertEqual("1234", CDOperation(operationHash: standardOperation).recordId())
    }

    func testEntity() {
        XCTAssertEqual("User", CDOperation(operationHash: standardOperation).entity())
    }
}