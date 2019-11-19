//
//  SchoolViewController.swift
//  SoongsilNotice
//
//  Created by TaeinKim on 2019/11/19.
//  Copyright © 2019 TaeinKim. All rights reserved.
//

import UIKit

class SchoolViewController: BaseViewController, SchoolView {
    private var presenter: SchoolPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad School Notice")
        self.presenter = SchoolPresenter(view: self)
        self.presenter!.parseSchoolNotice(page: 1, keyword: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "학교 공지"
    }
    
    func applyTableView(list: [Notice]) -> Void {
        
    }
}
