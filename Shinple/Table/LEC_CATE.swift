
import Foundation
import UIKit
import AWSDynamoDB
import AWSAuthCore


@objcMembers
class LEC_CATE: AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    
    var _LECTURE: String?
    var _develop : Any?
    var _Finance : Any?
    var _Culture : Any?
    var _English : Any?
    var _Care : Any?
    var _Certificate : Any?
    var _Duty : Any?
    
    
    class func dynamoDBTableName() -> String {
        return "LEC_CATE"
    }
    
    class func hashKeyAttribute() -> String {
        return "_LECTURE"
    }
    
    override class func jsonKeyPathsByPropertyKey() -> [AnyHashable: Any] {
        return [
            "_LECTURE" : "LECTURE",
            "_develop" : "develop",
            "_Finance" : "Finance",
            "_Culture" : "Culture",
            "_English" : "English",
            "_Care": "Care",
            "_Certificate" : "Certificate",
            "_Duty" : "Duty"
        ]
    }
    
}

func queryLEC_CATE() {
    let queryExpression1 = AWSDynamoDBQueryExpression()
    queryExpression1.keyConditionExpression = "#LECTURE = :lecture"
    
    
    queryExpression1.expressionAttributeNames = [
        "#LECTURE": "LECTURE"
       
    ]
    queryExpression1.expressionAttributeValues = [
        ":lecture" : "lecture"
    ]

    
    
    
    // 2) Make the query
    let dynamoDbObjectMapper2 = AWSDynamoDBObjectMapper.default()
    
    dynamoDbObjectMapper2.query(LEC_CATE.self, expression: queryExpression1) { (output: AWSDynamoDBPaginatedOutput?, error: Error?) in
  //      print(output)
        if error != nil {
            print("The request failed. Error: \(String(describing: error))")
        }
        if output != nil {
            for cate in output!.items {
                let cateItem = cate as? LEC_CATE
               print(cateItem)
            }
        }
        
    }
    
}


