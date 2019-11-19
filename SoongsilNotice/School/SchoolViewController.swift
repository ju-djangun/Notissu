//
//  SchoolViewController.swift
//  SoongsilNotice
//
//  Created by TaeinKim on 2019/11/19.
//  Copyright © 2019 TaeinKim. All rights reserved.
//

import UIKit

class SchoolViewController: BaseViewController, SchoolView {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "학교 공지"
    }

}
