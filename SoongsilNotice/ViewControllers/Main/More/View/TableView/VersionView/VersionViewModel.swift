//
//  VersionViewModel.swift
//  Notissu
//
//  Copyright © 2021 Notissu. All rights reserved.
//

import Foundation

class VersionViewModel {
    
    //  MARK: - OUTPUT
    var text: String {
        isRecentVersion
        ? "최신 버전을 사용하고 있습니다."
        : "업데이트가 필요합니다."
    }
    
    //  MARK: - Property
    private let isRecentVersion: Bool
    
    //  MARK: - Init
    init(isRecentVersion: Bool) {
        self.isRecentVersion =  isRecentVersion
    }
}
