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
    
    @IBOutlet weak var noticeListView: WKInterfaceTable!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        self.presenter = WatchNoticeListPresenter(view: self)
    }
    
    override func willActivate() {
        super.willActivate()
        
        if let deptCode = WatchConfig.myDeptCode {
            self.presenter.loadNoticeList(page: 1, keyword: nil, deptCode: deptCode)
        }
    }

    override func didDeactivate() {
        super.didDeactivate()
    }
    
    func applyListToInterface(list: [Notice]) {
        self.noticeListView.setNumberOfRows(list.count, withRowType: "watchNoticeCell")
        
        for (index, item) in list.enumerated() {
            let row = self.noticeListView.rowController(at: index) as! WatchNoticeListCell
            
            row.item = item
        }
    }
}
