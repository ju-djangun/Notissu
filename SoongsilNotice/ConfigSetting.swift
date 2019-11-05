//
//  ConfigSetting.swift
//  SoongsilNotice
//
//  Created by TaeinKim on 2019/11/05.
//  Copyright © 2019 TaeinKim. All rights reserved.
//

import Foundation

public enum DeptCode: Int {
    // IT대학
    case IT_Computer      = 1
    case IT_Media         = 2
    case IT_Electric_Elec = 3
    case IT_Electric_IT   = 4
    case IT_Software      = 5
    case IT_SmartSystem   = 6
    case IT_MediaOper     = 7
    
    // 법과대학
    case LAW_Law          = 8
    case LAW_IntlLaw      = 9
    
}

struct ConfigSetting {
    static var canFetchData = true
}
