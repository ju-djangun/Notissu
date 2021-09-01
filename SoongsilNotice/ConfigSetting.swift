//
//  ConfigSetting.swift
//  Notissu
//
//  Copyright © 2019 Notissu. All rights reserved.
//

import Foundation
import UIKit

struct NotiSSU_ColorSet {
    // From Assets.xcassets
    public static var notissuBlue = UIColor.hexStringToUIColor(hex: "#2F4F93")
    public static var notissuGrayLight = UIColor.hexStringToUIColor(hex: "#E4E4E4")
    public static var notissuGray = UIColor.hexStringToUIColor(hex: "#9B9B9B")
    public static var notissuWhite = UIColor.hexStringToUIColor(hex: "#FFFFFF")
    public static var notissuTextDark = UIColor.hexStringToUIColor(hex: "#191919")
}

extension UIColor {
    static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

public enum DeptCode: Int, CaseIterable {
    
    // IT대학
    case IT_Computer      = 1
    case IT_Media         = 2
    case IT_Electric      = 3
    case IT_Software      = 4
    case IT_SmartSystem   = 5
    
    // 법과대학
    case LAW_Law          = 6
    case LAW_IntlLaw      = 7
    
    // 공과대학
    case Engineering_Chemistry    = 8
    case Engineering_Organic      = 9
    case Engineering_Electonic    = 10
    case Engineering_Machine      = 11
    case Engineering_Industrial   = 12
    case Engineering_Architect    = 13

    // 인문대학
    case Inmun_Korean = 14
    case Inmun_Chinese = 15
    case Inmun_English = 16
    case Inmun_French = 17
    case Inmun_German = 18
    case Inmun_Japanese = 19
    case Inmun_History = 20 // 사학과
    case Inmun_Philosophy = 21 // 철학과
    case Inmun_Writing = 22
//    case Inmun_Film = 23
    
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
    
    // 융합특성화 자유전공학부
    case MIX_mix          = 41
    
    case Soongsil  = 100
    case Dormitory = 101
    
