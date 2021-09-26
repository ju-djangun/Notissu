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
    var itemsList: [MorePageItemModel] { get }
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
    var itemsList: [MorePageItemModel]
    var isRecentVersion: Bool
    let pushViewController: Dynamic<UIViewController?> = Dynamic(nil)
    
    //  MARK: - INPUT
    func deptChangeButtonDidTap() {
        pushViewController.value = StartViewController()
    }
    
    func itemDidTap(at index: IndexPath) {
        let item = itemsList[index.row]
        print(item)
        
        pushViewController.value = UIViewController()
    }
    
    //  MARK: - Proeprty
    private let model: MorePageModel
    
    //  MARK: - Init
    init(deptCode: DeptCode, isRecentVersion: Bool) {
        self.model = MorePageModel(deptCode: deptCode,
                                   isRecentVersion: isRecentVersion)
        
        self.deptCode = model.deptCode
        self.itemsList = model.itemsList
        self.isRecentVersion = model.isRecentVersion
    }
}
