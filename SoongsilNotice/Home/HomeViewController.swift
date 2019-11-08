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
    
    var sections = ["IT 대학", "법과대학", "인문대학"]
    
    var majorListIT = [Major]()
    var majorListLaw = [Major]()
    var majorListInmun = [Major]()
    
    @IBOutlet var majorListView: UITableView!
    
    override func viewDidLoad() {
        
        //        case IT_Computer = "컴퓨터학부"
        //        case IT_Media = "글로벌미디어학부"
        //        case IT_Electric = "전자정보공학부"
        //        case IT_Software = "소프트웨어학부"
        //        case IT_SmartSystem = "스마트시스템소프트웨어학과"
        
        for index in 0..<majorCodeListIT.count {
            majorListIT.append(Major(majorCode: majorCodeListIT[index], majorName: majorNameListIT[index], majorNameEng: majorEngNameListIT[index]))
        }
        
        for index in 0..<majorCodeListLaw.count {
            majorListLaw.append(Major(majorCode: majorCodeListLaw[index], majorName: majorNameListLaw[index], majorNameEng: majorEngNameListLaw[index]))
        }
        
        for index in 0..<majorCodeListInmun.count {
            majorListInmun.append(Major(majorCode: majorCodeListInmun[index], majorName: majorNameListInmun[index], majorNameEng: majorEngNameListInmun[index]))
        }
        
        self.majorListView.delegate = self
        self.majorListView.dataSource = self
        self.majorListView.rowHeight = UITableView.automaticDimension
        self.majorListView.separatorStyle = .singleLine
//        self.majorListView.separatorInset = .zero
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
        }
        self.navigationController?.pushViewController(noticeListViewController!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return majorListIT.count
        } else if section == 1 {
            return majorListLaw.count
        } else if section == 2 {
            return majorListInmun.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "majorCell", for: indexPath) as! HomeCell
        
//        print("cellForRowAt - section - \(indexPath.section)")
        
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
        } else {
            return UITableViewCell()
        }
        
        cell.selectionStyle  = .none
        
        return cell
    }
}
