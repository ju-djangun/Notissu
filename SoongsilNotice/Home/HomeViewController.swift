//
//  HomeViewController.swift
//  SoongsilNotice
//
//  Created by TaeinKim on 2019/11/07.
//  Copyright © 2019 TaeinKim. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // IT대학
    var majorCodeListIT = [DeptCode.IT_Computer, DeptCode.IT_Media, DeptCode.IT_Electric, DeptCode.IT_Software, DeptCode.IT_SmartSystem]
    var majorNameListIT = [DeptName.IT_Computer, DeptName.IT_Media, DeptName.IT_Electric, DeptName.IT_Software, DeptName.IT_SmartSystem]
    var majorEngNameListIT = [DeptNameEng.IT_Computer, DeptNameEng.IT_Media, DeptNameEng.IT_Electric, DeptNameEng.IT_Software, DeptNameEng.IT_SmartSystem]
    
    // 법과대학
    var majorCodeListLaw = [DeptCode.LAW_Law, DeptCode.LAW_IntlLaw]
    var majorNameListLaw = [DeptName.LAW_Law, DeptName.LAW_IntlLaw]
    var majorEngNameListLaw = [DeptNameEng.LAW_Law, DeptNameEng.LAW_IntlLaw]
    
    // 인문대학
    var majorCodeListInmun = [DeptCode.Inmun_Korean, DeptCode.Inmun_French, DeptCode.Inmun_German, DeptCode.Inmun_Chinese, DeptCode.Inmun_English, DeptCode.Inmun_History, DeptCode.Inmun_Philosophy, DeptCode.Inmun_Japanese]
    var majorNameListInmun = [DeptName.Inmun_Korean, DeptName.Inmun_French, DeptName.Inmun_German, DeptName.Inmun_Chinese, DeptName.Inmun_English, DeptName.Inmun_History, DeptName.Inmun_Philosophy, DeptName.Inmun_Japanese]
    var majorEngNameListInmun = [DeptNameEng.Inmun_Korean, DeptNameEng.Inmun_French, DeptNameEng.Inmun_German, DeptNameEng.Inmun_Chinese, DeptNameEng.Inmun_English, DeptNameEng.Inmun_History, DeptNameEng.Inmun_Philosophy, DeptNameEng.Inmun_Japanese]
    
    // 공과대학
    var majorCodeListEngineer = [DeptCode.Engineering_Chemistry, DeptCode.Engineering_Machine, DeptCode.Engineering_Electonic, DeptCode.Engineering_Industrial, DeptCode.Engineering_Organic, DeptCode.Engineering_Architect]
    var majorNameListEngineer = [DeptName.Engineering_Chemistry, DeptName.Engineering_Machine, DeptName.Engineering_Electonic, DeptName.Engineering_Industrial, DeptName.Engineering_Organic, DeptName.Engineering_Architect]
    var majorEngNameListEngineer = [DeptNameEng.Engineering_Chemistry, DeptNameEng.Engineering_Machine, DeptNameEng.Engineering_Electonic, DeptNameEng.Engineering_Industrial, DeptNameEng.Engineering_Organic, DeptNameEng.Engineering_Architect]
    
    // 자연과학대학
    var majorCodeListNaturalScience = [DeptCode.NaturalScience_Math, DeptCode.NaturalScience_Physics, DeptCode.NaturalScience_Chemistry, DeptCode.NaturalScience_Actuarial, DeptCode.NaturalScience_Medical]
    var majorNameListNaturalScience = [DeptName.NaturalScience_Math, DeptName.NaturalScience_Physics, DeptName.NaturalScience_Chemistry, DeptName.NaturalScience_Actuarial, DeptName.NaturalScience_Medical]
    var majorEngNameListNaturalScience = [DeptNameEng.NaturalScience_Math, DeptNameEng.NaturalScience_Physics, DeptNameEng.NaturalScience_Chemistry, DeptNameEng.NaturalScience_Actuarial, DeptNameEng.NaturalScience_Medical]
    
    // 경영대학 4
    var majorCodeListBusiness = [DeptCode.Business_biz, DeptCode.Business_venture, DeptCode.Business_Account, DeptCode.Business_Finance]
    var majorNameListBusiness = [DeptName.Business_biz, DeptName.Business_venture, DeptName.Business_Account, DeptName.Business_Finance]
    var majorEngNameListBusiness = [DeptNameEng.Business_biz, DeptNameEng.Business_venture, DeptNameEng.Business_Account, DeptNameEng.Business_Finance]
    
    // 경제통상대학 2
    var majorCodeListEconomy = [DeptCode.Economy_Economics, DeptCode.Economy_GlobalCommerce]
    var majorNameListEconomy = [DeptName.Economy_Economics, DeptName.Economy_GlobalCommerce]
    var majorEngNameListEconomy = [DeptNameEng.Economy_Economics, DeptNameEng.Economy_GlobalCommerce]
    
    // 사회과학대학 6
    var majorCodeListSocial = [DeptCode.Social_Welfare, DeptCode.Social_Administration, DeptCode.Social_Sociology, DeptCode.Social_Journalism, DeptCode.Social_LifeLong, DeptCode.Social_Political]
    var majorNameListSocial = [DeptName.Social_Welfare, DeptName.Social_Administration, DeptName.Social_Sociology, DeptName.Social_Journalism, DeptName.Social_LifeLong, DeptName.Social_Political]
    var majorEngNameListSocial = [DeptNameEng.Social_Welfare, DeptNameEng.Social_Administration, DeptNameEng.Social_Sociology, DeptNameEng.Social_Journalism, DeptNameEng.Social_LifeLong, DeptNameEng.Social_Political]
    
    var sections = ["IT 대학", "법과대학", "인문대학", "공과대학", "자연과학대학", "경영대학", "경제통상대학", "사회과학대학", "융합특성화자유전공학부"]
    
    var majorListIT       = [Major]()
    var majorListLaw      = [Major]()
    var majorListInmun    = [Major]()
    var majorListEngineer = [Major]()
    var majorListNatural  = [Major]()
    var majorListBusiness = [Major]()
    var majorListEconomy  = [Major]()
    var majorListSocial   = [Major]()
    
    var majorConvergence = Major(majorCode: DeptCode.MIX_mix, majorName: DeptName.MIX_mix, majorNameEng: DeptNameEng.MIX_mix)
    
    @IBOutlet var majorListView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "전공 목록"
    }
    
    override func viewDidLoad() {
        for index in 0..<majorCodeListIT.count {
            majorListIT.append(Major(majorCode: majorCodeListIT[index], majorName: majorNameListIT[index], majorNameEng: majorEngNameListIT[index]))
        }
        
        for index in 0..<majorCodeListLaw.count {
            majorListLaw.append(Major(majorCode: majorCodeListLaw[index], majorName: majorNameListLaw[index], majorNameEng: majorEngNameListLaw[index]))
        }
        
        for index in 0..<majorCodeListInmun.count {
            majorListInmun.append(Major(majorCode: majorCodeListInmun[index], majorName: majorNameListInmun[index], majorNameEng: majorEngNameListInmun[index]))
        }
        
        for index in 0..<majorCodeListEngineer.count {
            majorListEngineer.append(Major(majorCode: majorCodeListEngineer[index], majorName: majorNameListEngineer[index], majorNameEng: majorEngNameListEngineer[index]))
        }
        
        for index in 0..<majorCodeListNaturalScience.count {
            majorListNatural.append(Major(majorCode: majorCodeListNaturalScience[index], majorName: majorNameListNaturalScience[index], majorNameEng: majorEngNameListNaturalScience[index]))
        }
        
        for index in 0..<majorCodeListBusiness.count {
            majorListBusiness.append(Major(majorCode: majorCodeListBusiness[index], majorName: majorNameListBusiness[index], majorNameEng: majorEngNameListBusiness[index]))
        }
        
        for index in 0..<majorCodeListEconomy.count {
            majorListEconomy.append(Major(majorCode: majorCodeListEconomy[index], majorName: majorNameListEconomy[index], majorNameEng: majorEngNameListEconomy[index]))
        }
        
        for index in 0..<majorCodeListSocial.count {
            majorListSocial.append(Major(majorCode: majorCodeListSocial[index], majorName: majorNameListSocial[index], majorNameEng: majorEngNameListSocial[index]))
        }
        
        self.majorListView.delegate = self
        self.majorListView.dataSource = self
        self.majorListView.tableFooterView = UIView()
        self.majorListView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int { return sections.count }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = self.storyboard!
        let noticeListViewController = storyBoard.instantiateViewController(withIdentifier: "noticeListVC") as? NoticeListViewController
        
        if indexPath.section == 0 {
            noticeListViewController?.noticeDeptCode = majorListIT[indexPath.row].majorCode
            noticeListViewController?.noticeDeptName = majorListIT[indexPath.row].majorName
        } else if indexPath.section == 1 {
            noticeListViewController?.noticeDeptCode = majorListLaw[indexPath.row].majorCode
            noticeListViewController?.noticeDeptName = majorListLaw[indexPath.row].majorName
        } else if indexPath.section == 2 {
            noticeListViewController?.noticeDeptCode = majorListInmun[indexPath.row].majorCode
            noticeListViewController?.noticeDeptName = majorListInmun[indexPath.row].majorName
        } else if indexPath.section == 3 {
            noticeListViewController?.noticeDeptCode = majorListEngineer[indexPath.row].majorCode
            noticeListViewController?.noticeDeptName = majorListEngineer[indexPath.row].majorName
        } else if indexPath.section == 4 {
            noticeListViewController?.noticeDeptCode = majorListNatural[indexPath.row].majorCode
            noticeListViewController?.noticeDeptName = majorListNatural[indexPath.row].majorName
        } else if indexPath.section == 5 {
            noticeListViewController?.noticeDeptCode = majorListBusiness[indexPath.row].majorCode
            noticeListViewController?.noticeDeptName = majorListBusiness[indexPath.row].majorName
        } else if indexPath.section == 6 {
            noticeListViewController?.noticeDeptCode = majorListEconomy[indexPath.row].majorCode
            noticeListViewController?.noticeDeptName = majorListEconomy[indexPath.row].majorName
        } else if indexPath.section == 7 {
            noticeListViewController?.noticeDeptCode = majorListSocial[indexPath.row].majorCode
            noticeListViewController?.noticeDeptName = majorListSocial[indexPath.row].majorName
        } else if indexPath.section == 8 {
            noticeListViewController?.noticeDeptCode = majorConvergence.majorCode
            noticeListViewController?.noticeDeptName = majorConvergence.majorName
        }
        noticeListViewController?.isSearchResult = false
        noticeListViewController?.isMyList = false
        
        self.navigationController?.pushViewController(noticeListViewController!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return majorListIT.count
        } else if section == 1 {
            return majorListLaw.count
        } else if section == 2 {
            return majorListInmun.count
        } else if section == 3 {
            return  majorListEngineer.count
        } else if section == 4 {
            return majorListNatural.count
        } else if section == 5 {
            return majorListBusiness.count
        } else if section == 6 {
            return majorListEconomy.count
        } else if section == 7 {
            return majorListSocial.count
        } else if section == 8 {
            return 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "majorCell", for: indexPath) as! HomeCell
        
        if indexPath.section == 0 {
            cell.majorTitle.text = majorListIT[indexPath.row].majorName.map { $0.rawValue }
            cell.majorTitleEng.text = majorListIT[indexPath.row].majorNameEng.map { $0.rawValue }
            cell.majorCode = majorListIT[indexPath.row].majorCode
        } else if indexPath.section == 1 {
            cell.majorTitle.text = majorListLaw[indexPath.row].majorName.map { $0.rawValue }
            cell.majorTitleEng.text = majorListLaw[indexPath.row].majorNameEng.map { $0.rawValue }
            cell.majorCode = majorListLaw[indexPath.row].majorCode
        } else if indexPath.section == 2 {
            cell.majorTitle.text = majorListInmun[indexPath.row].majorName.map { $0.rawValue }
            cell.majorTitleEng.text = majorListInmun[indexPath.row].majorNameEng.map { $0.rawValue }
            cell.majorCode = majorListInmun[indexPath.row].majorCode
        } else if indexPath.section == 3 {
            cell.majorTitle.text = majorListEngineer[indexPath.row].majorName.map { $0.rawValue }
            cell.majorTitleEng.text = majorListEngineer[indexPath.row].majorNameEng.map { $0.rawValue }
            cell.majorCode = majorListEngineer[indexPath.row].majorCode
        } else if indexPath.section == 4 {
            cell.majorTitle.text = majorListNatural[indexPath.row].majorName.map { $0.rawValue }
            cell.majorTitleEng.text = majorListNatural[indexPath.row].majorNameEng.map { $0.rawValue }
            cell.majorCode = majorListNatural[indexPath.row].majorCode
        } else if indexPath.section == 5 {
            cell.majorTitle.text = majorListBusiness[indexPath.row].majorName.map { $0.rawValue }
            cell.majorTitleEng.text = majorListBusiness[indexPath.row].majorNameEng.map { $0.rawValue }
            cell.majorCode = majorListBusiness[indexPath.row].majorCode
        } else if indexPath.section == 6 {
            cell.majorTitle.text = majorListEconomy[indexPath.row].majorName.map { $0.rawValue }
            cell.majorTitleEng.text = majorListEconomy[indexPath.row].majorNameEng.map { $0.rawValue }
            cell.majorCode = majorListEconomy[indexPath.row].majorCode
        } else if indexPath.section == 7 {
            cell.majorTitle.text = majorListSocial[indexPath.row].majorName.map { $0.rawValue }
            cell.majorTitleEng.text = majorListSocial[indexPath.row].majorNameEng.map { $0.rawValue }
            cell.majorCode = majorListSocial[indexPath.row].majorCode
        } else if indexPath.section == 8 {
            cell.majorTitle.text = majorConvergence.majorName.map { $0.rawValue }
            cell.majorTitleEng.text = majorConvergence.majorNameEng.map { $0.rawValue }
            cell.majorCode = majorConvergence.majorCode
        } else {
            return UITableViewCell()
        }
        
        cell.selectionStyle  = .none
        return cell
    }
}
