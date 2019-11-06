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
    case IT_Electric      = 3
    case IT_Software      = 5
    case IT_SmartSystem   = 6
    case IT_MediaOper     = 7
    
    // 법과대학
    case LAW_Law          = 8
    case LAW_IntlLaw      = 9
    
    // 융합특성화 자유전공학부
    case MIX_mix          = 10
}

public enum DeptName: String {
    case IT_Computer = "컴퓨터학부"
    case IT_Media = "글로벌미디어학부"
    case IT_Electric = "전자정보공학부"
    case IT_Software = "소프트웨어학부"
    case IT_SmartSystem = "스마트시스템소프트웨어학과"
    case IT_MediaOper = "미디어경영학과"
    
    case LAW_Law = "법학과"
    case LAW_IntlLaw = "국제법무학과"
    
    case MIX_mix = "융합특성화자유전공학부"
}

struct ConfigSetting {
    static var canFetchData = true
}
