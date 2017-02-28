//
//  ViewController.swift
//  JHWebview
//
//  Created by Jonhory on 2017/2/26.
//  Copyright © 2017年 com.wujh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "xxxx"
        self.view.backgroundColor = UIColor.white
        createBtn()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func goWeb() {
        let vc = TestVC.create("http://www.baidu.com",iOSToJSName: "xx")
        vc.leftStr = "back"
        vc.leftHelpStr = UIImage(named: "left")
        vc.rightStr = "明天更好"
        vc.titleStr = "你好"
        vc.rightHelpStr = "你好啊"
        
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func createBtn() {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        btn.backgroundColor = UIColor.red
        btn.center = self.view.center
        btn.addTarget(self, action: #selector(goWeb), for: .touchUpInside)
        self.view.addSubview(btn)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

