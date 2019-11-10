//
//  HomeSwticher.swift
//  SoongsilNotice
//
//  Created by TaeinKim on 2019/11/10.
//  Copyright © 2019 TaeinKim. All rights reserved.
//

import Foundation
import UIKit

class HomeSwitcher {
    static func updateRootVC(){
        var rootVC : StartViewController?
        var navigationVC : UINavigationController?
        
//        print(BaseViewController.noticeDeptCode)
//        print(BaseViewController.noticeDeptName)
        
        print("Switcher")
        if(BaseViewController.noticeDeptCode != nil) {
            print("Home")
            navigationVC = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeNavVC") as! UINavigationController)
        } else {
            print("Start")
            rootVC = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StartVC") as! StartViewController)
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if rootVC != nil {
            print("Start2")
            appDelegate.window?.rootViewController = rootVC
        } else {
            print("Home2")
            appDelegate.window?.rootViewController = navigationVC
        }
    }
}
