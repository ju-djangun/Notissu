//
//  BaseNoticesListViewController.swift
//  SoongsilNotice
//
//  Created by Gyuni on 2021/09/18.
//  Copyright © 2021 Notissu. All rights reserved.
//

import UIKit
import YDS

class BaseNoticesListViewController: BaseViewController {
    
    let viewModel: NoticesListViewModel
    let tableViewController: NoticesListTableViewController
    
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
    }
    
    private func setupViews() {
        setProperties()
        setViewHierarchy()
        setAutolayout()
    }
    
    private func setProperties() {
        tableViewController.progressBarDelegate = self
    }
    
    private func setViewHierarchy() {
        self.embed(tableViewController)
        self.view.addSubview(tableViewController.view)
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
