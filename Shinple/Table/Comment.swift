import Foundation
import UIKit
import AWSDynamoDB
import AWSAuthCore


@objcMembers
class Comment: AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    
    var _C_content : NSNumber?
    var _C_date : String?
    var _L_num : NSNumber?
    var _L_rate : String?
    var _U_id : String?
    
    
    class func dynamoDBTableName() -> String {
        return "Comment"
    }
    
    class func hashKeyAttribute() -> String {
        return "_Index"
    }
    
    override class func jsonKeyPathsByPropertyKey() -> [AnyHashable: Any] {
        
        return [
            "_C_content" : "C_content",
            "_C_date" : "C_date",
            "_L_num" : "L_num",
            "_L_rate" : "L_rate",
            "_U_id" : "U_id"
        ]
    }
    
}
