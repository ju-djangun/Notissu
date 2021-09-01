//
//  NoticeListContract.swift
//  Notissu
//
//  Copyright © 2019 Notissu. All rights reserved.
//

import UIKit

protocol NoticeListView {
    func applyToTableView(list: [Notice])
}

protocol NoticePresenter {
    func loadNoticeList(page: Int, keyword: String?, deptCode: DeptCode)
    
    func fetchFavoriteNoticeList()
}
