import BrightFutures
import Alamofire
import SwiftyJSON

open class UDSentinel {
    open static let sharedInstance = UDSentinel()

    fileprivate init() {}

    var processing = false
    var singletonPromise = Promise<Bool, NSError>()

    open func fetchOperations(
        _ host: String,
        accessToken: String,
        endpoint: String = "/ud_sync/operations",
        completion: @escaping ([UDOperation]) -> Void
    ) {

        if self.processing == true {
            return
        }
        self.processing = true

        Alamofire.request(
            "\(host)\(endpoint)",
            headers: ["Authorization": "Bearer \(accessToken)"]
        ).responseJSON { response in

            var udOperations: [UDOperation] = []
            self.processing = false

            if response.result.error == nil {
                let result = JSON(response.result.value!)

                let operations = result["operations"].arrayObject

                if operations!.count > 0 {

                    for operation in operations! {
                        let hash = operation as! [String: AnyObject]
                        let udOperation = UDOperation(operationHash: hash)
                        udOperations.append(udOperation)
                    }

                } else if response.response?.statusCode == 401 {
                    // 401 = wrong creds
                    print("[UDSentinel] /ud_sync/operations 401")
                } else {
                    print("[UDSentinel] Unknown error")
                }

            } else {
                print("[UDSentinel] Error: \(response.result.error)")
            }

            completion(udOperations)
        }

    }
}
