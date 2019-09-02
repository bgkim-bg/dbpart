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
<<<<<<< HEAD
        let sample = DispatchQueue(label: "sample", attributes:.concurrent)
        sample.async {
//            self.dbGetLecCate()
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
                var secondCategory: [[String]] = []
                secondCategory.append(parseListData(beforeParsed:data._Care as! NSArray))
                secondCategory.append(parseListData(beforeParsed:data._develop as! NSArray))
                secondCategory.append(parseListData(beforeParsed:data._Culture as! NSArray))
                secondCategory.append(parseListData(beforeParsed:data._English as! NSArray))
                secondCategory.append(parseListData(beforeParsed:data._Certicate as! NSArray))
                secondCategory.append(parseListData(beforeParsed:data._Duty as! NSArray))
                secondCategory.append(parseListData(beforeParsed:data._Finance as! NSArray))
                self.lec_cate = secondCategory
                print(firstCategory, "after")
                print(secondCategory, "after")
            }
        }
    }



}
