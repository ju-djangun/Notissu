//
//  NoticesListTableViewController.swift
//  SoongsilNotice
//
//  Created by Gyuni on 2021/09/17.
//  Copyright © 2021 Notissu. All rights reserved.
//

import UIKit
import YDS

class NoticesListTableViewController: YDSTableViewController {
    
    private var viewModel: NoticesListViewModel
    
    private let warningView: WarningView = {
        let view = WarningView()
        view.text = "결과를 찾을 수 없습니다."
        view.isHidden = true
        return view
    }()
    
    private var didInitialLoad: Bool = false
    
    private var didReachedBottom: Bool {
        self.tableView.contentOffset.y >
            self.tableView.contentSize.height
            - self.tableView.bounds.size.height
            - Dimension.bottomRefreshHeight
    }
    
    private enum Dimension {
        static let bottomRefreshHeight: CGFloat = 100
    }
    
    var progressBarDelegate: ProgressBarDelegate?
    
    func setInitialData() {
        viewModel.loadInitialPage()
        progressBarDelegate?.showProgressBar()
        didInitialLoad = true
    }

    init(with viewModel: NoticesListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setupViews()
    }
    
    private func bindViewModel() {
        viewModel.noticesList.bind { [weak self] value in
            guard let `self` = self else { return }
            self.tableView.reloadData()
            
            self.warningView.isHidden = ((value.count != 0) || !self.didInitialLoad)
        }
        
        viewModel.nowLoading.bind { [weak self] value in
            guard let `self` = self else { return }
            if self.refreshControl?.isRefreshing ?? false && !value {
                //  refresh control이 refresh 중인데
                //  새로 내려온 nowLoading 값이 false인 경우에
                //  refresch control이 refresh를 중단
                self.refreshControl?.endRefreshing()
            }
            self.progressBarDelegate?.hideProgressBar()
        }
    }
    
    private func setupViews() {
        setViewProperties()
        setViewHierarchy()
        setAutolayouts()
    }
    
    private func setViewProperties() {
        tableView.register(NoticesListItemCell.self, forCellReuseIdentifier: "NoticesListItemCell")
        tableView.separatorStyle = .none
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self,
                                 action: #selector(refreshData(sender:)),
                                 for: .valueChanged)
    }
    
    
    private func setViewHierarchy() {
        self.view.addSubview(warningView)
    }
    
    private func setAutolayouts() {
        warningView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

}

//  MARK: - Data Source
extension NoticesListTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.noticesList.value.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NoticesListItemCell =
            tableView.dequeueReusableCell(withIdentifier: "NoticesListItemCell",
                                          for: indexPath) as? NoticesListItemCell
            ?? NoticesListItemCell()
        let notice = viewModel.noticesList.value[indexPath.row]
        cell.fillData(with: NoticesListItemViewModel(notice: notice))
        return cell
    }
}

//  MARK: - Delegate
extension NoticesListTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let viewModel = NewNoticeDetailViewModel(notice: viewModel.noticesList.value[indexPath.row],
                                                 deptCode: viewModel.deptCode.value)
        let viewController = NewNoticeDetailViewController(with: viewModel)
                                                           
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if didReachedBottom { viewModel.loadNextPage() }
    }
}

//  MARK: - Action
extension NoticesListTableViewController {
    @objc
    private func refreshData(sender: UIRefreshControl) {
        viewModel.loadInitialPage()
    }
}
