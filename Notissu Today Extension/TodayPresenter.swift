//
//  TodayPresenter.swift
//  Notissu Today Extension
//
//  Created by TaeinKim on 2020/01/26.
//  Copyright © 2020 TaeinKim. All rights reserved.
//

import Foundation
import CoreData

class TodayPresenter: TodayPresenterProtocol {
    var view: TodayViewProtocol
    var model: TodayModel
    
    init(view: TodayViewProtocol) {
        self.view = view
        self.model = TodayModel()
    }
    
    func getCachedNoticeFromModel() -> [Notice] {
        return self.model.cachedNoticeList ?? [Notice]()
    }
    
    func fetchCachedNotice() -> [Notice] {
        if let noticeData = UserDefaults.standard.data(forKey: "widgetNotice") {
            do {
                let noticeList = try JSONDecoder().decode([Notice].self, from: noticeData)
                self.model.cachedNoticeList = noticeList
                return noticeList
            } catch {
                
            }
        }
        return [Notice]()
    }
    
    func fetchFavoriteNotice() -> [Notice] {
        let context = CoreDataUtil.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")
        self.model.removeAllFavoriteNotice()
        
        do {
            let result = try context.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                let author = data.value(forKey: "author") as! String
                let title = data.value(forKey: "title") as! String
                let url = data.value(forKey: "url") as! String
                let date = data.value(forKey: "date") as! String
                let isNotice = data.value(forKey: "isNotice") as! Bool
                
                self.model.appendFavoriteNotice(notice: Notice(author: author, title: title, url: url, date: date, isNotice: isNotice))
            }
        } catch {
            print("ERROR")
        }
        return self.model.favoriteNoticeList
    }
    
    func fetchCachedInfo(completion: @escaping (Result<WidgetNoticeModel, WidgetNoticeError>) -> Void) {
        if let userDefaults = UserDefaults(suiteName: "group.com.elliott.Notissu") {
            let myDeptNameRawValue = userDefaults.string(forKey: "myDeptName")
            let myDeptCodeRawValue = userDefaults.integer(forKey: "myDeptCode")
            if myDeptNameRawValue != nil {
                completion(.success(WidgetNoticeModel(myDeptName: myDeptNameRawValue ?? "", code: DeptCode(rawValue: myDeptCodeRawValue)!)))
            } else {
                completion(.failure(.deptNameError))
            }
        } else {
            completion(.failure(.noDeptName))
        }
    }
    
    func loadNoticeList(page: Int, keyword: String?, deptCode: DeptCode) {
        switch deptCode {
        case DeptCode.Soongsil:
            NoticeSoongsil.parseSchoolNotice(page: page, keyword: keyword, completion: self.view.applyToTableView(list:))
            break
        case DeptCode.Dormitory:
            NoticeSoongsil.parseDormitoryNotice(page: page, keyword: keyword, completion: self.view.applyToTableView(list:))
            break
        case DeptCode.IT_Computer :
            NoticeIT.parseListComputer(page: page, keyword: keyword, completion: self.view.applyToTableView(list:))
            break
        case DeptCode.IT_Media :
            NoticeIT.parseListMedia(page: page, keyword: keyword, completion: self.view.applyToTableView(list:))
            break
        case DeptCode.IT_Electric :
            NoticeIT.parseListElectric(page: page, keyword: keyword, completion: self.view.applyToTableView(list:))
            break
        case DeptCode.IT_Software :
            NoticeIT.parseListSoftware(page: page, keyword: keyword, completion: self.view.applyToTableView(list:))
            break
        case DeptCode.IT_SmartSystem:
            NoticeIT.parseListSmartSystem(page: page, keyword: keyword, completion: self.view.applyToTableView(list:))
            break
        case DeptCode.LAW_Law:
            NoticeLaw.parseListLaw(page: page, keyword: keyword, completion: self.view.applyToTableView(list:))
            break
//        case DeptCode.LAW_IntlLaw:
//            NoticeLaw.parseListIntlLaw(page: page, keyword: keyword, completion: self.view.applyToTableView(list:))
//            break
        case DeptCode.Inmun_Korean:
            NoticeInmun.parseListKorean(page: page, keyword: keyword, completion: self.view.applyToTableView(list:))
            break
        case DeptCode.Inmun_Philosophy:
            NoticeInmun.parseListPhilo(page: page, keyword: keyword, completion: self.view.applyToTableView(list:))
            break
        case DeptCode.Inmun_History:
            NoticeInmun.parseListHistory(page: page, keyword: keyword, completion: self.view.applyToTableView(list:))
            break
        case DeptCode.Inmun_English:
            NoticeInmun.parseListEnglish(page: page, keyword: keyword, completion: self.view.applyToTableView(list:))
            break
        case DeptCode.Inmun_Japanese:
            NoticeInmun.parseListJapanese(page: page, keyword: keyword, completion: self.view.applyToTableView(list:))
            break
        case DeptCode.Inmun_Chinese:
            NoticeInmun.parseListChinese(page: page, keyword: keyword, completion: self.view.applyToTableView(list:))
            break
        case DeptCode.Inmun_German:
            NoticeInmun.parseListGerman(page: page, keyword: keyword, completion: self.view.applyToTableView(list:))
            break
        case DeptCode.Inmun_French:
            NoticeInmun.parseListFrench(page: page, keyword: keyword, completion: self.view.applyToTableView(list:))
            break
        case DeptCode.Inmun_Writing:
            NoticeInmun.parseListWriting(page: page, keyword: keyword, completion: self.view.applyToTableView(list:))
            break
        case DeptCode.Engineering_Chemistry:
            NoticeEngineering.parseListChemistryEngineering(page: page, keyword: keyword, completion: self.view.applyToTableView(list:))
            break
        case DeptCode.Engineering_Machine:
            NoticeEngineering.parseListMachine(page: page, keyword: keyword, completion: self.view.applyToTableView(list:))
            break
        case DeptCode.Engineering_Electonic:
            NoticeEngineering.parseListElectric(page: page, keyword: keyword, completion: self.view.applyToTableView(list:))
            break
        case DeptCode.Engineering_Industrial:
            NoticeEngineering.parseListIndustry(page: page, keyword: keyword, completion: self.view.applyToTableView(list:))
            break
        case DeptCode.Engineering_Organic:
            NoticeEngineering.parseListOrganic(page: page, keyword: keyword, completion: self.view.applyToTableView(list:))
            break
        case DeptCode.Engineering_Architect:
            NoticeEngineering.parseListArchitect(page: page, keyword: keyword ?? "", completion: self.view.applyToTableView(list:))
            break
        case DeptCode.NaturalScience_Math:
            NoticeNaturalScience.parseListMath(page: page, keyword: keyword, completion: self.view.applyToTableView(list:))
            break
        case DeptCode.NaturalScience_Physics:
            NoticeNaturalScience.parseListPhysics(page: page, keyword: keyword, completion: self.view.applyToTableView(list:))
            break
        case DeptCode.NaturalScience_Chemistry:
            NoticeNaturalScience.parseListChemistry(page: page, keyword: keyword, completion: self.view.applyToTableView(list:))
            break
        case DeptCode.NaturalScience_Actuarial:
            NoticeNaturalScience.parseListActuarial(page: page, keyword: keyword, completion: self.view.applyToTableView(list:))
            break
        case DeptCode.NaturalScience_Medical:
            NoticeNaturalScience.parseListBiomedical(page: page, keyword: keyword, completion: self.view.applyToTableView(list:))
            break
        case DeptCode.Business_biz:
            NoticeBusiness.parseListBiz(page: page, keyword: keyword, completion: self.view.applyToTableView(list:))
            break
        case DeptCode.Business_venture:
            NoticeBusiness.parseListVenture(page: page, keyword: keyword, completion: self.view.applyToTableView(list:))
            break
        case DeptCode.Business_Account:
            NoticeBusiness.parseListAccount(page: page, keyword: keyword, completion: self.view.applyToTableView(list:))
            break
        case DeptCode.Business_Finance:
            NoticeBusiness.parseListFinance(page: page, keyword: keyword, completion: self.view.applyToTableView(list:))
            break
        case DeptCode.Economy_Economics:
            NoticeEconomy.parseListEconomics(page: page, keyword: keyword, completion: self.view.applyToTableView(list:))
            break
        case DeptCode.Economy_GlobalCommerce:
            NoticeEconomy.parseListGlobalCommerce(page: page, keyword: keyword, completion: self.view.applyToTableView(list:))
            break
        case DeptCode.Social_Welfare:
            NoticeSocial.parseListWelfare(page: page, keyword: keyword, completion: self.view.applyToTableView(list:))
            break
        case DeptCode.Social_Administration:
            NoticeSocial.parseListAdministration(page: page, keyword: keyword, completion: self.view.applyToTableView(list:))
            break
        case DeptCode.Social_Sociology:
            NoticeSocial.parseListSociology(page: page, keyword: keyword, completion: self.view.applyToTableView(list:))
            break
        case DeptCode.Social_Journalism:
            NoticeSocial.parseListJournalism(page: page, keyword: keyword, completion: self.view.applyToTableView(list:))
            break
        case DeptCode.Social_LifeLong:
            NoticeSocial.parseListLifeLong(page: page, keyword: keyword, completion: self.view.applyToTableView(list:))
            break
        case DeptCode.Social_Political:
            NoticeSocial.parseListPolitical(page: page, keyword: keyword, completion: self.view.applyToTableView(list:))
            break
        case DeptCode.MIX_mix:
            NoticeConvergence.parseListConvergence(page: page, keyword: keyword, completion: self.view.applyToTableView(list:))
            break
        }
    }
}
