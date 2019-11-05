//
//  NoticeListViewControllerr.swift
//  SoongsilNotice
//
//  Created by TaeinKim on 2019/11/05.
//  Copyright © 2019 TaeinKim. All rights reserved.
//

import UIKit

class NoticeListViewController: UIViewController, NoticeListView, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var noticeListView: UITableView!
    private var presenter  : NoticeListPresenter?
    private var noticeList = [Notice]()
    private var noticeDeptCode: DeptCode?
    private var page : Int = 1
    
    
    override func viewDidLoad() {
        self.presenter = NoticeListPresenter(view: self)
        
        self.noticeListView.delegate = self
        self.noticeListView.dataSource = self
        self.noticeListView.reloadData()
        self.noticeDeptCode = DeptCode.IT_Computer
        ConfigSetting.canFetchData = true
        
        self.page = 1
        self.presenter?.loadNoticeList(page: page, deptCode: noticeDeptCode!)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.noticeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noticeListCell", for: indexPath) as! NoticeListViewCell
        cell.noticeTitle.text = noticeList[indexPath.row].title
        cell.noticeDate.text = noticeList[indexPath.row].date
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if self.noticeList.count - indexPath.row == 3 && ConfigSetting.canFetchData {
            // LOAD MORE
            self.page += 1
            self.presenter?.loadNoticeList(page: page, deptCode: self.noticeDeptCode!)
        }
    }
    
    func applyToTableView(list: [Notice]) {
        self.noticeList.append(contentsOf: list)
        self.noticeListView.reloadData()
    }
}
