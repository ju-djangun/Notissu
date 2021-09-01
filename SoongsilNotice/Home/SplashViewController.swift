//
//  SplashViewController.swift
//  SoongsilNotice
//
//  Created by TaeinKim on 2019/11/10.
//  Copyright © 2019 TaeinKim. All rights reserved.
//

import UIKit

class SplashViewController : BaseViewController {
    
    override func viewDidLoad() {
        BaseViewController.noticeDeptCode = DeptCode(rawValue: UserDefaults.standard.integer(forKey: "myDeptCode"))
        BaseViewController.noticeMajor = Major(majorCode: BaseViewController.noticeDeptCode)
        HomeSwitcher.updateRootVC()
    }
}