    func getName(isKorean: Bool = true) -> String {
        switch self {
        case .Soongsil:
            return isKorean ? "숭실대학교 공지" : "SSU Notice"
        case .Dormitory:
            return isKorean ? "레지던스홀(기숙사)" : "Residence Hall"
        case .MIX_mix:
            return isKorean ? "융합특성화자유전공학부" : "School of Convergence Specialization"
        case .IT_Computer:
            return isKorean ? "컴퓨터학부" : "Computer Science & Engineering"
        case .IT_Media:
            return isKorean ? "글로벌미디어학부" : "The Global School of Media"
        case .IT_Software:
            return isKorean ? "소프트웨어학부" : "School of Software"
        case .IT_SmartSystem:
            return isKorean ? "스마트시스템소프트웨어학과" : "Smart Systems Software"
        case .IT_Electric:
            return isKorean ? "전자정보공학부" : "School of Electronic Engineering"
        case .LAW_Law:
            return isKorean ? "법학과" : "Law"
        case .LAW_IntlLaw:
            return isKorean ? "국제법무학과" : "Global Law"
        case .Inmun_Korean:
            return isKorean ? "국어국문학과" : "Korean Language & Literature"
        case .Inmun_French:
            return isKorean ? "불어불문학과" : "French Language & Literature"
        case .Inmun_German:
            return isKorean ? "독어독문학과" : "German Language & Literature"
        case .Inmun_Chinese:
            return isKorean ? "중어중문학과" : "Chinese Language & Literature"
        case .Inmun_English:
            return isKorean ? "영어영문학과" : "English Language & Literature"
        case .Inmun_History:
            return isKorean ? "사학과" : "Department of History"
        case .Inmun_Writing:
            return isKorean ? "예술창작학부 문예창작전공" : "Arts Creation - Major in Creative Writing"
        case .Inmun_Philosophy:
            return isKorean ? "철학과" : "Department of Philosophy"
        case .Inmun_Japanese:
            return isKorean ? "일어일문학과" : "Japanese Language & Literature"
        case .Engineering_Machine:
            return isKorean ? "기계공학부" : "School of Mechanical Engineering"
        case .Engineering_Organic:
            return isKorean ? "유기신소재ㆍ파이버공학과" : "Organic Materials & Fiber"
        case .Engineering_Chemistry:
            return isKorean ? "화학공학과" : "Chemical Engineering"
        case .Engineering_Electonic:
            return isKorean ? "전기공학과" : "School of Electrical Engineering"
        case .Engineering_Architect:
            return isKorean ? "건축학부" : "School of Architect"
        case .Engineering_Industrial:
            return isKorean ? "산업정보시스템공학과" : "Industrial & Information Systems"
        case .Economy_Economics:
            return isKorean ? "경제학과" : "Economics"
        case .Economy_GlobalCommerce:
            return isKorean ? "글로벌통상학과" : "Global Commerce"
        case .Business_biz:
            return isKorean ? "경영학부" : "School of Business Administration"
        case .Business_venture:
            return isKorean ? "벤처중소기업학과" : "Entrepreneurship and Small Business"
        case .Business_Account:
            return isKorean ? "회계학과" : "Department of Accounting"
        case .Business_Finance:
            return isKorean ? "금융학부" : "School of Finance"
        case .NaturalScience_Math:
            return isKorean ? "수학과" : "College of Mathematics"
        case .NaturalScience_Chemistry:
            return isKorean ? "화학과" : "Department of Chemistry"
        case .NaturalScience_Physics:
            return isKorean ? "물리학과" : "Physics"
        case .NaturalScience_Actuarial:
            return isKorean ? "정보통계보험수리학과" : "Statistics and Actuarial Science"
        case .NaturalScience_Medical:
            return isKorean ? "의생명시스템학부" : "School of Systems Biomedical Science"
        case .Social_Welfare:
            return isKorean ? "사회복지학부" : "School of Social Welfare"
        case .Social_Administration:
            return isKorean ? "행정학부" : "School of Public Administration"
        case .Social_Sociology:
            return isKorean ? "정보사회학과" : "Information Sociology"
        case .Social_Journalism:
            return isKorean ? "언론홍보학과" : "Journalism, Public Relations, Advertising"
        case .Social_LifeLong:
            return isKorean ? "평생교육학과" : "Lifelong Education"
        case .Social_Political:
            return isKorean ? "정치외교학과" : "Politics & International Relation"
        }
    }
    
