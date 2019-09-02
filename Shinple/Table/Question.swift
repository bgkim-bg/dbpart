
import Foundation
import UIKit
import AWSDynamoDB
import AWSAuthCore


@objcMembers


class Question : AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    
    var _Index : NSNumber?
    var _Q_ans_cate : String?
    var _Q_ans_cont : String?
    var _Q_ans_date : String?
    var _Q_ans_id : String?
    var _Q_ans_tit : String?
    var _Q_time : String?
    
    class func dynamoDBTableName() -> String {
        return "Question"
    }
    
    class func hashKeyAttribute() -> String {
        return "_Index"
    }
    
    override class func jsonKeyPathsByPropertyKey() -> [AnyHashable: Any] {
        
        return [
            "_Index" : "Index",
            "_Q_ans_cate" : "Q_ans_cate",
            "_Q_ans_check" : "Q_ans_check",
            "_Q_ans_cont" : "Q_ans_cont",
            "_Q_ans_date" : "Q_ans_date",
            "_Q_ans_id": "Q_ans_id",
            "_Q_time" : "Q_time"
        ]
    }
    
}
