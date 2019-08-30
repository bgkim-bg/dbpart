//
//  Query.swift
//  Shinple
//
//  Created by 김기성 on 30/08/2019.
//  Copyright © 2019 veronica. All rights reserved.
//

import Foundation
import AWSDynamoDB

func queryEmployee() {
    
    // 1) Configure the query
    let queryExpression = AWSDynamoDBQueryExpression()
    queryExpression.keyConditionExpression = "#Employee_Number = :Employee_Number AND #Index = :Index"
    
    
    queryExpression.expressionAttributeNames = [
        "#Employee_Number": "Employee_Number",
        "#Index": "Index"
    ]
    queryExpression.expressionAttributeValues = [
        ":Employee_Number" : 1100001,          //바뀐 부분 이제 쿼리문 일단은 먹힐꺼야
        ":Index" : 1
    ]
    
    // 2) Make the query
    let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
    
    dynamoDbObjectMapper.query(EMPLOYEE.self, expression: queryExpression) { (output: AWSDynamoDBPaginatedOutput?, error: Error?) in
        print(output)
        if error != nil {
            print("The request failed. Error: \(String(describing: error))")
        }
        if output != nil {
            print(output!.items)
            for employee in output!.items {
                // 기성아 안녕
                let employeeItem = employee as? EMPLOYEE
                print(type(of:employeeItem!._My_List))
                var dict:NSDictionary = employeeItem!._My_List as! NSDictionary
                print(dict.allKeys)
                
            }
        }
        
    }
    
}
