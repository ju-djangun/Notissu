//
//  BookmarkViewController.swift
//  SoongsilNotice
//
//  Created by denny on 2021/10/11.
//  Copyright © 2021 Notissu. All rights reserved.
//

import Foundation
import SnapKit
import UIKit
import YDS

final class BookmarkViewController: YDSTableViewController {
    private let viewModel: BookmarkViewModel
    
    init(viewModel: BookmarkViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewLayout()
        bindViewModel()
        viewModel.fetchBookmarkNotice()
    }
    
    private func bindViewModel() {
        viewModel.bookmarkList.bind { _ in
            self.tableView.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    private func setupViewLayout() {
        title = "북마크"
        view.backgroundColor = YDSColor.bgNormal
        tableView.register(NoticesListItemCell.self, forCellReuseIdentifier: "NoticesListItemCell")
        tableView.separatorStyle = .none
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self,
                                 action: #selector(refreshData(sender:)),
                                 for: .valueChanged)
    }
}

extension BookmarkViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let viewModel = NoticeDetailViewModel(notice: viewModel.bookmarkList.value[indexPath.row].notice,
                                                 deptCode: viewModel.bookmarkList.value[indexPath.row].deptCode)
        let viewController = NoticeDetailViewController(with: viewModel)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.bookmarkList.value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NoticesListItemCell =
            tableView.dequeueReusableCell(withIdentifier: "NoticesListItemCell",
                                          for: indexPath) as? NoticesListItemCell
            ?? NoticesListItemCell()
        let notice = viewModel.bookmarkList.value[indexPath.row].notice
        cell.fillData(with: NoticesListItemViewModel(notice: notice))
        return cell
    }
}

extension BookmarkViewController {
    @objc
    private func refreshData(sender: UIRefreshControl) {
        viewModel.fetchBookmarkNotice()
    }
}
