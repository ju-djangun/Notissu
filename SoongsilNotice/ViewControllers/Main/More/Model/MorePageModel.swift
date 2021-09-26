//
//  MorePageModel.swift
//  SoongsilNotice
//
//  Created by Gyuni on 2021/09/25.
//  Copyright © 2021 Notissu. All rights reserved.
//

import Foundation

struct MorePageModel {
    var deptCode: DeptCode
    var itemsList: [MorePageItemModel] = [
        MorePageItemModel(item: .bookmark, title: "북마크"),
        MorePageItemModel(item: .opensource, title: "오픈소스 사용 정보"),
        MorePageItemModel(item: .developer, title: "개발자 정보"),
    ]
    var isRecentVersion: Bool
}


