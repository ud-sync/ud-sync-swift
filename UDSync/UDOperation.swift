open class UDOperation {

    var operationHash: [String: AnyObject]

    public init(operationHash: [String: AnyObject]) {
        self.operationHash = operationHash
    }

    open func isDelete() -> Bool {
        return self.operationName() == "delete"
    }

    open func recordId() -> String {
        return self.operationHash["record_id"] as! String
    }

    open func entity() -> String {
        return self.operationHash["entity"] as! String
    }

    open func operationName() -> String{
        return self.operationHash["name"] as! String
    }
}
