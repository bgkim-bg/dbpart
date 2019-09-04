//
//  NavigationController.swift
//  Shinple
//
//  Created by user on 21/08/2019.
//  Copyright © 2019 veronica. All rights reserved.
//

import UIKit
import AWSDynamoDB
import AWSAuthCore

class NavigationController: UINavigationController {

    //let img = UIImage(named: "tabbar")
    var a: String?
    var b: String?
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let sample = DispatchQueue(label: "sample", attributes:.concurrent)
        sample.async {
//            self.dbGetLecCate()
//            self.dbGetMainLectures()
//            self.dbGetRecentLectures(e_num: 110002)
//            let something: My_Lec_List = My_Lec_List()
//            something._Lecture_num = 11001
//            something._S_cate_num = 11000
//            self.dbGetLectureDetail(lecture: something)
//            self.dbAddComment(l_num: 11001, comment: "싫어요", date: "2018-08-12", u_id: " bkg123")
//            self.dbAddQuestion(q_cate: "사용장애", q_content: "동영상 재생이 불가합니다", q_date: "2019-12-31", q_id: "kisung135", q_time: "22:24", q_tit: "동영상 재생 문제입니다")
//            self.dbGetMainLectures(e_num: 110002)
            self.dbGetQuestion(q_id: "wldn03")
            print("m0")
            self.funcA()
            print("m1")
        }
        print(a, "before")
        self.funcB()
        print(b)
        
        self.navigationBar.tintColor = .white
        self.navigationBar.backgroundColor = UIColor(red: 26/255, green: 2/255, blue: 74/255, alpha:1)
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
//    func dbUpdateLectureWatched(lecture:Any) {
//        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
//        if type(of: lecture) == LECTURE.self {
//            var casted = lecture as! LECTURE
//
//
//
//
//        } else {
//            var casted = lecture as! My_Lec_List
//        }
//
//
//        let uMyLectureList : My_Lec_List = sample![index]
//        uMyLectureList._J_status = type
//        dynamoDbObjectMapper.save(uMyLectureList, completionHandler: {(error: Error?) -> Void in
//        if let error = error {
//        print(" Amazon DynamoDB Save Error: \(error)")
//        return
//        }
//        print("An item was updated.")
//        })
//    }
//    func dbAddRate() {
//        // MARK: need rated people
//    }
    
    // MARK: Need to be tested
    func dbGetQuestion(q_id:String) {
        let scanExpressionQuestion = AWSDynamoDBScanExpression()
        scanExpressionQuestion.filterExpression = "Q_id = :Q_id"
        scanExpressionQuestion.projectionExpression = "Q_cate, Q_check, Q_content, Q_date, Q_time, Q_tit"
        scanExpressionQuestion.expressionAttributeValues = [":Q_id":q_id]
        let dynamoDbObjectMapperQuestion = AWSDynamoDBObjectMapper.default()
        dynamoDbObjectMapperQuestion.scan(Question.self, expression: scanExpressionQuestion).continueWith(block: { (task:AWSTask!) -> AnyObject? in
            if task.result != nil {
                let paginatedOutput = task.result as! AWSDynamoDBPaginatedOutput
                var questions = [Any]()
                var indexAry = [Double]()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                let today = Date()
                for item in paginatedOutput.items as! [Question] {
                    let upload = formatter.date(from: item._Q_date!)
                    let interval = upload?.timeIntervalSince(today) as! Double
                    var inserted = false
                    var index = 0
                    for indexItem in indexAry {
                        if interval >= indexItem {
                            questions.insert(item, at: index)
                            indexAry.insert(interval, at: index)
                            inserted = true
                            break
                        }
                        index += 1
                    }
                    if !inserted {
                        questions.append(item)
                        indexAry.append(interval)
                    }
                }
                print("questions", questions)
                let scanAnsweredQuestion = AWSDynamoDBScanExpression()
                print(q_id, "q_id")
                scanAnsweredQuestion.filterExpression = "Q_id = :Q_id"
                scanAnsweredQuestion.projectionExpression = "A_cate, A_content, A_date, A_time, A_tit, Q_id"
                scanAnsweredQuestion.expressionAttributeValues = [":Q_id":q_id]
                let dynamoDbObjectMapperAnsweredQuestion = AWSDynamoDBObjectMapper.default()
                dynamoDbObjectMapperAnsweredQuestion.scan(ANSWER.self, expression: scanExpressionQuestion).continueWith(block: { (task:AWSTask!) -> AnyObject? in
                    if task.result != nil {
                        let paginatedOutput = task.result as! AWSDynamoDBPaginatedOutput
                        for item2 in paginatedOutput.items as! [ANSWER] {
                            print(item2, "answer")
                            for (index, question) in questions.enumerated() {
                                if (question as AnyObject)._Q_tit == item2._A_tit {
                                    questions.insert(item2, at: index)
                                    print("inserted......", item2)
                                }
                            }
                        }
                        print("total questions", questions)
                    }
                    if ((task.error) != nil) {
                        print("Error: \(task.error)")
                    }
                    return nil
                })
            }
            if ((task.error) != nil) {
                print("Error: \(task.error)")
            }
            return nil
        })
    }
    
