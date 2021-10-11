//
//  NoticeFetchManager.swift
//  Notissu
//
//  Copyright © 2021 Notissu. All rights reserved.
//

import Foundation

final class NoticeFetchManager {
    static let shared: NoticeFetchManager = NoticeFetchManager()
    
    func loadNoticeList(page: Int, keyword: String?, deptCode: DeptCode, completion: @escaping ([Notice]) -> Void) {
        switch deptCode {
        case DeptCode.Soongsil:
            NoticeSoongsil.parseSchoolNotice(page: page, keyword: keyword, completion: completion)
            break
        case DeptCode.Dormitory:
            NoticeSoongsil.parseDormitoryNotice(page: page, keyword: keyword, completion: completion)
            break
        case DeptCode.IT_Computer :
            NoticeIT.parseListComputer(page: page, keyword: keyword, completion: completion)
            break
        case DeptCode.IT_Media :
            NoticeIT.parseListMedia(page: page, keyword: keyword, completion: completion)
            break
        case DeptCode.IT_Electric :
            NoticeIT.parseListElectric(page: page, keyword: keyword, completion: completion)
            break
        case DeptCode.IT_Software :
            NoticeIT.parseListSoftware(page: page, keyword: keyword, completion: completion)
            break
        case DeptCode.IT_SmartSystem:
            NoticeIT.parseListSmartSystem(page: page, keyword: keyword, completion: completion)
            break
        case DeptCode.LAW_Law:
            NoticeLaw.parseListLaw(page: page, keyword: keyword, completion: completion)
            break
//        case DeptCode.LAW_IntlLaw:
//            NoticeLaw.parseListIntlLaw(page: page, keyword: keyword, completion: completion)
//            break
        case DeptCode.Inmun_Korean:
            NoticeInmun.parseListKorean(page: page, keyword: keyword, completion: completion)
            break
        case DeptCode.Inmun_Philosophy:
            NoticeInmun.parseListPhilo(page: page, keyword: keyword, completion: completion)
            break
        case DeptCode.Inmun_History:
            NoticeInmun.parseListHistory(page: page, keyword: keyword, completion: completion)
            break
        case DeptCode.Inmun_English:
            NoticeInmun.parseListEnglish(page: page, keyword: keyword, completion: completion)
            break
        case DeptCode.Inmun_Japanese:
            NoticeInmun.parseListJapanese(page: page, keyword: keyword, completion: completion)
            break
        case DeptCode.Inmun_Chinese:
            NoticeInmun.parseListChinese(page: page, keyword: keyword, completion: completion)
            break
        case DeptCode.Inmun_German:
            NoticeInmun.parseListGerman(page: page, keyword: keyword, completion: completion)
            break
        case DeptCode.Inmun_French:
            NoticeInmun.parseListFrench(page: page, keyword: keyword, completion: completion)
            break
        case DeptCode.Inmun_Writing:
            NoticeInmun.parseListWriting(page: page, keyword: keyword, completion: completion)
            break
        case DeptCode.Engineering_Chemistry:
            NoticeEngineering.parseListChemistryEngineering(page: page, keyword: keyword, completion: completion)
            break
        case DeptCode.Engineering_Machine:
            NoticeEngineering.parseListMachine(page: page, keyword: keyword, completion: completion)
            break
        case DeptCode.Engineering_Electonic:
            NoticeEngineering.parseListElectric(page: page, keyword: keyword, completion: completion)
            break
        case DeptCode.Engineering_Industrial:
            NoticeEngineering.parseListIndustry(page: page, keyword: keyword, completion: completion)
            break
        case DeptCode.Engineering_Organic:
            NoticeEngineering.parseListOrganic(page: page, keyword: keyword, completion: completion)
            break
        case DeptCode.Engineering_Architect:
            NoticeEngineering.parseListArchitect(page: page, keyword: keyword ?? "", completion: completion)
            break
        case DeptCode.NaturalScience_Math:
            NoticeNaturalScience.parseListMath(page: page, keyword: keyword, completion: completion)
            break
        case DeptCode.NaturalScience_Physics:
            NoticeNaturalScience.parseListPhysics(page: page, keyword: keyword, completion: completion)
            break
        case DeptCode.NaturalScience_Chemistry:
            NoticeNaturalScience.parseListChemistry(page: page, keyword: keyword, completion: completion)
            break
        case DeptCode.NaturalScience_Actuarial:
            NoticeNaturalScience.parseListActuarial(page: page, keyword: keyword, completion: completion)
            break
        case DeptCode.NaturalScience_Medical:
            NoticeNaturalScience.parseListBiomedical(page: page, keyword: keyword, completion: completion)
            break
        case DeptCode.Business_biz:
            NoticeBusiness.parseListBiz(page: page, keyword: keyword, completion: completion)
            break
        case DeptCode.Business_venture:
            NoticeBusiness.parseListVenture(page: page, keyword: keyword, completion: completion)
            break
        case DeptCode.Business_Account:
            NoticeBusiness.parseListAccount(page: page, keyword: keyword, completion: completion)
            break
        case DeptCode.Business_Finance:
            NoticeBusiness.parseListFinance(page: page, keyword: keyword, completion: completion)
            break
        case DeptCode.Economy_Economics:
            NoticeEconomy.parseListEconomics(page: page, keyword: keyword, completion: completion)
            break
        case DeptCode.Economy_GlobalCommerce:
            NoticeEconomy.parseListGlobalCommerce(page: page, keyword: keyword, completion: completion)
            break
        case DeptCode.Social_Welfare:
            NoticeSocial.parseListWelfare(page: page, keyword: keyword, completion: completion)
            break
        case DeptCode.Social_Administration:
            NoticeSocial.parseListAdministration(page: page, keyword: keyword, completion: completion)
            break
        case DeptCode.Social_Sociology:
            NoticeSocial.parseListSociology(page: page, keyword: keyword, completion: completion)
            break
        case DeptCode.Social_Journalism:
            NoticeSocial.parseListJournalism(page: page, keyword: keyword, completion: completion)
            break
        case DeptCode.Social_LifeLong:
            NoticeSocial.parseListLifeLong(page: page, keyword: keyword, completion: completion)
            break
        case DeptCode.Social_Political:
            NoticeSocial.parseListPolitical(page: page, keyword: keyword, completion: completion)
            break
        case DeptCode.MIX_mix:
            NoticeConvergence.parseListConvergence(page: page, keyword: keyword, completion: completion)
            break
        }
    }
}
