//
//  MorePageModel.swift
//  SoongsilNotice
//
//  Copyright © 2021 Notissu. All rights reserved.
//

import Foundation

struct MorePageModel {
    var deptCode: DeptCode
    var itemsList: [MorePageItem] = MorePageItem.allCases
    var isRecentVersion: Bool
}

enum MorePageItem: CaseIterable {
    case bookmark
    case developer
    case opensource
    
    var title: String? {
        switch(self) {
        case .bookmark:
            return "북마크"
        case .developer:
            return "개발자 정보"
        case .opensource:
            return "오픈소스 사용 정보"
        }
    }
}
