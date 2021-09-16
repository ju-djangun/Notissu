//
//  NoticesListViewController.swift
//  SoongsilNotice
//
//  Copyright © 2021 Notissu. All rights reserved.
//

import UIKit
import YDS

class NoticesListViewController: BaseViewController {
    
    private let viewModel: NoticesListViewModel
    private let refreshControl = UIRefreshControl()
    private var didReachedBottom: Bool {
        self.tableView.contentOffset.y >
            self.tableView.contentSize.height
            - self.tableView.bounds.size.height
            - Dimension.bottomRefreshHeight
    }
    private enum Dimension {
        static let bottomRefreshHeight: CGFloat = 100
    }
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(NoticesListItemCell.self, forCellReuseIdentifier: "NoticesListItemCell")
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
   
    init(with viewModel: NoticesListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        bindViewModel()
        viewModel.loadInitialPage()
    }
    
    private func setupViews() {
        setProperties()
        setViewHierarchy()
        setAutolayout()
    }
    
    private func setProperties() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self,
                                 action: #selector(refreshData(sender:)),
                                 for: .valueChanged)
        setTitle()
    }
    
    private func setViewHierarchy() {
        self.view.addSubview(tableView)
    }
    
    private func setAutolayout() {
        tableView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func bindViewModel() {
        viewModel.noticesList.bind { [weak self] _ in
            guard let `self` = self else { return }
            self.tableView.reloadData()
        }
        
        viewModel.nowLoading.bind { [weak self] value in
            guard let `self` = self else { return }
            if self.refreshControl.isRefreshing && !value {
                //  refresh control이 refresh 중인데
                //  새로 내려온 nowLoading 값이 false인 경우에
                //  refresch control이 refresh를 중단
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    private func setTitle() {
        if self.navigationController?.viewControllers.count ?? 0 > 1 {
            self.title = viewModel.deptCode.value.getName()
        }
    }

}

extension NoticesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.noticesList.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NoticesListItemCell =
            tableView.dequeueReusableCell(withIdentifier: "NoticesListItemCell",
                                          for: indexPath) as? NoticesListItemCell
            ?? NoticesListItemCell()
        let notice = viewModel.noticesList.value[indexPath.row]
        cell.fillData(with: NoticesListItemViewModel(notice: notice))
        return cell
    }
}

extension NoticesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let viewModel = NewNoticeDetailViewModel(notice: viewModel.noticesList.value[indexPath.row],
                                                 deptCode: viewModel.deptCode.value)
        let viewController = NewNoticeDetailViewController(with: viewModel)
                                                           
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if didReachedBottom { viewModel.loadNextPage() }
    }
}

extension NoticesListViewController {
    @objc
    private func refreshData(sender: UIRefreshControl) {
        viewModel.loadInitialPage()
    }
}


