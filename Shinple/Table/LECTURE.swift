//
//  LECTURE.swift
//  Shinple
//
//  Created by user on 28/08/2019.
//  Copyright © 2019 veronica. All rights reserved.
//

import Foundation
import UIKit
import AWSDynamoDB
import AWSAuthCore


@objcMembers
class LECTURE: AWSDynamoDBObjectModel, AWSDynamoDBModeling {

    var _Index: NSNumber?

    var _C_des : String?
    var _H_tag : String?
    var _L_cate : String?
    var _lec_te : String?
    var _Lecture_name : Any?
    var _S_cate : String?


    class func dynamoDBTableName() -> String {
        return "LECTURE"
    }

    class func hashKeyAttribute() -> String {
        return "_Index"
    }

    override class func jsonKeyPathsByPropertyKey() -> [AnyHashable: Any] {
        return [
            "_Index" : "Index",
            "_C_des" : "C_des",
            "_L_cate" : "L_cate",
            "_lec_te" : "_lec_te",
            "_Lecture_name": "Lecture_name",
            "_S_cate" : "S_cate"
        ]
    }

}



func queryLecture() {
    // 1) Configure the query
    let queryExpression = AWSDynamoDBQueryExpression()
    queryExpression.keyConditionExpression = "#Index = :Index AND #H_tag = :H_tag"


    queryExpression.expressionAttributeNames = [
        "#Index": "Index",
        "#H_tag": "H_tag"
    ]
    queryExpression.expressionAttributeValues = [
        ":Index" : 1,
        ":H_tag" : "어학"
    ]

    // 2) Make the query
    let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()



    dynamoDbObjectMapper.query(LECTURE.self, expression: queryExpression) { (output: AWSDynamoDBPaginatedOutput?, error: Error?) in
        if error != nil {
            print("The request failed. Error: \(String(describing: error))")
        }
        if output != nil {
            for lecture in output!.items {
                let lectureItem = lecture as? LECTURE
                print("\(lectureItem!._C_des)")
            }
        }

    }

}
