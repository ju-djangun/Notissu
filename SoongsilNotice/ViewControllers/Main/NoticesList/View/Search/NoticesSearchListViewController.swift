//
//  NoticesSearchListViewController.swift
//  SoongsilNotice
//
//  Created by Gyuni on 2021/09/17.
//  Copyright © 2021 Notissu. All rights reserved.
//

import UIKit
import YDS

class NoticesSearchListViewController: BaseViewController {

    let searchBar: YDSSearchBar = {
        let searchBar = YDSSearchBar()
        searchBar.placeholder = "검색어를 입력해주세요"
        return searchBar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        setViewProperty()
    }
    
    private func setViewProperty() {
        self.extendedLayoutIncludesOpaqueBars = true
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
        print(searchBar.text)
    }
}
