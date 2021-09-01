//
//  HomeSwticher.swift
//  Notissu
//
//  Copyright © 2019 Notissu. All rights reserved.
//

import Foundation
import UIKit

class HomeSwitcher {
    static func updateRootVC(){
        var rootVC : StartViewController?
        var navigationVC : UINavigationController?
        
        if(BaseViewController.noticeDeptCode != nil) {
            navigationVC = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeNavVC") as! UINavigationController)
        } else {
            rootVC = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StartVC") as! StartViewController)
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if rootVC != nil {
            appDelegate.window?.rootViewController = rootVC
        } else {
            appDelegate.window?.rootViewController = navigationVC
        }
    }
}
