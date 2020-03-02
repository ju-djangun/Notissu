//
//  InterfacePresenter.swift
//  Notissu-Watch Extension
//
//  Created by TaeinKim on 2020/03/02.
//  Copyright © 2020 TaeinKim. All rights reserved.
//

import Foundation

class InterfacePresenter: InterfacePresenterProtocol {
    private var view: InterfaceViewProtocol!
    
    init(view: InterfaceViewProtocol) {
        self.view = view
    }
    
    func saveCacheData(deptName: String, deptCode: Int) {
        if let userDefaults = UserDefaults(suiteName: "group.com.elliott.Notissu") {
            if WatchConfig.myDeptName?.rawValue ?? "" != deptName {
                userDefaults.set(deptName, forKey: "myDeptName")
                userDefaults.set(deptCode, forKey: "myDeptCode")
                
                WatchConfig.myDeptName = DeptName(rawValue: deptName)
                WatchConfig.myDeptCode = DeptCode(rawValue: deptCode)
            }
        }
    }
    
    func loadCachedConfigData() {
        if let userDefaults = UserDefaults(suiteName: "group.com.elliott.Notissu") {
            let myDeptCode = userDefaults.integer(forKey: "myDeptCode")
            if let myDeptName = userDefaults.string(forKey: "myDeptName") {
                WatchConfig.myDeptName = DeptName(rawValue: myDeptName)
                WatchConfig.myDeptCode = DeptCode(rawValue: myDeptCode)
                self.view.setMajorTextToLabel(result: WatchError.success)
                return
            }
        }
        self.view.setMajorTextToLabel(result: WatchError.failure)
        return
    }
}
