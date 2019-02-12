//
//  CacheController.swift
//  JSONEncoder&JSONDecoder_demo
//
//  Created by fashion on 2018/9/6.
//  Copyright © 2018年 shangZhu. All rights reserved.
//

import UIKit

class CacheController: UIViewController {
    
    private var departmentKey = "myDepartment"
    private var userModelKey = "myUserModel"

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        do{
            let btn = UIButton()
            btn.backgroundColor = UIColor.lightGray
            btn.setTitle("store single data", for: .normal)
            btn.addTarget(self, action: #selector(storeSingleDataAction), for: .touchUpInside)
            btn.frame = CGRect.init(x: 0, y: 100, width: 250, height: 50)
            view.addSubview(btn)
        }
        do{
            let btn = UIButton()
            btn.backgroundColor = UIColor.lightGray
            btn.setTitle("fetch single data", for: .normal)
            btn.addTarget(self, action: #selector(fetchSingleDataAction), for: .touchUpInside)
            btn.frame = CGRect.init(x: 0, y: 100+70, width: 250, height: 50)
            view.addSubview(btn)
        }

        do{
            let btn = UIButton()
            btn.backgroundColor = UIColor.blue
            btn.setTitle("store complex data", for: .normal)
            btn.addTarget(self, action: #selector(storeComplexDataAction), for: .touchUpInside)
            btn.frame = CGRect.init(x: 0, y: 100+70+70, width: 200, height: 50)
            view.addSubview(btn)
        }
        do{
            let btn = UIButton()
            btn.backgroundColor = UIColor.blue
            btn.setTitle("fetch complex data", for: .normal)
            btn.addTarget(self, action: #selector(fetchComplexDataAction), for: .touchUpInside)
            btn.frame = CGRect.init(x: 0, y: 100+70+70+70, width: 200, height: 50)
            view.addSubview(btn)
        }
        
        do{
            let btn = UIButton()
            btn.backgroundColor = UIColor.green
            btn.setTitle("store Array data", for: .normal)
            btn.addTarget(self, action: #selector(storeDataArrayAction), for: .touchUpInside)
            btn.frame = CGRect.init(x: 200, y: 100+70+70, width: 200, height: 50)
            view.addSubview(btn)
        }
        do{
            let btn = UIButton()
            btn.backgroundColor = UIColor.green
            btn.setTitle("fetch Array data", for: .normal)
            btn.addTarget(self, action: #selector(fetchDataArrayAction), for: .touchUpInside)
            btn.frame = CGRect.init(x: 200, y: 100+70+70+70, width: 200, height: 50)
            view.addSubview(btn)
        }

        do{
            let btn = UIButton()
            btn.backgroundColor = UIColor.red
            btn.setTitle("remove single data", for: .normal)
            btn.addTarget(self, action: #selector(removeSingleDataAction), for: .touchUpInside)
            btn.frame = CGRect.init(x: 0, y: 100+70+70+70+70, width: 250, height: 50)
            view.addSubview(btn)
        }
        do{
            let btn = UIButton()
            btn.backgroundColor = UIColor.red
            btn.setTitle("remove complex data", for: .normal)
            btn.addTarget(self, action: #selector(removeAllDataAction), for: .touchUpInside)
            btn.frame = CGRect.init(x: 0, y: 100+70+70+70+70+70, width: 250, height: 50)
            view.addSubview(btn)
        }
        
    }

    
    
}

//MARK: -single data
extension CacheController{
    @objc func removeSingleDataAction() {
        DXCacheManager.sharedInstance.removeObjectForKey(userModelKey)
    }
    
    @objc func fetchSingleDataAction() {
        
        DXCacheManager.sharedInstance.getObjectForKey(userModelKey) { (result : UserModel?) in

            guard let item = result else{
                print("获取失败了")
                return
            }
            print("name=\(item.name),age=\(item.age),email=\(item.email),qq=\(String(describing: item.qq))")
        }
    }
    
    
    @objc func storeSingleDataAction() {
        let user = UserModel(name: "Harvey", age: 18, email: "yaozuopan@icloud.com")
        DXCacheManager.sharedInstance.setObject(user, forKey: userModelKey)
    }
}


//MARK: -complex data
extension CacheController{
    
    @objc func removeAllDataAction() {
        DXCacheManager.sharedInstance.removeAllObjects()
    }
    
    @objc func fetchComplexDataAction() {
        
        DXCacheManager.sharedInstance.getObjectForKey(departmentKey) { (result : Department?) in
            guard let model = result else{
                print("获取失败了")
                return
            }

            for item in model.member {
                print("name=\(item.name),age=\(item.age),email=\(item.email),qq=\(item.qq ?? "无")")
            }
        }
    
    }
    
    
    @objc func fetchDataArrayAction() {
        
        DXCacheManager.sharedInstance.getObjectsForKey(departmentKey) { (result :[UserModel]?) in
            guard let model = result else{
                print("获取失败了")
                return
            }
            for item in model {
                print("name=\(item.name),age=\(item.age),email=\(item.email),qq=\(item.qq ?? "无")")
            }
            
        }
    }
    
        
    
    @objc func storeComplexDataAction() {
        let group = Department(name: "软件部", id: 889)
        let user1 = UserModel(name: "Harvey", age: 18, email: "Harvey@icloud.com")
        let user2 = UserModel(name: "Jojo", age: 25, email: "Jojo@icloud.com")
        user2.qq = "863223764"
        group.member = [user1, user2]
        DXCacheManager.sharedInstance.setObject(group, forKey: departmentKey)
    }
    
    
    @objc func storeDataArrayAction() {

        let user1 = UserModel(name: "Harvey", age: 18, email: "Harvey@icloud.com")
        let user2 = UserModel(name: "Jojo", age: 25, email: "Jojo@icloud.com")
        let array = [user1,user2]
        DXCacheManager.sharedInstance.setObject(array, forKey: departmentKey)
    }
    
}
