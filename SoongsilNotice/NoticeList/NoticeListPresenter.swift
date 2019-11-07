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
        switch deptCode {
        case DeptCode.IT_Computer :
            NoticeIT.parseListComputer(page: page, completion: self.view.applyToTableView)
            break
        case DeptCode.IT_Media :
            NoticeIT.parseListMedia(page: page, completion: self.view.applyToTableView)
            break
        case DeptCode.IT_Electric :
            NoticeIT.parseListElectric(page: page, completion: self.view.applyToTableView)
            break
        case DeptCode.IT_Software :
            NoticeIT.parseListSoftware(page: page, completion: self.view.applyToTableView)
            break
        case DeptCode.IT_SmartSystem:
            NoticeIT.parseListSmartSystem(page: page, completion: self.view.applyToTableView)
            
        default: break
        }
    }
    
}
