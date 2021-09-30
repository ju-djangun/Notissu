//
//  MorePageViewController.swift
//  Notissu
//
//  Copyright © 2019 Notissu. All rights reserved.
//

import SafariServices
import UIKit
import YDS

class MorePageViewController : BaseViewController {
    
    //  MARK: - ViewModel
    private let viewModel: MorePageViewModelProtocol
    
    //  MARK: - View
    private let myMajorView: MyMajorView
    private let versionView: VersionView
    
    //  MARK: - ViewController
    private let itemsListTableViewController: MorePageItemsListTableViewController
    
    //  MARK: - Init
    init(with viewModel: MorePageViewModelProtocol) {
        self.viewModel = viewModel
        self.itemsListTableViewController = MorePageItemsListTableViewController(with: viewModel)
        self.myMajorView = MyMajorView(with: viewModel)
        self.versionView = VersionView(with: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //  MARK: - Func
    override func viewDidLoad() {
        setupViewLayout()
        bindViewModel()
        setNavigationTitleLabelFont()
    }
    
    private func setupViewLayout() {
        self.embed(itemsListTableViewController)
        
        view.addSubview(itemsListTableViewController.view)
        itemsListTableViewController.tableView.tableHeaderView = myMajorView
        itemsListTableViewController.tableView.tableFooterView = versionView
        itemsListTableViewController.view.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
        
    }
    
    private func bindViewModel() {
        viewModel.pushViewController.bind { [weak self] viewController in
            guard let `self` = self else { return }
            if let viewController = viewController {
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
    
}

//  MARK: - Header, Footer View Height Setting
extension MorePageViewController {
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let tableView = itemsListTableViewController.tableView
        
        if let header = tableView?.tableHeaderView {
            let newSize = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            header.frame.size.height = newSize.height
        }
        
        if let footer = tableView?.tableFooterView {
            let newSize = footer.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            footer.frame.size.height = newSize.height
        }
    }
}
