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
    case IT_Software      = 4
    case IT_SmartSystem   = 5
    case IT_MediaOper     = 6
    
    // 법과대학
    case LAW_Law          = 7
    case LAW_IntlLaw      = 8
    
    // 융합특성화 자유전공학부
    case MIX_mix          = 9
    
    // 공과대학
    case Engineering_Chemistry    = 10
    case Engineering_Organic      = 11
    case Engineering_Electonic    = 12
    case Engineering_Machine      = 13
    case Engineering_Industrial   = 14
    case Engineering_Architecture = 15
}

public enum DeptName: String {
    // IT
    case IT_Computer = "컴퓨터학부"
    case IT_Media = "글로벌미디어학부"
    case IT_Electric = "전자정보공학부"
    case IT_Software = "소프트웨어학부"
    case IT_SmartSystem = "스마트시스템소프트웨어학과"
    case IT_MediaOper = "미디어경영학과"
    // LAW
    case LAW_Law = "법학과"
    case LAW_IntlLaw = "국제법무학과"
    // 융합
    case MIX_mix = "융합특성화자유전공학부"
    // Engineering
    case Engineering_Chemistry = "화학공학과"
    case Engineering_Organic = "유기신소재ㆍ 파이버공학과"
    case Engineering_Electonic = "전기공학과"
    case Engineering_Machine = "기계공학부"
    case Engineering_Industrial = "산업정보시스템공학과"
    case Engineering_Architecture = "건축학부"
}

public enum DeptNameEng: String {
    // IT
    case IT_Computer = "Computer Science & Engineering"
    case IT_Media = "The Global School of Media"
    case IT_Electric = "School of Electronic Engineering"
    case IT_Software = "School of Software"
    case IT_SmartSystem = "Smart Systems Software"
    case IT_MediaOper = "Media and Management"
    // LAW
    case LAW_Law = "Law"
    case LAW_IntlLaw = "Global Law"
    // 융합
    case MIX_mix = "School of Convergence Specialization"
    
    // Engineering
    case Engineering_Chemistry = "Chemical Engineering"
    case Engineering_Organic = "Organic Materials & Fiber"
    case Engineering_Electonic = "School of Electrical Engineering"
    case Engineering_Machine = "School of Mechanical Engineering"
    case Engineering_Industrial = "Industrial & Information Systems"
    case Engineering_Architecture = "School of Architecture"
}

struct ConfigSetting {
    static var canFetchData = true
    static var majorCount   = 9
}
