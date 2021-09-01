//
//  SearchContract.swift
//  SoongsilNotice
//
//  Created by TaeinKim on 2020/01/25.
//  Copyright © 2020 TaeinKim. All rights reserved.
//

import Foundation

protocol SearchViewProtocol {
    
}

protocol SearchPresenterProtocol {
    func getMajorListItem(at: Int) -> DeptCode
    
    func getMajorList() -> [DeptCode]
    
    func getMajorListCount() -> Int
}

protocol SearchModelProtocol {
    func getMajorList() -> [DeptCode]
}
