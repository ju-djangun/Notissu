//
//  MorePageViewModel.swift
//  SoongsilNotice
//
//  Created by Gyuni on 2021/09/24.
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
    func deptChangeButtonDidTap()
    func itemDidTap(at index: IndexPath)
}

protocol MorePageViewModelProtocol: MorePageViewModelInput, MorePageViewModelOutput {}

class MorePageViewModel: MorePageViewModelProtocol {
    
    //  MARK: - OUTPUT
    var deptCode: DeptCode
    var items: [MorePageItem]
    var isRecentVersion: Bool
    let pushViewController: Dynamic<UIViewController?> = Dynamic(nil)
    
    //  MARK: - INPUT
    func deptChangeButtonDidTap() {
        pushViewController.value = StartViewController()
    }
    
    func itemDidTap(at indexPath: IndexPath) {
        switch(items[indexPath.row]) {
        case .bookmark:
            pushViewController.value = UIViewController()
        case .developer:
            pushViewController.value = UIViewController()
        case .opensource:
            pushViewController.value = UIViewController()
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