    func dbAddQuestion(q_cate:String, q_content:String, q_date:String, q_id:String, q_time:String, q_tit:String) {
        let scanExpression = AWSDynamoDBScanExpression()
        scanExpression.filterExpression = "Q_num > :Q_num"
        scanExpression.projectionExpression = "Q_num"
        scanExpression.expressionAttributeValues = [":Q_num":0]
        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
        dynamoDbObjectMapper.scan(Question.self, expression: scanExpression).continueWith(block: { (task:AWSTask!) -> AnyObject? in
            if task.result != nil {
                let saveMapper = AWSDynamoDBObjectMapper.default()
                let paginatedOutput = task.result as! AWSDynamoDBPaginatedOutput
                let next = paginatedOutput.items.count+1
                let inputQuestion : Question = Question()
                inputQuestion._Q_num = next as NSNumber
                inputQuestion._Q_cate = q_cate
                inputQuestion._Q_check = false
                inputQuestion._Q_content = q_content
                inputQuestion._Q_date = q_date
                inputQuestion._Q_id = q_id
                inputQuestion._Q_time = q_time
                inputQuestion._Q_tit = q_tit
                saveMapper.save(inputQuestion, completionHandler: {
                    (error: Error?) -> Void in
                    if let error = error {
                        print(" Amazon DynamoDB Save Error: \(error)")
                        return
                    }
                    print("An item was updated.")
                })
            }
            if ((task.error) != nil) {
                print("Error: \(task.error)")
            }
            return nil
        })
    }
    

    func dbAddComment(l_num:NSNumber, comment:String, date:String, u_id:String) {
        let scanExpression = AWSDynamoDBScanExpression()
        scanExpression.filterExpression = "C_num > :C_num"
        scanExpression.projectionExpression = "C_num"
        scanExpression.expressionAttributeValues = [":C_num":0]
        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
        dynamoDbObjectMapper.scan(Comment.self, expression: scanExpression).continueWith(block: { (task:AWSTask!) -> AnyObject? in
            if task.result != nil {
                let saveMapper = AWSDynamoDBObjectMapper.default()
                let paginatedOutput = task.result as! AWSDynamoDBPaginatedOutput
                let next = paginatedOutput.items.count+1
                let inputComment : Comment = Comment()
                inputComment._C_num = next as NSNumber
                inputComment._L_num = l_num
                inputComment._C_content = comment
                inputComment._C_date = date
                inputComment._U_id = u_id
                saveMapper.save(inputComment, completionHandler: {
                    (error: Error?) -> Void in
                    if let error = error {
                        print(" Amazon DynamoDB Save Error: \(error)")
                        return
                    }
                    print("An item was updated.")
                })
            }
            if ((task.error) != nil) {
                print("Error: \(task.error)")
            }
            return nil
        })
    }
    
