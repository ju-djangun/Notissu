//
//  NoticesViewModel.swift
//  Notissu
//
//  Copyright © 2021 Notissu. All rights reserved.
//

import Foundation

final class NoticesViewModel {
    var noticeList: Dynamic<[Notice]> = Dynamic([])
    var deptCode: Dynamic<DeptCode> = Dynamic(.Soongsil)
    var keyword: String?
    var page: Int = 1
    
    init(deptCode: DeptCode) {
        self.deptCode.value = deptCode
    }
    
    func getListData(page: Int, keyword: String) {
        NoticeParser.shared.parseNoticeList(type: self.deptCode.value, page: page, keyword: keyword, completion: { [weak self] list in
            guard let `self` = self else { return }
            if page < 2 {
                self.noticeList.value = list
            } else {
                self.noticeList.value.append(contentsOf: list)
            }
        })
    }
}
