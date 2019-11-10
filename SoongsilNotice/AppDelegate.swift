//
//  AppDelegate.swift
//  SoongsilNotice
//
//  Created by TaeinKim on 2019/11/04.
//  Copyright © 2019 TaeinKim. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let myName = UserDefaults.standard.object(forKey: "myDeptName")
        let myCode = UserDefaults.standard.object(forKey: "myDeptCode")
        
        return true
    }


}

