import XCTest
import UDSync

class CDSentinelSetup: XCTestCase {

    var host = "http://ud-sync-test-server.herokuapp.com"
    var endpoints: [String:String] = [
        "no-operations": "/ud_sync/operations?test=no-operations",
        "non-existent-endpoint": "/non_existent_endpoint"
    ]

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }
}

class CDSentinelTests: CDSentinelSetup {
    func testOperations() {
        let expectation = expectationWithDescription("testOperations")

        UDSentinel.sharedInstance.fetchOperations(
            self.host,
            accessToken: ""
        ) { (operations) in

            print(operations)
            XCTAssertEqual("Post",     operations[0].entity())
            XCTAssertEqual("save",     operations[0].operationName())
            XCTAssertEqual("record-1", operations[0].recordId())

            XCTAssertEqual("Comment",  operations[1].entity())
            XCTAssertEqual("save",     operations[1].operationName())
            XCTAssertEqual("record-2", operations[1].recordId())

            XCTAssertEqual("Post",     operations[2].entity())
            XCTAssertEqual("delete",   operations[2].operationName())
            XCTAssertEqual("record-1", operations[2].recordId())

            expectation.fulfill()
        }

        waitForExpectationsWithTimeout(10) { error in
            XCTAssertNil(error, "\(error)")
        }
    }

    func testWhenNoOperationsRecordsExist() {
        let expectation = expectationWithDescription("testWhenNoOperationsRecordsExist")

        UDSentinel.sharedInstance.fetchOperations(
            self.host,
            accessToken: "",
            endpoint: self.endpoints["no-operations"]!
            ) { (operations) in

                XCTAssertEqual(0, operations.count)
                expectation.fulfill()
        }

        waitForExpectationsWithTimeout(10) { error in
            XCTAssertNil(error, "\(error)")
        }

    }

    func testWhenNoOperationsEndpointExist() {
        let expectation = expectationWithDescription("testWhenNoOperationsEndpointExist")

        UDSentinel.sharedInstance.fetchOperations(
            host,
            accessToken: "",
            endpoint: self.endpoints["non-existent-endpoint"]!
        ) { (operations) in
            XCTAssertTrue(operations.count == 0)
            expectation.fulfill()
        }

        waitForExpectationsWithTimeout(10) { error in
            XCTAssertNil(error, "\(error)")
        }
    }
}