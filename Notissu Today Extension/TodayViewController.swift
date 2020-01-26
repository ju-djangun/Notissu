//
//  TodayViewController.swift
//  Notissu Today Extension
//
//  Created by TaeinKim on 2020/01/26.
//  Copyright © 2020 TaeinKim. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, TodayViewProtocol, NCWidgetProviding {
    private var presenter: TodayPresenter!
    private var myDeptName: String?
    
    @IBOutlet var DebugText: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.presenter = TodayPresenter(view: self)
        
        if let userDefaults = UserDefaults(suiteName: "group.com.elliott.Notissu") {
            let myDeptNameRawValue = userDefaults.string(forKey: "myDeptName")
            let myDeptCodeRawValue = userDefaults.integer(forKey: "myDeptCode")
            if myDeptNameRawValue != nil {
                self.myDeptName = myDeptNameRawValue
                self.presenter.loadNoticeList(page: 0, keyword: nil, deptCode: DeptCode(rawValue: myDeptCodeRawValue)!)
            } else {
                self.DebugText.text = "불러오는 중 오류 발생"
            }
        } else {
            self.DebugText.text = "불러오는 중 오류 발생"
        }
    }
    
    func applyToTableView(list: [Notice]) {
        self.DebugText.text = "내 전공 : \(myDeptName ?? "")\n\(list[0].title ?? "")\n\(list[0].date ?? "")"
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
