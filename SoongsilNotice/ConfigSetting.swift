//
//  ConfigSetting.swift
//  SoongsilNotice
//
//  Created by TaeinKim on 2019/11/05.
//  Copyright © 2019 TaeinKim. All rights reserved.
//

import Foundation
import UIKit

struct NotiSSU_ColorSet {
    // From Assets.xcassets
    var navBackgroundColor = UIColor(named: "")
    var tabIconTintColor = UIColor(named: "")
    var detailBGColor = UIColor(named: "")
    var homeMajorColor = UIColor(named: "")
}

public enum DeptCode: Int, CaseIterable {
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
    
    // 인문대학
    case Inmun_Korean = 15
    case Inmun_Chinese = 16
    case Inmun_English = 17
    case Inmun_French = 18
    case Inmun_German = 19
    case Inmun_Japanese = 20
    case Inmun_History = 21 // 사학과
    case Inmun_Philosophy = 22 // 철학과
    case Inmun_Creative = 23 // 문예창작
    
    // 자연과학대학
    case NaturalScience_Math = 24 // 수학과
    case NaturalScience_Chemistry = 25 // 화학과
    case NaturalScience_Physics = 26 // 물리학과
    case NaturalScience_Actuarial = 27 // 정보통계 보험수리학과
    case NaturalScience_Medical = 28 // 의생명시스템학부
    
    // 경영대학
    case Business_biz = 29 // 경영학부
    case Business_venture = 30 // 벤처중소기업학과
    case Business_Account = 31 // 회계학과
    case Business_Finance = 32 // 금융학부
    
    // 경제통상대학
    case Economy_Economics = 33 // 경제학과
    case Economy_GlobalCommerce = 34 // 글로벌통상학과
    
    // 사회과학대학
    case Social_Welfare = 35 // 사회복지학부
    case Social_Administration = 36 // 행정학부
    case Social_Sociology = 37 // 정보사회학과
    case Social_Journalism = 38 // 언론홍보학과
    case Social_LifeLong = 39 // 평생교육학과
    case Social_Political = 40 // 정치외교학과
    
}

public enum DeptName: String, CaseIterable {
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
    case Engineering_Organic = "유기신소재ㆍ파이버공학과"
    case Engineering_Electonic = "전기공학과"
    case Engineering_Machine = "기계공학부"
    case Engineering_Industrial = "산업정보시스템공학과"
    
    // 인문대학
    case Inmun_Korean = "국어국문학과"
    case Inmun_Chinese = "중어중문학과"
    case Inmun_English = "영어영문학과"
    case Inmun_French = "불어불문학과"
    case Inmun_German = "독어독문학과"
    case Inmun_Japanese = "일어일문학과"
    case Inmun_History = "사학과"
    case Inmun_Philosophy = "철학과"
    case Inmun_Creative = "문예창작전공"
    
    // 자연과학대학
    case NaturalScience_Math = "수학과" // 수학과
    case NaturalScience_Chemistry = "화학과" // 화학과
    case NaturalScience_Physics = "물리학과" // 물리학과
    case NaturalScience_Actuarial = "정보통계보험수리학과" // 정보통계 보험수리학과
    case NaturalScience_Medical = "의생명시스템학부" // 의생명시스템학부
    
    // 경영대학
    case Business_biz = "경영학부" // 경영학부
    case Business_venture = "벤처중소기업학과" // 벤처중소기업학과
    case Business_Account = "회계학과" // 회계학과
    case Business_Finance = "금융학부" // 금융학부
    
    // 경제통상대학
    case Economy_Economics = "경제학과" // 경제학과
    case Economy_GlobalCommerce = "글로벌통상학과" // 글로벌통상학과
    
    // 사회과학대학
    case Social_Welfare = "사회복지학부" // 사회복지학부
    case Social_Administration = "행정학부" // 행정학부
    case Social_Sociology = "정보사회학과" // 정보사회학과
    case Social_Journalism = "언론홍보학과" // 언론홍보학과
    case Social_LifeLong = "평생교육학과" // 평생교육학과
    case Social_Political = "정치외교학과" // 정치외교학과
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
    
    // 인문대학
    case Inmun_Korean = "Korean Language & Literature"
    case Inmun_Chinese = "Chinese Language & Literature"
    case Inmun_English = "English Language & Literature"
    case Inmun_French = "French Language & Literature"
    case Inmun_German = "German Language & Literature"
    case Inmun_Japanese = "Japanese Language & Literature"
    case Inmun_History = "Department of History"
    case Inmun_Philosophy = "Department of Philosophy"
    case Inmun_Creative = "Major in Creative Writing"
    
    // 자연과학대학
    case NaturalScience_Math = "College of Mathematics" // 수학과
    case NaturalScience_Chemistry = "Department of Chemistry" // 화학과
    case NaturalScience_Physics = "Physics" // 물리학과
    case NaturalScience_Actuarial = "Statistics and Actuarial Science" // 정보통계 보험수리학과
    case NaturalScience_Medical = "School of Systems Biomedical Science" // 의생명시스템학부
    
    // 경영대학
    case Business_biz = "School of Business Administration" // 경영학부
    case Business_venture = "Entrepreneurship and Small Business" // 벤처중소기업학과
    case Business_Account = "Department of Accounting" // 회계학과
    case Business_Finance = "School of Finance" // 금융학부
    
    // 경제통상대학
    case Economy_Economics = "Economics" // 경제학과
    case Economy_GlobalCommerce = "Global Commerce" // 글로벌통상학과
    
    // 사회과학대학
    case Social_Welfare = "School of Social Welfare" // 사회복지학부
    case Social_Administration = "School of Public Administration" // 행정학부
    case Social_Sociology = "Information Sociology" // 정보사회학과
    case Social_Journalism = "Journalism, Public Relations, Advertising" // 언론홍보학과
    case Social_LifeLong = "Lifelong Education" // 평생교육학과
    case Social_Political = "Politics & International Relation" // 정치외교학과
}

struct ConfigSetting {
    static var canFetchData = true
    static var majorCount   = 9
}
