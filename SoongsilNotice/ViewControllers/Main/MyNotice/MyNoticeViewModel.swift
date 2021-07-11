//
//  MyNoticeViewModel.swift
//  SoongsilNotice
//
//  Copyright © 2021 Notissu. All rights reserved.
//

import Foundation

final class MyNoticeViewModel {
    var noticeList: Dynamic<[Notice]> = Dynamic<[Notice]>([])
    var page: Int = 0
    var myDeptCode: DeptCode = .IT_Computer
    
    func fetchNoticeList() {
        NoticeFetchManager.shared.loadNoticeList(page: page, keyword: nil, deptCode: myDeptCode, completion: { [weak self] list in
            guard let `self` = self else { return }
            if self.page < 1 {
                self.noticeList.value.removeAll()
            }
            self.noticeList.value.append(contentsOf: list)
        })
    }
}
