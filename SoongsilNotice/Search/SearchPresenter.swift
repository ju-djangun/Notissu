//
//  SearchPresenter.swift
//  SoongsilNotice
//
//  Created by TaeinKim on 2020/01/25.
//  Copyright © 2020 TaeinKim. All rights reserved.
//

import Foundation

class SearchPresenter: SearchPresenterProtocol {
    private var view: SearchViewProtocol
    private var model = SearchModel()
    
    init(view: SearchViewProtocol) {
        self.view = view
    }
    
    func getMajorListItem(at: Int) -> DeptCode {
        return self.model.getMajorList()[at]
    }
    
    func getMajorList() -> [DeptCode] {
        return self.model.getMajorList()
    }
    
    func getMajorListCount() -> Int {
        return self.model.getMajorList().count
    }
}
