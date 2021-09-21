//
//  NoticeSearchViewModel.swift
//  Notissu
//
//  Copyright © 2021 Notissu. All rights reserved.
//

import Foundation

final class NoticeSearchViewModel {
    var majorList: Dynamic<[DeptCode]> = Dynamic([])
    
    init() {
        for deptCode in DeptCode.allCases {
            if deptCode != DeptCode.Inmun_Writing {
                majorList.value.append(deptCode)
            }
        }
    }
}
