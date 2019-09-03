
import Foundation
import UIKit
import AWSDynamoDB
import AWSAuthCore


@objcMembers


class Answer: AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    
    var _Index : NSNumber?
    var _A_ans_cate : String?
    var _A_ans_check : NSNumber?
    var _A_content : String?
    var _A_ans_date : String?
    var _A_ans_id : String?
    var _A_ans_tit : String?
    var _A_time : String?
    
    class func dynamoDBTableName() -> String {
        return "Answer"
    }
    
    class func hashKeyAttribute() -> String {
        return "_Index"
    }
    
    override class func jsonKeyPathsByPropertyKey() -> [AnyHashable: Any] {
        
        return [
            "_Index" : "Index",
            "_A_ans_cate" : "A_ans_cate",
            "_A_ans_check" : "A_ans_check",
            "_A_content" : "A_content",
            "_A_ans_date" : "A_ans_date",
            "_A_ans_id": "A_ans_id",
            "_A_time" : "A_time",
            "_A_tit" : "A_tit"
        ]
    }
    
}
