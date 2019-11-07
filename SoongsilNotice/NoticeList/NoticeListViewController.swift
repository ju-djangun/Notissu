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
    private var refreshControl      = UIRefreshControl()
    private var presenter  : NoticeListPresenter?
    private var noticeList = [Notice]()
    private var noticeDeptCode: DeptCode?
    private var noticeDeptName: DeptName?
    private var page : Int = 1
    
    
    override func viewDidLoad() {
        self.presenter = NoticeListPresenter(view: self)
        
        self.noticeListView.delegate = self
        self.noticeListView.dataSource = self
        self.noticeListView.reloadData()
        
        self.noticeDeptCode = DeptCode.IT_Software
        self.noticeDeptName = DeptName.IT_Software
        
        self.navigationItem.title = self.noticeDeptName!.rawValue
        ConfigSetting.canFetchData = true
        
        self.page = 1
        self.presenter?.loadNoticeList(page: page, deptCode: noticeDeptCode!)
        
        if #available(iOS 10.0, *) {
            noticeListView.refreshControl = refreshControl
        } else { noticeListView.addSubview(refreshControl) }
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    @objc func refresh() {
        self.page = 1
        ConfigSetting.canFetchData = true
        self.noticeList.removeAll()
        self.presenter?.loadNoticeList(page: page, deptCode: noticeDeptCode!)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected")
        let storyBoard = self.storyboard!
        let noticeDetailController = storyBoard.instantiateViewController(withIdentifier: "noticeDetailVC") as? NoticeDetailViewController
        
        noticeDetailController?.detailURL = noticeList[indexPath.row].url
        noticeDetailController?.departmentCode = self.noticeDeptCode
        noticeDetailController?.noticeTitle = self.noticeList[indexPath.row].title
        noticeDetailController?.noticeDay = self.noticeList[indexPath.row].date
        self.navigationController?.pushViewController(noticeDetailController!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.noticeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noticeListCell", for: indexPath) as! NoticeListViewCell
        
        if noticeList.count > 0 {
            cell.noticeTitle.text = noticeList[indexPath.row].title
            cell.noticeDate.text = noticeList[indexPath.row].date
        }
        cell.selectionStyle  = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if self.noticeList.count - indexPath.row == 10 && ConfigSetting.canFetchData {
            // LOAD MORE
            self.page += 1
            self.presenter?.loadNoticeList(page: page, deptCode: self.noticeDeptCode!)
        }
    }
    
    func applyToTableView(list: [Notice]) {
        self.refreshControl.endRefreshing()
        self.noticeList.append(contentsOf: list)
        self.noticeListView.reloadData()
    }
}
