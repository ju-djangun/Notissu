//
//  SchoolViewController.swift
//  SoongsilNotice
//
//  Created by TaeinKim on 2019/11/19.
//  Copyright © 2019 TaeinKim. All rights reserved.
//

import UIKit

class SchoolViewController: BaseViewController, SchoolView, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var noticeListView: UITableView!
    var spinnerFooter = UIActivityIndicatorView(style: .gray)
    
    private var presenter: SchoolPresenter!
    private var noticeList = [Notice]()
    private var refreshControl      = UIRefreshControl()
    private var page : Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 10.0, *) {
            self.noticeListView.refreshControl = refreshControl
        } else { noticeListView.addSubview(refreshControl) }
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onLoadFromWidget),
                                               name: NSNotification.Name("widget"),
                                               object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.topItem?.title = "SSU:Catch"
        self.presenter = SchoolPresenter(view: self)
        self.noticeListView.delegate = self
        self.noticeListView.dataSource = self
        self.noticeListView.tableFooterView = UIView()
        self.noticeListView.reloadData()
        self.refresh()
        
        self.checkURLScheme()
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
    
    func applyTableView(list: [Notice]) -> Void {
        self.refreshControl.endRefreshing()
        
        self.spinnerFooter.stopAnimating()
        self.noticeListView.tableFooterView?.isHidden = true
        
        self.hideProgressBar()
        self.noticeList.append(contentsOf: list)
        self.noticeListView.reloadData()
    }
    
    @objc func refresh() {
        self.page = 1
        
        if !self.refreshControl.isRefreshing {
            self.showProgressBar()
        }
        
        ConfigSetting.canFetchData = true
        self.noticeList.removeAll()
        self.presenter.parseSchoolNotice(page: 1, keyword: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = self.storyboard!
        let noticeDetailController = storyBoard.instantiateViewController(withIdentifier: "noticeDetailVC") as? NoticeDetailViewController
        
        noticeDetailController?.noticeItem = noticeList[indexPath.row]
        noticeDetailController?.detailURL = noticeList[indexPath.row].url
        noticeDetailController?.departmentCode = DeptCode.Soongsil
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
            if noticeList[indexPath.row].isNotice ?? false {
                //                cell.noticeTitle.textColor = UIColor(named: "launch_bg")
                cell.noticeBadgeWidthConstraint.constant = 36
            } else {
                //                cell.noticeTitle.textColor = UIColor.black
                cell.noticeBadgeWidthConstraint.constant = 0
            }
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
            self.presenter.parseSchoolNotice(page: page, keyword: nil)
        }
    }
}
