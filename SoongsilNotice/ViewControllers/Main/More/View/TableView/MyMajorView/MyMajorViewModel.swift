//
//  MyMajorViewModel.swift
//  Notissu
//
//  Copyright © 2021 Notissu. All rights reserved.
//

import Foundation

class MyMajorViewModel {
    
    //  MARK: - OUTPUT
    var deptCode: DeptCode
    
    //  MARK: - INPUT
    func deptChangeButtonDidTap() {
        delegate?.deptChangeButtonDidTap()
    }
    
    //  MARK: - Delegate
    weak var delegate: MyMajorViewModelDelegate?
    
    //  MARK: - Init
    init(deptCode: DeptCode) {
        self.deptCode = deptCode
    }
}

protocol MyMajorViewModelDelegate: AnyObject {
    func deptChangeButtonDidTap()
}
