//
//  WatchConfig.swift
//  Notissu-Watch Extension
//
//  Created by TaeinKim on 2020/03/02.
//  Copyright © 2020 TaeinKim. All rights reserved.
//

import Foundation

enum WatchError: Int {
    case success
    
    case failure
}

struct WatchConfig {
    static var myDeptName: DeptName?
    
    static var myDeptCode: DeptCode?
}
