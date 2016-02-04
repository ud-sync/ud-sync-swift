import Foundation

public class CDOperation {

    var operationHash: [String: AnyObject]

    public init(operationHash: [String: AnyObject]) {
        self.operationHash = operationHash
    }

    public func isDelete() -> Bool {
        return self.operationName() == "delete"
    }

    public func recordId() -> String {
        return self.operationHash["record_id"] as! String
    }

    public func entity() -> String {
        return self.operationHash["entity"] as! String
    }

    public func operationName() -> String{
        return self.operationHash["name"] as! String
    }
}
