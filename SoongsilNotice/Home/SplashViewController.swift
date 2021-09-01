//
//  SplashViewController.swift
//  Notissu
//
//  Copyright © 2019 Notissu. All rights reserved.
//

import UIKit

class SplashViewController : BaseViewController {
    
    override func viewDidLoad() {
        BaseViewController.noticeDeptCode = DeptCode(rawValue: UserDefaults.standard.integer(forKey: "myDeptCode"))
        BaseViewController.noticeMajor = Major(majorCode: BaseViewController.noticeDeptCode)
        HomeSwitcher.updateRootVC()
    }
}
