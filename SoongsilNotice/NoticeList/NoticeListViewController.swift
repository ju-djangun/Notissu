//
//  NoticeListViewControllerr.swift
//  SoongsilNotice
//
//  Created by TaeinKim on 2019/11/05.
//  Copyright © 2019 TaeinKim. All rights reserved.
//

import UIKit
import Lottie
import NotificationCenter

enum ListType: Int {
    case myList
    case normalList
    case favoriteList
}

class NoticeListViewController: BaseViewController, NoticeListView, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var noticeListView: UITableView!
    private var refreshControl      = UIRefreshControl()
    private var presenter  : NoticeListPresenter?
    private var noticeList = [Notice]()
    
    var spinnerFooter = UIActivityIndicatorView(style: .gray)
    var listType: ListType = .myList
    var searchKeyword: String?
    var isSearchResult = false
    var department     = BaseViewController.noticeMajor {
        didSet {
            self.noticeDeptCode = self.department?.majorCode
            self.noticeDeptName = self.department?.majorName
        }
    }
    var noticeDeptCode = BaseViewController.noticeDeptCode
    var noticeDeptName = BaseViewController.noticeDeptName
    
    private var page : Int = 1
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if listType == .myList {
            self.department     = BaseViewController.noticeMajor
            self.noticeDeptCode = BaseViewController.noticeDeptCode
            self.noticeDeptName = BaseViewController.noticeDeptName
        }
        
        self.navigationItem.title = self.noticeDeptName?.rawValue
        
        if listType == .myList {
            self.navigationController?.navigationBar.topItem?.title = self.noticeDeptName?.rawValue
        } else if listType == .normalList {
            if self.noticeDeptCode != BaseViewController.noticeDeptCode && self.searchKeyword == nil {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onClickAddMajor))
            }
        }
        
        self.presenter = NoticeListPresenter(view: self)
        self.noticeListView.delegate = self
        self.noticeListView.dataSource = self
        self.noticeListView.tableFooterView = UIView()
        self.noticeListView.reloadData()
        
        self.checkURLScheme()
        self.checkUpdate()
        self.refresh()
    }
    
    @objc func onLoadFromWidget() {
        self.checkURLScheme()
    }
    
    private func checkURLScheme() {
        if let index = NotissuProperty.openIndex {
            print("change to Tab \(index)...")
            if index != self.tabBarController?.selectedIndex {
                self.tabBarController?.selectedIndex = index
            }
        }
    }
    
    @objc func onClickAddMajor(sender: UIBarButtonItem) {
        self.showAlert(title: "메인 전공 등록", msg: "메인 전공으로 등록하면 첫 화면에 해당 전공 공지사항이 나옵니다.", handler: self.doRegisterFavorite(_:))
    }
    
    func doRegisterFavorite(_ action: UIAlertAction) {
        // 메인 전공 등록
        BaseViewController.noticeDeptCode = self.noticeDeptCode
        BaseViewController.noticeDeptName = self.noticeDeptName
        BaseViewController.noticeMajor    = self.department
        
        UserDefaults(suiteName: "group.com.elliott.Notissu")?.set(BaseViewController.noticeDeptCode!.rawValue, forKey: "myDeptCode")
        UserDefaults(suiteName: "group.com.elliott.Notissu")?.set(BaseViewController.noticeDeptName!.rawValue, forKey: "myDeptName")
        UserDefaults.standard.setValue(BaseViewController.noticeDeptCode!.rawValue, forKey: "myDeptCode")
        UserDefaults.standard.setValue(BaseViewController.noticeDeptName!.rawValue, forKey: "myDeptName")
        
        self.navigationItem.rightBarButtonItem = nil
        self.showAlertOK(title: "메인 전공으로 등록되었습니다")
    }
    
    override func viewDidLoad() {
        self.noticeListView.delegate = self
        self.noticeListView.dataSource = self
        self.noticeListView.tableFooterView = UIView()
        self.noticeListView.separatorInset = .zero
        self.noticeListView.reloadData()
        
        if #available(iOS 10.0, *) {
            noticeListView.refreshControl = refreshControl
        } else { noticeListView.addSubview(refreshControl) }
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onLoadFromWidget),
                                               name: NSNotification.Name("widget"),
                                               object: nil)
        
        if self.isUpdateAvailable() {
            print("New Version Update")
            self.showAlertOKWithHandler(title: "업데이트가 필요합니다.", msg: "원활한 서비스 이용을 위해 업데이트가 필요합니다. '확인'을 누르면 스토어로 이동합니다.", handler: onClickUpdateApp(_:))
        }
    }
    
    @objc func refresh() {
        self.page = 1
        
        if !self.refreshControl.isRefreshing {
            self.showProgressBar()
        }
        
        ConfigSetting.canFetchData = true
        self.noticeList.removeAll()
        self.presenter?.loadNoticeList(page: page, keyword: searchKeyword, deptCode: noticeDeptCode!)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = self.storyboard!
        let noticeDetailController = storyBoard.instantiateViewController(withIdentifier: "noticeDetailVC") as? NoticeDetailViewController
        
        noticeDetailController?.department = self.department
        noticeDetailController?.noticeItem = noticeList[indexPath.row]
        self.navigationController?.pushViewController(noticeDetailController!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.noticeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noticeListCell", for: indexPath) as! NoticeListViewCell
        if noticeList.count > 0 {
            cell.notice = noticeList[indexPath.row]
            cell.deptName = noticeDeptName
        }
        cell.selectionStyle  = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if self.noticeList.count - indexPath.row == 5 && ConfigSetting.canFetchData {
            // LOAD MORE
            self.spinnerFooter.startAnimating()
            self.spinnerFooter.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
            
            self.noticeListView.tableFooterView = spinnerFooter
            self.noticeListView.tableFooterView?.isHidden = false
            
            self.page += 1
            self.presenter?.loadNoticeList(page: page, keyword: searchKeyword, deptCode: self.noticeDeptCode!)
        }
    }
    
    func applyToTableView(list: [Notice]) {
        self.refreshControl.endRefreshing()
        
        self.spinnerFooter.stopAnimating()
        self.noticeListView.tableFooterView?.isHidden = true
        
        self.hideProgressBar()
        self.noticeList.append(contentsOf: list)
        self.noticeListView.reloadData()
    }
}
