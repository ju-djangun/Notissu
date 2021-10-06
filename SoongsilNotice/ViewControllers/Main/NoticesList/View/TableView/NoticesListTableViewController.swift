//
//  NoticesListTableViewController.swift
//  Notissu
//
//  Copyright © 2021 Notissu. All rights reserved.
//

import UIKit
import YDS

class NoticesListTableViewController: YDSTableViewController {
    
    private var viewModel: NoticesListViewModelProtocol
    
    //  MARK: - View
    private let warningView = ErrorView(text: "결과를 찾을 수 없습니다.")
    
    //  MARK: - Constant
    private enum Dimension {
        static let bottomRefreshHeight: CGFloat = 100
    }
    
    //  MARK: - Property
    private var didReachedBottom: Bool {
        self.tableView.contentOffset.y >
            self.tableView.contentSize.height
            - self.tableView.bounds.size.height
            - Dimension.bottomRefreshHeight
    }
    
    weak var progressBarDelegate: ProgressBarDelegate?
    
    //  MARK: - Init
    init(with viewModel: NoticesListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //  MARK: - Func
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setupViews()
    }
    
    private func bindViewModel() {
        viewModel.noticesList.bind { [weak self] value in
            guard let `self` = self else { return }
            self.tableView.reloadData()
        }
        
        viewModel.nowLoading.bind { [weak self] value in
            guard let `self` = self else { return }
            if !value {
                self.progressBarDelegate?.hideProgressBar()
                self.refreshControl?.endRefreshing()
            }
        }
        
        viewModel.shouldShowErrorMessage.bindAndFire { [weak self] value in
            guard let `self` = self else { return }
            self.warningView.isHidden = !value
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
        
        let viewModel = NoticeDetailViewModel(notice: viewModel.noticesList.value[indexPath.row],
                                                 deptCode: viewModel.deptCode.value)
        let viewController = NoticeDetailViewController(with: viewModel)
                                                           
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