    func parseList(page: Int, keyword: String?, completion: @escaping ([Notice]) -> Void) {
        switch self {
        case .Soongsil:
            NoticeSoongsil.parseSchoolNotice(page: page, keyword: keyword, completion: completion)
        case .Dormitory:
            NoticeSoongsil.parseDormitoryNotice(page: page, keyword: keyword, completion: completion)
        case .MIX_mix:
            NoticeConvergence.parseListConvergence(page: page, keyword: keyword, completion: completion)
        case .IT_Computer:
            NoticeIT.parseListComputer(page: page, keyword: keyword, completion: completion)
        case .IT_Media:
            NoticeIT.parseListMedia(page: page, keyword: keyword, completion: completion)
        case .IT_Software:
            NoticeIT.parseListSoftware(page: page, keyword: keyword, completion: completion)
        case .IT_SmartSystem:
            NoticeIT.parseListSmartSystem(page: page, keyword: keyword, completion: completion)
        case .IT_Electric:
            NoticeIT.parseListElectric(page: page, keyword: keyword, completion: completion)
        case .LAW_Law:
            NoticeLaw.parseListLaw(page: page, keyword: keyword, completion: completion)
        case .LAW_IntlLaw:
            NoticeLaw.parseListIntlLaw(page: page, keyword: keyword, completion: completion)
        case .Inmun_Korean:
            NoticeInmun.parseListKorean(page: page, keyword: keyword, completion: completion)
        case .Inmun_French:
            NoticeInmun.parseListFrench(page: page, keyword: keyword, completion: completion)
        case .Inmun_German:
            NoticeInmun.parseListGerman(page: page, keyword: keyword, completion: completion)
        case .Inmun_Chinese:
            NoticeInmun.parseListChinese(page: page, keyword: keyword, completion: completion)
        case .Inmun_English:
            NoticeInmun.parseListEnglish(page: page, keyword: keyword, completion: completion)
        case .Inmun_History:
            NoticeInmun.parseListHistory(page: page, keyword: keyword, completion: completion)
        case .Inmun_Writing:
            NoticeInmun.parseListWriting(page: page, keyword: keyword, completion: completion)
        case .Inmun_Philosophy:
            NoticeInmun.parseListPhilo(page: page, keyword: keyword, completion: completion)
        case .Inmun_Japanese:
            NoticeInmun.parseListJapanese(page: page, keyword: keyword, completion: completion)
        case .Engineering_Machine:
            NoticeEngineering.parseListMachine(page: page, keyword: keyword, completion: completion)
        case .Engineering_Organic:
            NoticeEngineering.parseListOrganic(page: page, keyword: keyword, completion: completion)
        case .Engineering_Chemistry:
            NoticeEngineering.parseListChemistryEngineering(page: page, keyword: keyword, completion: completion)
        case .Engineering_Electonic:
            NoticeEngineering.parseListElectric(page: page, keyword: keyword, completion: completion)
        case .Engineering_Architect:
            NoticeEngineering.parseListArchitect(page: page, keyword: keyword ?? "", completion: completion)
        case .Engineering_Industrial:
            NoticeEngineering.parseListIndustry(page: page, keyword: keyword, completion: completion)
        case .Economy_Economics:
            NoticeEconomy.parseListEconomics(page: page, keyword: keyword, completion: completion)
        case .Economy_GlobalCommerce:
            NoticeEconomy.parseListGlobalCommerce(page: page, keyword: keyword, completion: completion)
        case .Business_biz:
            NoticeBusiness.parseListBiz(page: page, keyword: keyword, completion: completion)
        case .Business_venture:
            NoticeBusiness.parseListVenture(page: page, keyword: keyword, completion: completion)
        case .Business_Account:
            NoticeBusiness.parseListAccount(page: page, keyword: keyword, completion: completion)
        case .Business_Finance:
            NoticeBusiness.parseListFinance(page: page, keyword: keyword, completion: completion)
        case .NaturalScience_Math:
            NoticeNaturalScience.parseListMath(page: page, keyword: keyword, completion: completion)
        case .NaturalScience_Chemistry:
            NoticeNaturalScience.parseListChemistry(page: page, keyword: keyword, completion: completion)
        case .NaturalScience_Physics:
            NoticeNaturalScience.parseListPhysics(page: page, keyword: keyword, completion: completion)
        case .NaturalScience_Actuarial:
            NoticeNaturalScience.parseListActuarial(page: page, keyword: keyword, completion: completion)
        case .NaturalScience_Medical:
            NoticeNaturalScience.parseListBiomedical(page: page, keyword: keyword, completion: completion)
        case .Social_Welfare:
            NoticeSocial.parseListWelfare(page: page, keyword: keyword, completion: completion)
        case .Social_Administration:
            NoticeSocial.parseListAdministration(page: page, keyword: keyword, completion: completion)
        case .Social_Sociology:
            NoticeSocial.parseListSociology(page: page, keyword: keyword, completion: completion)
        case .Social_Journalism:
            NoticeSocial.parseListJournalism(page: page, keyword: keyword, completion: completion)
        case .Social_LifeLong:
            NoticeSocial.parseListLifeLong(page: page, keyword: keyword, completion: completion)
        case .Social_Political:
            NoticeSocial.parseListPolitical(page: page, keyword: keyword, completion: completion)
        }
    }
}

struct ConfigSetting {
    static var canFetchData = true
    static var majorCount   = 9
}
