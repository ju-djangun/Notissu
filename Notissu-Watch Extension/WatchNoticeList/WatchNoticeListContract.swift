//
//  WatchNoticeListContract.swift
//  Notissu-Watch Extension
//
//  Created by TaeinKim on 2020/03/02.
//  Copyright © 2020 TaeinKim. All rights reserved.
//

import Foundation

protocol WatchNoticeListViewProtocol {
    func applyListToInterface(list: [Notice])
}

protocol WatchNoticeListPresenterProtocol {
    
    func loadNoticeList(page: Int, keyword: String?, deptCode: DeptCode)
    
}

protocol WatchNoticeListModelProtocol {
    
}
