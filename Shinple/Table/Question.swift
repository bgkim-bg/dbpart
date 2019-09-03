
import Foundation
import UIKit
import AWSDynamoDB
import AWSAuthCore


@objcMembers


class Question : AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    
    var _Index : NSNumber?
    var _Q_cate : String?
    var _Q_cont : String?
    var _Q_date : String?
    var _Q_id : String?
    var _Q_time : String?
    var _Q_tit : String?
    
    class func dynamoDBTableName() -> String {
        return "Question"
    }
    
    class func hashKeyAttribute() -> String {
        return "_Index"
    }
    
    override class func jsonKeyPathsByPropertyKey() -> [AnyHashable: Any] {
        
        return [
            "_Index" : "Index",
            "_Q_cate" : "Q_cate",
            "_Q_cont" : "Q_cont",
            "_Q_date" : "Q_date",
            "_Q_id" : "Q_id",
            "_Q_time": "Q_time",
            "_Q_tit" : "Q_tit"
        ]
    }
    
}
