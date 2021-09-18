//
//  NoticesSearchListViewController.swift
//  SoongsilNotice
//
//  Copyright © 2021 Notissu. All rights reserved.
//

import UIKit
import YDS

class NoticesSearchListViewController: BaseNoticesListViewController {
    
    private let searchBar: YDSSearchBar = {
        let searchBar = YDSSearchBar()
        searchBar.placeholder = "검색어를 입력해주세요"
        return searchBar
    }()

    override init(with viewModel: NoticesListViewModel) {
        super.init(with: viewModel)
        self.hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        setViewProperty()
    }
    
    private func setViewProperty() {
        self.navigationItem.titleView = searchBar
        
        searchBar.becomeFirstResponder()
        searchBar.delegate = self
    }

}

extension NoticesSearchListViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.endEditing(true)
    }
}

extension NoticesSearchListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let keyword = searchBar.text {
            viewModel.keyword = keyword
            tableViewController.setInitialData()
        }
        searchBar.endEditing(true)
    }
}
