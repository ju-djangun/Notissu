//
//  TodayViewController.swift
//  Notissu Today Extension
//
//  Created by TaeinKim on 2020/01/26.
//  Copyright © 2020 TaeinKim. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet var DebugText: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let userDefaults = UserDefaults(suiteName: "group.com.elliott.Notissu") {
            let myDeptNameRawValue = userDefaults.string(forKey: "myDeptName")
            let myDeptCodeRawValue = userDefaults.string(forKey: "myDeptCode")
            if myDeptNameRawValue != nil && myDeptCodeRawValue != nil {
                self.DebugText.text = "[name_raw] : \(String(describing: myDeptNameRawValue))\n[code_raw] : \(String(describing: myDeptCodeRawValue))"
            } else {
                self.DebugText.text = "불러오는 중 오류 발생"
            }
        } else {
            self.DebugText.text = "불러오는 중 오류 발생"
        }
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
