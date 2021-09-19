//
//  NoticesViewController.swift
//  Notissu
//
//  Copyright © 2021 Notissu. All rights reserved.
//

import Foundation
import SnapKit
import UIKit
import YDS

final class NoticesViewController: BaseViewController {
    private let noticeListView: UITableView = {
        return $0
    }(UITableView())
    
    private let viewModel: NoticesViewModel
    
    init(viewModel: NoticesViewModel) {
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
    }
    
    private func bindViewModel() {
        viewModel.deptCode.bindAndFire { [weak self] deptCode in
//            guard let `self` = self else { return }
//            if let navigationController = self.navigationController as? YDSNavigationController {
//                navigationController.title = deptCode.getName()
//            }
        }
        
        viewModel.noticeList.bind { [weak self] _ in
            guard let `self` = self else { return }
            self.noticeListView.reloadData()
        }
    }
    
    private func setupViewLayout() {
        view.addSubview(noticeListView)
        noticeListView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

extension NoticesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.noticeList.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
