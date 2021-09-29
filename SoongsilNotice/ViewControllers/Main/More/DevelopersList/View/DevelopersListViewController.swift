//
//  DevelopersListViewController.swift
//  SoongsilNotice
//
//  Created by Gyuni on 2021/09/29.
//  Copyright © 2021 Notissu. All rights reserved.
//

import UIKit
import YDS

class DevelopersListViewController: BaseViewController {

    //  MARK: - ViewModel
    private let viewModel: DevelopersListViewModelProtocol
    
    //  MARK: - ViewController
    let tableViewController: DevelopersListTableViewController
    
    //  MARK: - Init
    init(with viewModel: DevelopersListViewModelProtocol) {
        self.viewModel = viewModel
        self.tableViewController = DevelopersListTableViewController(with: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //  MARK: - Func
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
        title = viewModel.title
        tableViewController.progressBarDelegate = self
    }
    
    private func setViewHierarchy() {
        embed(tableViewController)
        view.addSubview(tableViewController.view)
    }
    
    private func setAutolayout() {
        tableViewController.view.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func bindViewModel() {
        viewModel.tappedDeveloper.bind { [weak self] in
            guard let `self` = self, let developer = $0 else { return }
            let bottomSheetViewController = YDSBottomSheet()
            bottomSheetViewController.addViews(views: [DeveloperDetailView(with: developer)])
            self.presentPanModal(bottomSheetViewController)
        }
    }

}
