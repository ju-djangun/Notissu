//
//  MorePageViewModel.swift
//  Notissu
//
//  Copyright © 2021 Notissu. All rights reserved.
//

import UIKit

protocol MorePageViewModelOutput {
    var deptCode: DeptCode { get }
    var items: [MorePageItem] { get }
    var isRecentVersion: Bool { get }
    var pushViewController: Dynamic<UIViewController?> { get }
}

protocol MorePageViewModelInput {
    func itemDidTap(at index: IndexPath)
}

protocol MorePageViewModelProtocol: MorePageViewModelInput, MorePageViewModelOutput, MyMajorViewModelDelegate {}

class MorePageViewModel: MorePageViewModelProtocol {
    
    //  MARK: - OUTPUT
    var deptCode: DeptCode
    var items: [MorePageItem]
    var isRecentVersion: Bool
    let pushViewController: Dynamic<UIViewController?> = Dynamic(nil)
    
    //  MARK: - Delegate
    func deptChangeButtonDidTap() {
        pushViewController.value = StartViewController()
    }
    
    //  MARK: - INPUT
    func itemDidTap(at indexPath: IndexPath) {
        switch(items[indexPath.row]) {
        case .bookmark:
            let bookmarkViewModel = BookmarkViewModel()
            pushViewController.value = BookmarkViewController(viewModel: bookmarkViewModel)
        case .developer:
            pushViewController.value = DevelopersListViewController(with: DevelopersListViewModel())
        }
    }
    
    //  MARK: - Proeprty
    private let model: MorePageModel
    
    //  MARK: - Init
    init(deptCode: DeptCode, isRecentVersion: Bool) {
        self.model = MorePageModel(deptCode: deptCode,
                                   isRecentVersion: isRecentVersion)
        
        self.deptCode = model.deptCode
        self.items = model.itemsList
        self.isRecentVersion = model.isRecentVersion
    }
}