    func dbGetLectureDetail(lecture:Any) {
        let s_cate_num: NSNumber?
        let lecture_num: NSNumber?
        if type(of: lecture) == LECTURE.self {
            var casted = lecture as! LECTURE
            s_cate_num = casted._S_cate_num
            lecture_num = casted._Lecture_num
        } else {
            var casted = lecture as! My_Lec_List
            s_cate_num = casted._S_cate_num
            lecture_num = casted._Lecture_num
        }
        let scanExpression = AWSDynamoDBScanExpression()
        scanExpression.filterExpression = "S_cate_num = :S_cate_num"
        scanExpression.projectionExpression = "Duty, E_date, L_cate, L_content, L_length, L_link_img, L_link_video, L_name, L_rate, L_teacher, Lecture_num, S_cate, S_cate_num, U_date, L_count"
        scanExpression.expressionAttributeValues = [":S_cate_num":Int(truncating: s_cate_num!)]
        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
        dynamoDbObjectMapper.scan(LECTURE.self, expression: scanExpression).continueWith(block: { (task:AWSTask!) -> AnyObject? in
            if task.result != nil {
                let paginatedOutput = task.result as! AWSDynamoDBPaginatedOutput
                var lectureRelated = [LECTURE]()
                print(paginatedOutput)
                for item in paginatedOutput.items as! [LECTURE] {
                    if Int(truncating: item._Lecture_num!) == Int(truncating: lecture_num!) {
                        continue
                    }
                    var inserted = false
                    var index = 0
                    for related in lectureRelated {
                        if Int(truncating: item._Lecture_num!) < Int(truncating: related._Lecture_num!) {
                            lectureRelated.insert(item, at: index)
                            inserted = true
                            break
                        }
                        index += 1
                    }
                    if !inserted {
                        lectureRelated.append(item)
                    }
                }
                print("related", lectureRelated)
            }
            if ((task.error) != nil) {
                print("Error: \(task.error)")
            }
            return nil
        })

        let scanExpressionComment = AWSDynamoDBScanExpression()
        scanExpressionComment.filterExpression = "L_num = :L_num"
        scanExpressionComment.projectionExpression = "L_num, C_content, C_date, U_id"
        scanExpressionComment.expressionAttributeValues = [":L_num":Int(truncating: lecture_num!)]
        print(lecture_num, "lecture_num")
        let dynamoDbObjectMapperComment = AWSDynamoDBObjectMapper.default()
        dynamoDbObjectMapperComment.scan(Comment.self, expression: scanExpressionComment).continueWith(block: { (task:AWSTask!) -> AnyObject? in
            if task.result != nil {
                let paginatedOutput = task.result as! AWSDynamoDBPaginatedOutput
                var lectureComment = [Comment]()
                print(paginatedOutput.items)
                var indexAry = [Double]()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                let today = Date()
                for item in paginatedOutput.items as! [Comment] {
                    let upload = formatter.date(from: item._C_date!)
                    let interval = upload?.timeIntervalSince(today) as! Double
                    var inserted = false
                    var index = 0
                    for indexItem in indexAry {
                        if interval >= indexItem {
                            lectureComment.insert(item, at: index)
                            indexAry.insert(interval, at: index)
                            inserted = true
                            break
                        }
                        index += 1
                    }
                    if !inserted {
                        lectureComment.append(item)
                        indexAry.append(interval)
                    }
                }
                print("related", lectureComment)
            }
            if ((task.error) != nil) {
                print("Error: \(task.error)")
            }
            return nil
        })

    }

    // MARK: Need to be tested
//    func dbAddJjimMyLectureListSample(type:NSNumber, index: Int) {
//        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
//        let uMyLectureList : My_Lec_List = sample![index]
//        uMyLectureList._J_status = type
//        dynamoDbObjectMapper.save(uMyLectureList, completionHandler: {(error: Error?) -> Void in
//        if let error = error {
//        print(" Amazon DynamoDB Save Error: \(error)")
//        return
//        }
//        print("An item was updated.")
//        })
//    }


    func dbGetRecentLectures(e_num: NSNumber) {
        let scanExpression = AWSDynamoDBScanExpression()
        scanExpression.filterExpression = "E_num = :E_num"
        scanExpression.projectionExpression = "My_num, E_num, C_status, J_status, L_length, L_link_img, L_link_video, L_name, L_num, S_num, U_length, W_date"
        scanExpression.expressionAttributeValues = [":E_num":Int(truncating: e_num)]
        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
        dynamoDbObjectMapper.scan(My_Lec_List.self, expression: scanExpression).continueWith(block: { (task:AWSTask!) -> AnyObject? in
            if task.result != nil {
                let paginatedOutput = task.result as! AWSDynamoDBPaginatedOutput
                var indexAry = [Double]()
                let formatter = DateFormatter()
                var lectureMy = [My_Lec_List]()
                formatter.dateFormat = "yyyy-MM-dd"
                let today = Date()
                for item in paginatedOutput.items as! [My_Lec_List] {
                    print(item)
                    let upload = formatter.date(from: item._W_date!)
                    let interval = upload?.timeIntervalSince(today) as! Double
                    var inserted = false
                    var index = 0
                    for indexItem in indexAry {
                        if interval >= indexItem {
                            lectureMy.insert(item, at: index)
                            indexAry.insert(interval, at: index)
                            inserted = true
                            break
                        }
                    index += 1
                    }
                    if !inserted {
                        lectureMy.append(item)
                        indexAry.append(interval)
                    }
                    print("hash")
                }
                print(lectureMy)
            }
            if ((task.error) != nil) {
                print("Error: \(task.error)")
            }
            return nil
        })
    }
    
