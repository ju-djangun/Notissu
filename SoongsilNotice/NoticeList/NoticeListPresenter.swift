//
//  NoticeListPresenter.swift
//  SoongsilNotice
//
//  Created by TaeinKim on 2019/11/05.
//  Copyright © 2019 TaeinKim. All rights reserved.
//

import Foundation
import Kanna
import UIKit

class NoticeListPresenter: NoticePresenter {
    var view: NoticeListView
    
    init(view: NoticeListView) {
        self.view = view
    }
    
    func loadNoticeList(page: Int, deptCode: DeptCode) {
        switch deptCode {
        case DeptCode.IT_Computer :
            NoticeIT.parseListComputer(page: page, completion: self.view.applyToTableView)
            break
        case DeptCode.IT_Media :
            NoticeIT.parseListMedia(page: page, completion: self.view.applyToTableView)
            break
        case DeptCode.IT_Electric :
            NoticeIT.parseListElectric(page: page, completion: self.view.applyToTableView)
            break
        case DeptCode.IT_Software :
            NoticeIT.parseListSoftware(page: page, completion: self.view.applyToTableView)
            break
        case DeptCode.IT_SmartSystem:
            NoticeIT.parseListSmartSystem(page: page, completion: self.view.applyToTableView)
            break
        case DeptCode.LAW_Law:
            NoticeLaw.parseListLaw(page: page, completion: self.view.applyToTableView)
            break
        case DeptCode.LAW_IntlLaw:
            NoticeLaw.parseListIntlLaw(page: page, completion: self.view.applyToTableView)
            break
        case DeptCode.Inmun_Korean:
            NoticeInmun.parseListKorean(page: page, completion: self.view.applyToTableView)
            break
            //        case DeptCode.Inmun_Creative:
            //            NoticeInmun.parseListCreative(page: page, completion: self.view.applyToTableView)
        //            break
        case DeptCode.Inmun_Philosophy:
            NoticeInmun.parseListPhilo(page: page, completion: self.view.applyToTableView)
            break
        case DeptCode.Inmun_History:
            NoticeInmun.parseListHistory(page: page, completion: self.view.applyToTableView)
            break
        case DeptCode.Inmun_English:
            NoticeInmun.parseListEnglish(page: page, completion: self.view.applyToTableView)
            break
        case DeptCode.Inmun_Japanese:
            NoticeInmun.parseListJapanese(page: page, completion: self.view.applyToTableView)
            break
        case DeptCode.Inmun_Chinese:
            NoticeInmun.parseListChinese(page: page, completion: self.view.applyToTableView)
            break
        case DeptCode.Inmun_German:
            NoticeInmun.parseListGerman(page: page, completion: self.view.applyToTableView)
            break
        case DeptCode.Inmun_French:
            NoticeInmun.parseListFrench(page: page, completion: self.view.applyToTableView)
            break
        case DeptCode.Engineering_Chemistry:
            NoticeEngineering.parseListChemistryEngineering(page: page, completion: self.view.applyToTableView)
            break
        case DeptCode.Engineering_Machine:
            NoticeEngineering.parseListMachine(page: page, completion: self.view.applyToTableView)
            break
        case DeptCode.Engineering_Electonic:
            NoticeEngineering.parseListElectric(page: page, completion: self.view.applyToTableView)
            break
        case DeptCode.Engineering_Industrial:
            NoticeEngineering.parseListIndustry(page: page, completion: self.view.applyToTableView)
            break
        case DeptCode.Engineering_Organic:
            NoticeEngineering.parseListOrganic(page: page, completion: self.view.applyToTableView)
            break
        case DeptCode.NaturalScience_Math:
            NoticeNaturalScience.parseListMath(page: page, completion: self.view.applyToTableView)
            break
        case DeptCode.NaturalScience_Physics:
            NoticeNaturalScience.parseListPhysics(page: page, completion: self.view.applyToTableView)
            break
        case DeptCode.NaturalScience_Chemistry:
            NoticeNaturalScience.parseListChemistry(page: page, completion: self.view.applyToTableView)
            break
        case DeptCode.NaturalScience_Actuarial:
            NoticeNaturalScience.parseListActuarial(page: page, completion: self.view.applyToTableView)
            break
        case DeptCode.NaturalScience_Medical:
            NoticeNaturalScience.parseListBiomedical(page: page, completion: self.view.applyToTableView)
            break
        case DeptCode.Business_biz:
            NoticeBusiness.parseListBiz(page: page, completion: self.view.applyToTableView)
            break
        case DeptCode.Business_venture:
            NoticeBusiness.parseListVenture(page: page, completion: self.view.applyToTableView)
            break
        case DeptCode.Business_Account:
            NoticeBusiness.parseListAccount(page: page, completion: self.view.applyToTableView)
            break
        case DeptCode.Business_Finance:
            NoticeBusiness.parseListFinance(page: page, completion: self.view.applyToTableView)
            break
        case DeptCode.Economy_Economics:
            NoticeEconomy.parseListEconomics(page: page, completion: self.view.applyToTableView)
            break
        case DeptCode.Economy_GlobalCommerce:
            NoticeEconomy.parseListGlobalCommerce(page: page, completion: self.view.applyToTableView)
            break
        case DeptCode.Social_Welfare:
            NoticeSocial.parseListWelfare(page: page, completion: self.view.applyToTableView)
            break
        case DeptCode.Social_Administration:
            NoticeSocial.parseListAdministration(page: page, completion: self.view.applyToTableView)
            break
        case DeptCode.Social_Sociology:
            NoticeSocial.parseListSociology(page: page, completion: self.view.applyToTableView)
            break
        case DeptCode.Social_Journalism:
            NoticeSocial.parseListJournalism(page: page, completion: self.view.applyToTableView)
            break
        case DeptCode.Social_LifeLong:
            NoticeSocial.parseListLifeLong(page: page, completion: self.view.applyToTableView)
            break
        case DeptCode.Social_Political:
            NoticeSocial.parseListPolitical(page: page, completion: self.view.applyToTableView)
            break
        default: break
        }
    }
    
}
