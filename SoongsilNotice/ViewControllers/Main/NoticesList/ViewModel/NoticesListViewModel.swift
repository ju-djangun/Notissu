//
//  NoticesListViewModel.swift
//  SoongsilNotice
//
//  Copyright © 2021 Notissu. All rights reserved.
//

import Foundation

protocol NoticesListViewModelOutput {
    func didSelectItem(at index: Int)
    func loadInitialPage()
    func loadNextPage()
}

protocol NoticesListViewModelInput {
    var noticesList: Dynamic<[Notice]> { get }
    var nowLoading: Dynamic<Bool> { get }
}

class NoticesListViewModel: NoticesListViewModelInput, NoticesListViewModelOutput {

    //  MARK: - OUTPUT
    var noticesList: Dynamic<[Notice]> = Dynamic([])
    var nowLoading: Dynamic<Bool> = Dynamic(false)
    
    //  MARK: - INPUT
    func didSelectItem(at index: Int) {
        print(index)
    }
    
    func loadInitialPage() {
        page = 1
        loadNextPage()
    }
    
    func loadNextPage() {
        if nowLoading.value { return }
        
        nowLoading.value = true
        getListData(page: page, keyword: keyword)
        page += 1
    }
    
    //  MARK: - 그 외
    
    var deptCode: Dynamic<DeptCode> = Dynamic(.Soongsil)
    var keyword: String?
    var page: Int = 1
    
    init(deptCode: DeptCode, keyword: String? = nil) {
        self.deptCode.value = deptCode
    }
    
    private func getListData(page: Int, keyword: String?) {
        NoticeParser.shared.parseNoticeList(type: self.deptCode.value, page: page, keyword: keyword, completion: { [weak self] list in
            guard let `self` = self else { return }
            self.nowLoading.value = false
            if page < 2 {
                self.noticesList.value = list
            } else {
                self.noticesList.value.append(contentsOf: list)
            }
        })
    }
}