    // MARK: Need to be tested
    func dbGetMyLecturesFromMainLectures(e_num:NSNumber, fromLectures:[String:[Any]]) {
        var toLectures = [String:[Any]]()
        let scanExpression = AWSDynamoDBScanExpression()
        scanExpression.filterExpression = "E_num = :E_num"
        scanExpression.projectionExpression = "My_num, C_status, Duty, E_date, E_num, J_status, L_length, L_link_img, L_link_video, L_name, Lecture_num, S_cate_num, U_length, W_date"
        scanExpression.expressionAttributeValues = [":E_num":Int(truncating: e_num)]
        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
                dynamoDbObjectMapper.scan(My_Lec_List.self, expression: scanExpression).continueWith(block: { (task:AWSTask!) -> AnyObject? in
                    if task.result != nil {
                        let paginatedOutput = task.result as! AWSDynamoDBPaginatedOutput
                        for item in paginatedOutput.items as! [My_Lec_List] {
                            for key in fromLectures.keys {
                                if fromLectures[key] == nil {
                                    toLectures[key] = fromLectures[key]
                                    continue
                                }
//                                print("hello!!!!", fromLectures[key], key)
                                
                                var temp = [Any]()
                                for data in fromLectures[key]! {
//                                    print("world!!", data)
//                                    print("is same??", (data as AnyObject)._Lecture_num, item._Lecture_num)
                                    if (data as AnyObject)._Lecture_num == item._Lecture_num {
                                        print("same!!", key, (data as AnyObject)._Lecture_num, item._Lecture_num)
                                        temp.append(item)
                                        print(toLectures)
                                    } else {
//                                        print("not same!!", key, (data as AnyObject)._Lecture_num, item._Lecture_num)
                                        temp.append(data)
                                    }
                                }
                                toLectures[key] = temp
                            }
                        }
                        print("resolved item....", toLectures)
                    }
                    if ((task.error) != nil) {
                        print("Error: \(task.error)")
                    }
                    return nil
                })
    }
    
    // MARK: Need to be tested
    func dbGetMainLectures(e_num:NSNumber) {
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
        scanExpression.expressionAttributeValues = [":Lecture_num":0]
        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
        dynamoDbObjectMapper.scan(LECTURE.self, expression: scanExpression).continueWith(block: { (task:AWSTask!) -> AnyObject? in
            if task.result != nil {
                var lectureResult = [String:[Any]]()
                
                let paginatedOutput = task.result as! AWSDynamoDBPaginatedOutput
                var lectureFamous = [Any]()
                var lectureNew = [Any]()
                var lectureDuty = [Any]()
                var lectureCare = [Any]()
                var lectureDevelop = [Any]()
                var lectureCulture = [Any]()
                var lectureEnglish = [Any]()
                var lectureCerticate = [Any]()
                var lectureFinance = [Any]()

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
                        if item._L_count?.intValue ?? 0 >= (famous as AnyObject)._L_count?.intValue ?? 0 {
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

//                print(lectureResult)
                print("function started")
                self.dbGetMyLecturesFromMainLectures(e_num: e_num, fromLectures: lectureResult)
                if ((task.error) != nil) {
                    print("Error: \(task.error)")
                }

            }

            return nil
        })
    }
    
    
    func dbGetLecCate() {
        func parseListData(beforeParsed:NSArray) -> [String] {
            var parsed: [String] = []
            parsed.append("전체")
            for item in beforeParsed {
                parsed.append(item as! String)
            }
            return parsed
        }
        let queryExpression = initQueryExpression()
        queryExpression.keyConditionExpression = "#LECTURE = :lecture"
        queryExpression.expressionAttributeNames = ["#LECTURE":"LECTURE"]
        queryExpression.expressionAttributeValues = [":lecture":"lecture"]
        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
        dynamoDbObjectMapper.query(LEC_CATE.self, expression: queryExpression) { (output: AWSDynamoDBPaginatedOutput?, error: Error?) in
            if error != nil {
                print("The request failed. Error: \(String(describing: error))")
            }
            if output != nil {
                let data = output!.items.self[0] as! LEC_CATE
                let firstCategory: [String] = ["전체", "보건", "개발", "어학", "자격증", "필수", "재무"]
                var secondCategory = [[String]]()
//                for cate in firstCategory {
//                    secondCategory.append(parseListData(beforeParsed:data[cate] as! NSArray))
//                }
//                secondCategory.append(parseListData(beforeParsed:data._Care as! NSArray))
//                secondCategory.append(parseListData(beforeParsed:data._develop as! NSArray))
//                secondCategory.append(parseListData(beforeParsed:data._Culture as! NSArray))
//                secondCategory.append(parseListData(beforeParsed:data._English as! NSArray))
//                secondCategory.append(parseListData(beforeParsed:data._Certicate as! NSArray))
//                secondCategory.append(parseListData(beforeParsed:data._Duty as! NSArray))
//                secondCategory.append(parseListData(beforeParsed:data._Finance as! NSArray))
//                self.lec_cate = secondCategory
                print(firstCategory, "after")
                print(secondCategory, "after")
            }
        }
    }

}

