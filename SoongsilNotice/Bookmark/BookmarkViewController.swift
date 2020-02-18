//
//  BookmarkViewController.swift
//  SoongsilNotice
//
//  Created by TaeinKim on 2020/02/18.
//  Copyright © 2020 TaeinKim. All rights reserved.
//

import UIKit

class BookmarkViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, BookmarkViewProtocol {
    
    private var presenter: BookmarkPresenterProtocol!
    @IBOutlet var noticeListView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter = BookmarkPresenter(view: self)
        self.initVC()
        
        self.presenter.fetchBookmarkNotice()
    }
    
    private func initVC() {
        self.navigationItem.title = "북마크"
        
        self.noticeListView.delegate = self
        self.noticeListView.dataSource = self
        self.noticeListView.tableFooterView = UIView()
        self.noticeListView.reloadData()
    }
    
    func applyListToTableView(list: [FavoriteNotice]) {
        self.noticeListView.reloadData()
    }
    
}

extension BookmarkViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = self.storyboard!
        let noticeDetailController = storyBoard.instantiateViewController(withIdentifier: "noticeDetailVC") as? NoticeDetailViewController
        let bookmark = self.presenter.getBookmark(at: indexPath.row)
        
        noticeDetailController?.noticeItem     = bookmark.notice
        noticeDetailController?.detailURL      = bookmark.notice.url
        noticeDetailController?.departmentCode = bookmark.deptCode
        noticeDetailController?.noticeTitle    = bookmark.notice.title
        noticeDetailController?.noticeDay      = bookmark.notice.date
        
        self.navigationController?.pushViewController(noticeDetailController!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter.getBookmarkCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noticeListCell", for: indexPath) as! NoticeListViewCell
        
        if self.presenter.getBookmarkCount() > 0 {
            let bookmark = self.presenter.getBookmark(at: indexPath.row)
            cell.noticeTitle.text = bookmark.notice.title
            cell.noticeDate.text = bookmark.notice.date
            if bookmark.notice.isNotice ?? false {
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
        // Do Nothing
    }
}
