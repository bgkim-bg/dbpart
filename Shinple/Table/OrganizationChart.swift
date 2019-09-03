
import Foundation
import UIKit
import AWSDynamoDB
import AWSAuthCore


@objcMembers
class OrganizationChart: AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    
    var _CompanyName: String?
    var _Headquarter : Any?
    
    class func dynamoDBTableName() -> String {
        return "QNA"
    }
    
    class func hashKeyAttribute() -> String {
        return "CompanyName"
    }
    
    
    override class func jsonKeyPathsByPropertyKey() -> [AnyHashable: Any] {
        return [
            "_CompanyName" : "CompanyName",
            "_Headquarter" : "Headquarter"
        ]
    }
    
}
