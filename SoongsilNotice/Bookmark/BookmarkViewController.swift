//
//  BookmarkViewController.swift
//  SoongsilNotice
//
//  Created by TaeinKim on 2020/02/18.
//  Copyright © 2020 TaeinKim. All rights reserved.
//

import UIKit

class BookmarkViewController: UIViewController, BookmarkViewProtocol {
    
    private var presenter: BookmarkPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter = BookmarkPresenter(view: self)
        self.presenter.fetchBookmarkNotice()
    }
    
    private func initVC() {
        self.navigationItem.title = "북마크"
    }
    
    func applyListToTableView(list: [FavoriteNotice]) {
        
    }
    
}
