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
    private let tableViewController: NoticesListTableViewController
    
    private let searchButton = YDSTopBarButton(image: YDSIcon.searchLine)
    
    init(with viewModel: NoticesListViewModel) {
        self.viewModel = viewModel
        self.tableViewController = NoticesListTableViewController(with: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        bindViewModel()
        tableViewController.setInitialData()
    }
    
    private func setupViews() {
        setProperties()
        setViewHierarchy()
        setAutolayout()
    }
    
    private func setProperties() {
        self.extendedLayoutIncludesOpaqueBars = true
        searchButton.addTarget(self,
                               action: #selector(pushSearchViewController(sender:)),
                               for: .touchUpInside)
        tableViewController.progressBarDelegate = self
    }
    
    private func setViewHierarchy() {
        self.embed(tableViewController)
        self.view.addSubview(tableViewController.view)
        self.navigationItem.setRightBarButtonItems([UIBarButtonItem(customView: searchButton)],
                                                   animated: true)
    }
    
    private func setAutolayout() {
        tableViewController.view.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func bindViewModel() {
        viewModel.deptCode.bindAndFire { [weak self] value in
            guard let `self` = self else { return }

            if self.navigationController?.viewControllers.count ?? 0 > 1 {
                self.title = value.getName()
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.hideProgressBar()
    }

}

extension NoticesListViewController {
    @objc
    private func pushSearchViewController(sender: UIControl) {
        let viewController = NoticesSearchListViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}


