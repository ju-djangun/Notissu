//
//  HomeSwticher.swift
//  Notissu
//
//  Copyright © 2019 Notissu. All rights reserved.
//

import Foundation
import UIKit

class HomeSwitcher {
    static func updateRootVC() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if (BaseViewController.noticeDeptCode != nil) {
            //  noticeDeptCode가 존재할 때
            appDelegate.window?.rootViewController = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeNavVC") as! UINavigationController)
        } else {
            //  noticeDeptCode가 존재하지 않을 때
            appDelegate.window?.rootViewController = StartViewController()
        }
        
    }
}
