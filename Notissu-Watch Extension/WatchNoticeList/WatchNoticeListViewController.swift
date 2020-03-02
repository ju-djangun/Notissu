//
//  WatchNoticeListViewController.swift
//  Notissu-Watch Extension
//
//  Created by TaeinKim on 2020/03/02.
//  Copyright © 2020 TaeinKim. All rights reserved.
//

import Foundation
import WatchKit

class WatchNoticeListViewController: WKInterfaceController, WatchNoticeListViewProtocol {
    private var presenter: WatchNoticeListPresenter!
    private var page: Int = 0
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        self.presenter = WatchNoticeListPresenter(view: self)
        
        if let deptCode = WatchConfig.myDeptCode {
            self.presenter.loadNoticeList(page: 0, keyword: nil, deptCode: deptCode)
        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func applyListToInterface(list: [Notice]) {
        
    }
}
