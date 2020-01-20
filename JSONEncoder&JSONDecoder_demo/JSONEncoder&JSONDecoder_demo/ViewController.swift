//
//  ViewController.swift
//  JSONEncoder&JSONDecoder_demo
//
//  Created by fashion on 2018/9/1.
//  Copyright © 2018年 shangZhu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBAction func jumpToNativeJSONAction(_ sender: Any) {
       
        let vc = JSONController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func jumpToCacheAction(_ sender: Any) {
        let vc = CacheController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
    }


}

