//
//  SearchModel.swift
//  Notissu
//
//  Copyright © 2021 Notissu. All rights reserved.
//

import Foundation

class SearchModel: SearchModelProtocol {
    private var majorList = [DeptCode]()
    
    init() {
        for deptCode in DeptCode.allCases {
            if deptCode != DeptCode.Inmun_Writing {
                majorList.append(deptCode)
            }
        }
    }
    
    func getMajorList() -> [DeptCode] {
        return self.majorList
    }
}
