//
//  JSONController.swift
//  JSONEncoder&JSONDecoder_demo
//
//  Created by fashion on 2018/9/6.
//  Copyright © 2018年 shangZhu. All rights reserved.
//

import UIKit

class JSONController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        //============ Native JSON to model =======
        do{
            let btn = UIButton()
            btn.backgroundColor = UIColor.lightGray
            btn.setTitle("JSON to model", for: .normal)
            btn.addTarget(self, action: #selector(JSONToModel), for: .touchUpInside)
            btn.frame = CGRect.init(x: 0, y: 100, width: 250, height: 50)
            view.addSubview(btn)
        }
        do{
            let btn = UIButton()
            btn.backgroundColor = UIColor.lightGray
            btn.setTitle("JSON to complex model", for: .normal)
            btn.addTarget(self, action: #selector(JSONToComplexModel), for: .touchUpInside)
            btn.frame = CGRect.init(x: 0, y: 100+70, width: 250, height: 50)
            view.addSubview(btn)
        }
        
        //============ Native model To JSON =======
        
        do{
            let btn = UIButton()
            btn.backgroundColor = UIColor.blue
            btn.setTitle("model to JSON", for: .normal)
            btn.addTarget(self, action: #selector(modelToJSON), for: .touchUpInside)
            btn.frame = CGRect.init(x: 0, y: 100+70+70, width: 250, height: 50)
            view.addSubview(btn)
        }
        do{
            let btn = UIButton()
            btn.backgroundColor = UIColor.blue
            btn.setTitle("complex model to JSON", for: .normal)
            btn.addTarget(self, action: #selector(complexModelToJSON), for: .touchUpInside)
            btn.frame = CGRect.init(x: 0, y: 100+70+70+70, width: 250, height: 50)
            view.addSubview(btn)
        }
    }

}
//MARK: JSON解码 ---> 将JSON字符串转成[模型]
extension JSONController {
   @objc func JSONToModel() {
        let jsonString = "{\"userName\":\"HarveyCC\",\"age\":20,\"userEmail\":\"yaozuopan@icloud.com\"}"
        
        if let jsonData = jsonString.data(using: String.Encoding.utf8) {
            
            if let user = try? JSONDecoder().decode(UserModel.self, from: jsonData) {
                
                print("----------------Base--------------------")
                print(user.name, user.age, user.email)
            }
        }
       
    }
    
   @objc func JSONToComplexModel(){
        let jsonString = "{\"name\":\"软件部\",\"id\":888,\"member\":[{\"userName\":\"Yoyo\",\"age\":18,\"userEmail\":\"Yoyo@icloud.com\"},{\"userName\":\"Jackly\",\"age\":25,\"userEmail\":\"Jackly@icloud.com\",\"qq\":\"6554866\"}]}"
        
        if let jsonData = jsonString.data(using: String.Encoding.utf8) {
            
            if let group = try? JSONDecoder().decode(Department.self, from: jsonData) {
                
                print("----------------Complex--------------------")
                print(group.name, group.id, group.member.count)
                print(group.member[0].name, group.member[0].age, group.member[0].email, group.member[0].qq ?? "nil")
                print(group.member[1].name, group.member[1].age, group.member[1].email, group.member[1].qq ?? "nil")
            }
        }
    }
    
    
}

//MARK: 将[模型]转成JSON字符串
extension JSONController {
    
   @objc func modelToJSON() {
        let user = UserModel(name: "Harvey", age: 18, email: "yaozuopan@icloud.com")
        if let jsonData = try? JSONEncoder().encode(user) {
            if let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) {

                print("----------------Base--------------------")
                print(jsonString)
            }
        }
    }
    
   @objc func complexModelToJSON() {
  
        let group = Department(name: "软件部", id: 889)
        let user1 = UserModel(name: "Harvey", age: 18, email: "Harvey@icloud.com")
        let user2 = UserModel(name: "Jojo", age: 25, email: "Jojo@icloud.com")
        group.member = [user1, user2]
        if let jsonData = try? JSONEncoder().encode(group)  { 
            if let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) {
                
                print("----------------Complex--------------------")
                print(jsonString)
            }
        }
        
    }
    
}
