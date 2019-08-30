
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
        //    "#개발": "개발"
    ]
    queryExpression1.expressionAttributeValues = [
        ":lecture" : "lecture"          //바뀐 부분 이제 쿼리문 일단은 먹힐꺼야
        //    ":개발" : ("C","JAVA","Python","HTML","CSS")
    ]

    
    print(queryExpression1.keyConditionExpression)
    
    
    // 2) Make the query
    let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
    
    dynamoDbObjectMapper.query(LEC_CATE.self, expression: queryExpression1) { (output: AWSDynamoDBPaginatedOutput?, error: Error?) in
  //      print(output)
        if error != nil {
            print("The request failed. Error: \(String(describing: error))")
        }
        if output != nil {
            for cate in output!.items {
                let cateItem = cate as? LEC_CATE
                print(type(of:cateItem!._develop))
                print(cateItem)
                
            }
        }
        
    }
    
}
