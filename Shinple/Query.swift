////
////  Query.swift
////  Shinple
////
////  Created by 김기성 on 30/08/2019.
////  Copyright © 2019 veronica. All rights reserved.
////
//
import Foundation
import AWSDynamoDB

func queryEmployee(whereQuery: [String:Any], operatorText: [String]) {

    let queryExpression = AWSDynamoDBQueryExpression()
    let keys = whereQuery.keys
    queryExpression.expressionAttributeNames = [String:String]()
    queryExpression.expressionAttributeValues = [String:Any]()
    var expression = ""
    var index = 0
    for key in keys {
        let key1 = "#"+key
        let key2 = ":"+key
        expression = key1+" "+operatorText[index]+" "+key2+" "
        queryExpression.expressionAttributeNames?[key1] = key
        queryExpression.expressionAttributeValues?[key2] = whereQuery[key]
        index += 1
    }
    queryExpression.keyConditionExpression = expression
    // 2) Make the query
    let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
    
    dynamoDbObjectMapper.query(EMPLOYEE.self, expression: queryExpression) { (output: AWSDynamoDBPaginatedOutput?, error: Error?) in
        if error != nil {
            print("The request failed. Error: \(String(describing: error))")
        }
        if output != nil {
            print(output!.items)
            for employee in output!.items {
                let employeeItem = employee as? EMPLOYEE
                var dict:NSDictionary = employeeItem!._My_List as! NSDictionary
                var dic2 = dict.value(forKey: "my_lecture") as! NSDictionary
                print(dic2.allValues, dic2.allValues[2])
            }
        }
        
    }
    
}
//
////func queryLEC_CATE() {
////
////    // 1) Configure the query
////    let queryExpression1 = AWSDynamoDBQueryExpression()
////    queryExpression1.keyConditionExpression = "#Lecture = :Lecture"
////
////    print(queryExpression1.keyConditionExpression)
////
////    queryExpression1.expressionAttributeNames = [
////        "#Lecture": "Lecture",
////    //    "#개발": "개발"
////    ]
////    queryExpression1.expressionAttributeValues = [
////        ":Lecture" : "lecture",          //바뀐 부분 이제 쿼리문 일단은 먹힐꺼야
////    //    ":개발" : ("C","JAVA","Python","HTML","CSS")
////    ]
////
////    // 2) Make the query
////    let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
////
////    dynamoDbObjectMapper.query(LEC_CATE.self, expression: queryExpression1) { (output: AWSDynamoDBPaginatedOutput?, error: Error?) in
////        print(output)
////        if error != nil {
////            print("The request failed. Error: \(String(describing: error))")
////        }
////        if output != nil {
////            print(output!.items)
////            for cate in output!.items {
////                let cateItem = cate as? LEC_CATE
////                print(type(of:cateItem!._금융))
////                var dict:NSDictionary = cateItem!._금융 as! NSDictionary
////                print(dict.allKeys)
////
////            }
////        }
////
////    }
////
////}
