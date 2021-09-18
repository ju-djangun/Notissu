//
//  NoticesListViewController.swift
//  SoongsilNotice
//
//  Copyright © 2021 Notissu. All rights reserved.
//

import UIKit
import YDS

class NoticesListViewController: BaseNoticesListViewController {
    
    //  MARK: - View
    
    private let searchButton = YDSTopBarButton(image: YDSIcon.searchLine)
    
    
    //  MARK: - Func
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    private func setupViews() {
        setProperties()
        setViewHierarchy()
        loadInitialPage()
    }
    
    private func setProperties() {
        searchButton.addTarget(self,
                               action: #selector(pushSearchViewController(sender:)),
                               for: .touchUpInside)
    }
    
    private func setViewHierarchy() {
        self.navigationItem.setRightBarButtonItems([UIBarButtonItem(customView: searchButton)],
                                                   animated: true)
    }
}

//  MARK: - Action
extension NoticesListViewController {
    @objc
    private func pushSearchViewController(sender: UIControl) {
        let viewController = NoticesSearchListViewController(with: NoticesListViewModel(deptCode: viewModel.deptCode.value))
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}


