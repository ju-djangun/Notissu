//
//  NoticesSearchListViewModel.swift
//  Notissu
//
//  Copyright © 2021 Notissu. All rights reserved.
//

import Foundation

class NoticesSearchListViewModel: NoticesListViewModel {
    
    private var didInitialSearch: Bool = false
    
    override func loadInitialPage(keyword: String?) {
        didInitialSearch = true
        super.loadInitialPage(keyword: keyword)
    }
    
    override func loadNextPage() {
        if didInitialSearch { super.loadNextPage() }
    }
}
