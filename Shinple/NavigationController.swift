//
//  NavigationController.swift
//  Shinple
//
//  Created by user on 21/08/2019.
//  Copyright © 2019 veronica. All rights reserved.
//

import UIKit
import AWSDynamoDB

class NavigationController: UINavigationController {

    //let img = UIImage(named: "tabbar")
    
    var a: String?
    var b: String?
    var lec_cate: [[String]]?
    
    override func viewDidLoad() {


        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let sample = DispatchQueue(label: "sample", attributes:.concurrent)
        sample.async {
//            self.dbGetLecCate()
            self.dbGetMainLectures()
            print("m0")
            self.funcA()
            print("m1")
        }
//        print(lec_cate, "before")
        print(a, "before")
        self.funcB()
        print(b)
        
        self.navigationBar.tintColor = .white
        self.navigationBar.backgroundColor = UIColor(red: 26/255, green: 2/255, blue: 74/255, alpha:1)
        //self.navigationBar.setBackgroundImage(img, for: .default)
        //self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationBar.shadowImage = UIImage()
    }
    
    func funcA() {
        print("a1")
        sleep(3)
        a = "a"
        print("a2")
    }
    func funcB() {
        print("b1")
        b = "b"
    }
    func dbGetMainLectures() {
        func parseListData(beforeParsed:NSArray) -> [String] {
            var parsed: [String] = []
            for item in beforeParsed {
                parsed.append(item as! String)
            }
            return parsed
        }
        let scanExpression = AWSDynamoDBScanExpression()
        scanExpression.filterExpression = "Lecture_num > :Lecture_num"
        scanExpression.projectionExpression = "Lecture_num, E_date, L_cate, Duty, L_content, L_length, L_link_img, L_link_video, L_name, L_rate, L_teacher, S_cate, S_cate_num, U_date, L_count"
//        scanExpression.expressionAttributeNames = ["Lecture_num":"Lecture_num"]
        scanExpression.expressionAttributeValues = [":Lecture_num":0]
        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
        dynamoDbObjectMapper.scan(LECTURE.self, expression: scanExpression).continueWith(block: { (task:AWSTask!) -> AnyObject? in
            if task.result != nil {
                var lectureResult = [String:[LECTURE]]()
                
                let paginatedOutput = task.result as! AWSDynamoDBPaginatedOutput
                var lectureFamous = [LECTURE]()
                var lectureNew = [LECTURE]()
                var lectureDuty = [LECTURE]()
                var lectureCare = [LECTURE]()
                var lectureDevelop = [LECTURE]()
                var lectureCulture = [LECTURE]()
                var lectureEnglish = [LECTURE]()
                var lectureCerticate = [LECTURE]()
                var lectureFinance = [LECTURE]()
                
                var indexAry = [Double]()
                
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                let today = Date()
                for item in paginatedOutput.items as! [LECTURE] {
                    let upload = formatter.date(from: item._U_date!)
                    let interval = upload?.timeIntervalSince(today) as! Double
                    var inserted = false
                    var index = 0
                    for indexItem in indexAry {
                        if interval >= indexItem {
                            lectureNew.insert(item, at: index)
                            indexAry.insert(interval, at: index)
                            inserted = true
                            break
                        }
                        index += 1
                    }
                    if !inserted {
                        lectureNew.append(item)
                        indexAry.append(interval)
                    }
                    
                    index = 0
                    inserted = false
                    for famous in lectureFamous {
                        if item._L_count?.intValue ?? 0 >= famous._L_count?.intValue ?? 0 {
                            lectureFamous.insert(item, at:index)
                            inserted = true
                            break
                        }
                        index += 1
                    }
                    if !inserted {
                        lectureFamous.append(item)
                    }
                }
                
                for item in lectureNew as! [LECTURE] {
                    if item._Duty == 1 {
                        lectureDuty.append(item)
                    }
                    switch(item._L_cate) {
                        case "Care":
                            lectureCare.append(item)
                            break
                        case "develop":
                            lectureDevelop.append(item)
                            break
                        case "Finanace":
                            lectureFinance.append(item)
                            break
                        case "Culture":
                            lectureCulture.append(item)
                            break
                        case "English":
                            lectureEnglish.append(item)
                            break
                        case "Certicate":
                            lectureCerticate.append(item)
                            break
                        default:
                            break
                    }
                }
                lectureResult["duty"] = lectureDuty
                lectureResult["new"] = lectureNew
                lectureResult["famous"] = lectureFamous
                lectureResult["care"] = lectureCare
                lectureResult["develop"] = lectureDevelop
                lectureResult["finance"] = lectureFinance
                lectureResult["culture"] = lectureCulture
                lectureResult["english"] = lectureEnglish
                lectureResult["certicate"] = lectureCerticate

                if ((task.error) != nil) {
                    print("Error: \(task.error)")
                }
                
            }
            
            return nil
        })
    }
    
    
//    func dbGetLecCate() {
//        func parseListData(beforeParsed:NSArray) -> [String] {
//            var parsed: [String] = []
//            parsed.append("전체")
//            for item in beforeParsed {
//                parsed.append(item as! String)
//            }
//            return parsed
//        }
//        let queryExpression = initQueryExpression()
//        queryExpression.keyConditionExpression = "#LECTURE = :lecture"
//        queryExpression.expressionAttributeNames = ["#LECTURE":"LECTURE"]
//        queryExpression.expressionAttributeValues = [":lecture":"lecture"]
//        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
//        dynamoDbObjectMapper.query(LEC_CATE.self, expression: queryExpression) { (output: AWSDynamoDBPaginatedOutput?, error: Error?) in
//            if error != nil {
//                print("The request failed. Error: \(String(describing: error))")
//            }
//            if output != nil {
//                let data = output!.items.self[0] as! LEC_CATE
//                let firstCategory: [String] = ["전체", "보건", "개발", "어학", "자격증", "필수", "재무"]
//                var secondCategory: [[String]] = []
//                secondCategory.append(parseListData(beforeParsed:data._Care as! NSArray))
//                secondCategory.append(parseListData(beforeParsed:data._develop as! NSArray))
//                secondCategory.append(parseListData(beforeParsed:data._Culture as! NSArray))
//                secondCategory.append(parseListData(beforeParsed:data._English as! NSArray))
//                secondCategory.append(parseListData(beforeParsed:data._Certicate as! NSArray))
//                secondCategory.append(parseListData(beforeParsed:data._Duty as! NSArray))
//                secondCategory.append(parseListData(beforeParsed:data._Finance as! NSArray))
//                self.lec_cate = secondCategory
//                print(firstCategory, "after")
//                print(secondCategory, "after")
//            }
//        }
//    }



}
