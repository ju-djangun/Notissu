//
//  HomeSwticher.swift
//  Notissu
//
//  Copyright © 2019 Notissu. All rights reserved.
//

import UIKit

class HomeSwitcher {
    private var cachedIsUpdateRequired: Bool?
    private var myDeptCode: DeptCode? {
        return DeptCode(rawValue: UserDefaults.standard.integer(forKey: "myDeptCode"))
    }
    private var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
        
    static let shared = HomeSwitcher()
    
    func updateRootVC() {
        if isUpdateRequired() {
            appDelegate.window?.rootViewController = UpdateCheckController()
        } else {
            updateRootVCAfterCheckingVersion()
        }
    }
    
    func updateRootVCAfterCheckingVersion() {
        if myDeptCode == nil {
            appDelegate.window?.rootViewController = StartViewController()
        } else {
            BaseViewController.noticeDeptCode = myDeptCode
            BaseViewController.noticeMajor = Major(majorCode: myDeptCode)
            appDelegate.window?.rootViewController = MainTabBarViewController()
        }
    }
    
    private func isUpdateRequired() -> Bool {
        if let cache = cachedIsUpdateRequired {
            return cache
        }
        
        guard
            let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
            let url = URL(string: "http://itunes.apple.com/lookup?bundleId=com.elliott.notissu-ios"),
            let data = try? Data(contentsOf: url),
            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
            let results = json["results"] as? [[String: Any]],
            results.count > 0,
            let appStoreVersion = results[0]["version"] as? String
        else {
            cachedIsUpdateRequired = false
            return false
        }
        
        print("🗣 Version Checking...")
        print("🗣 ...Current Version : \(version)")
        print("🗣 ...App Store Version : \(appStoreVersion)")
        
        if appStoreVersion.compare(version, options: .numeric) == .orderedDescending {
            cachedIsUpdateRequired = true
            return true
        } else {
            cachedIsUpdateRequired = false
            return false
        }
    }
}
