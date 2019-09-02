
import Foundation
import UIKit
import AWSDynamoDB
import AWSAuthCore


@objcMembers
class NOTICE: AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    
    var _Index: NSNumber?
    var _Noti_cate : String?
    var _Noti_content : String?
    var _Noti_date : String?
    
    
    class func dynamoDBTableName() -> String {
        return "NOTICE"
    }
    
    class func hashKeyAttribute() -> String {
        return "CompanyName"
    }
    
    
    override class func jsonKeyPathsByPropertyKey() -> [AnyHashable: Any] {
        return [
            "_CompanyName" : "CompanyName",
            "_Noti_cate" : "Noti_cate",
            "_Noti_content" : "Noti_content",
            "_Noti_date" : "Noti_date"
        ]
    }
    
}
