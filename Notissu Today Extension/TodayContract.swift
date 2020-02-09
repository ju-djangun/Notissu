//
//  TodayContract.swift
//  Notissu Today Extension
//
//  Created by TaeinKim on 2020/01/26.
//  Copyright © 2020 TaeinKim. All rights reserved.
//

import Foundation

protocol TodayViewProtocol {
    func applyToTableView(list: [Notice])
}

protocol TodayPresenterProtocol {
    func fetchCachedInfo(completion: @escaping (Result<WidgetNoticeModel, WidgetNoticeError>) -> Void)
    
    func loadNoticeList(page: Int, keyword: String?, deptCode: DeptCode)
}
