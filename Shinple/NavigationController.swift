//
//  NavigationController.swift
//  Shinple
//
//  Created by user on 21/08/2019.
//  Copyright © 2019 veronica. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    //let img = UIImage(named: "tabbar")
    
    override func viewDidLoad() {


        super.viewDidLoad()
        // Do any additional setup after loading the view.

        //queryEmployee()
        // 이름 : 기성, 사번 : 111.   [네임 : 기성, 사번 : 111], [=, =]
        //
        // queryEmployee(whereQuery: <#T##[String : Any]#>, operatorText: <#T##[String]#>)
        
        //queryLEC_CATE()<#T##[String : Any]#>, operatorText: <#T##[String]#>)
        
        queryEMPLOYEE()
        
        self.navigationBar.tintColor = .white
        self.navigationBar.backgroundColor = UIColor(red: 26/255, green: 2/255, blue: 74/255, alpha:1)
        //self.navigationBar.setBackgroundImage(img, for: .default)
        //self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationBar.shadowImage = UIImage()
    }

}
