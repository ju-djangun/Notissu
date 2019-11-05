//
//  NoticeListPresenter.swift
//  SoongsilNotice
//
//  Created by TaeinKim on 2019/11/05.
//  Copyright © 2019 TaeinKim. All rights reserved.
//

import Foundation
import Kanna
import UIKit

class NoticeListPresenter: NoticePresenter {
    var view: NoticeListView
    
    init(view: NoticeListView) {
        self.view = view
    }
    
    func loadNoticeList(page: Int, deptCode: DeptCode) {
        print("deptCode : \(DeptCode.IT_Computer.hashValue)")
        switch deptCode {
        case DeptCode.IT_Computer :
            NoticeIT.parseListComputer(page: page, completion: self.view.applyToTableView)
            break
        default: break
        }
    }
    
}
