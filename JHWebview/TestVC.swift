//
//  TestVC.swift
//  JHWebview
//
//  Created by Jonhory on 2017/2/26.
//  Copyright © 2017年 com.wujh. All rights reserved.
//

import UIKit

class TestVC: JHBaseWebViewVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config(leftStr: UIImage(named: "left"), leftHelpStr: "nihao", titleStr: "百毒", rightHelpStr: "呐喊", rightStr: "你的名字")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
