//
//  NoticesListViewModel.swift
//  SoongsilNotice
//
//  Copyright © 2021 Notissu. All rights reserved.
//

import Foundation

protocol NoticesListViewModelInput {
    func loadInitialPage(keyword: String?)
    func loadInitialPage()
    func loadNextPage()
}

protocol NoticesListViewModelOutput {
    var noticesList: Dynamic<[Notice]> { get }
    var nowLoading: Dynamic<Bool> { get }
    var deptCode: Dynamic<DeptCode> { get }
    var shouldShowErrorMessage: Dynamic<Bool> { get }
}

protocol NoticesListViewModelProtocol: NoticesListViewModelInput, NoticesListViewModelOutput{}


class NoticesListViewModel: NoticesListViewModelProtocol {

    //  MARK: - OUTPUT
    
    var noticesList: Dynamic<[Notice]> = Dynamic([])
    var nowLoading: Dynamic<Bool> = Dynamic(false)
    var deptCode: Dynamic<DeptCode> = Dynamic(.Soongsil)
    var shouldShowErrorMessage: Dynamic<Bool> = Dynamic(false)
    
    
    //  MARK: - INPUT
        
    func loadInitialPage(keyword: String?) {
        self.keyword = keyword
        loadInitialPage()
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
    
    
    //  MARK: - Property
    
    private var keyword: String?
    private var page: Int = 1
    
    
    //  MARK: - Init
    
    init(deptCode: DeptCode, keyword: String? = nil) {
        self.deptCode.value = deptCode
    }
    
    
    //  MARK: - Func
    private func getListData(page: Int, keyword: String?) {
        NoticeParser.shared.parseNoticeList(type: self.deptCode.value,
                                            page: page,
                                            keyword: keyword,
                                            completion: { [weak self] list in
            guard let `self` = self else { return }
            self.nowLoading.value = false
            self.shouldShowErrorMessage.value = list.isEmpty
            if page < 2 {
                self.noticesList.value = list
            } else {
                self.noticesList.value.append(contentsOf: list)
            }
        })
    }
    
}
