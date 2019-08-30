
import Foundation
import UIKit
import AWSDynamoDB
import AWSAuthCore


@objcMembers
class LEC_CATE: AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    
    var _LECTURE: String?
    var _개발 : Any?
    var _금융 : Any?
    var _문화 : Any?
    var _어학 : Any?
    var _육아 : Any?
    var _자격증 : Any?
    var _필수 : Any?
    
    
    class func dynamoDBTableName() -> String {
        return "EMPLOYEE"
    }
    
    class func hashKeyAttribute() -> String {
        return "_LECTURE"
    }
    
    override class func jsonKeyPathsByPropertyKey() -> [AnyHashable: Any] {
        return [
            "_LECTURE" : "LECTURE",
            "_개발" : "개발",
            "_금융" : "금융",
            "_문화" : "문화",
            "_어학" : "어학",
            "_육아": "육아",
            "_자격증" : "자격증",
            "_필수" : "필수"
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
                print(type(of:cateItem!._금융))
                var dict:NSDictionary = cateItem!._금융 as! NSDictionary
                print(dict.allKeys)
                
            }
        }
        
    }
    
}
