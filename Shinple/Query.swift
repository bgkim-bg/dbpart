//
//  Query.swift
//  Shinple
//
//  Created by 김기성 on 30/08/2019.
//  Copyright © 2019 veronica. All rights reserved.
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
