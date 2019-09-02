//
//  LECTURE.swift
//  Shinple
//
//  Created by user on 28/08/2019.
//  Copyright © 2019 veronica. All rights reserved.
// 전면수정

import Foundation
import UIKit
import AWSDynamoDB
import AWSAuthCore


@objcMembers
class LECTURE: AWSDynamoDBObjectModel, AWSDynamoDBModeling {

    var _Lecture_num : NSNumber?
    
    var _Duty : Bool?
    var _E_date : String?
    var _L_cate : String?
    var _L_content : String?
    var _L_link_img : String?
    var _L_link_video : String?
    var _L_name : String?
    var _L_rate : NSNumber?
    var _L_teacher : String?
    var _S_cate : String?
    var _S_cate_num : NSNumber?
    var _U_date : String?

    class func dynamoDBTableName() -> String {
        return "LECTURE"
    }

    class func hashKeyAttribute() -> String {
        return "_Lecture_num"
    }

    override class func jsonKeyPathsByPropertyKey() -> [AnyHashable: Any] {
        return [
            "_Lecture_num" : "Lecture_num",
            "_Duty" : "Duty",
            "_E_date" : "E_date",
            "_L_cate" : "L_cate",
            "_L_content": "L_content",
            "_L_link_img" : "L_link_img",
            "_L_link_video" : "L_link_video",
            "_L_name" : "L_name",
            "_L_rate" : "L_rate",
            "_L_teacher" : "L_teacher",
            "_S_cate" : "S_cate",
            "_S_cate_num" : "S_cate_num",
            "_U_date" : "U_date"
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
//                print("\(lectureItem!._C_des)")
            }
        }

    }

}
