import Foundation
import UIKit
import AWSDynamoDB
import AWSAuthCore


@objcMembers
class My_Lec_List: AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    
    var _Index : NSNumber?
    var _E_num : NSNumber?
    var _C_status : Bool?
    var _J_status : Bool?
    var _L_length : NSNumber?
    var _L_link_img : String?
    var _L_link_video : String?
    var _L_name : String?
    var _L_num : NSNumber?
    var _S_num : NSNumber?
    var _U_length : NSNumber?
    
    class func dynamoDBTableName() -> String {
        return "My_Lec_List"
    }
    
    class func hashKeyAttribute() -> String {
        return "_Index"
    }
    
    override class func jsonKeyPathsByPropertyKey() -> [AnyHashable: Any] {
        
        return [
            "_Index" : "Index",
            "_E_num" : "E_num",
            "_C_status" : "C_status",
            "_J_status" : "J_status",
            "_L_length" : "L_length",
            "_L_link_img" : "L_link_img",
            "_L_link_video" : "L_link_video",
            "_L_name" : "L_name",
            "_L_num" : "L_num",
            "_S_num" : "S_num,
            "_U_length" : "U_length"
        ]
    }
    
}

