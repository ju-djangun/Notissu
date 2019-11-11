//
//  MoreViewController.swift
//  SoongsilNotice
//
//  Created by TaeinKim on 2019/11/11.
//  Copyright © 2019 TaeinKim. All rights reserved.
//

import UIKit

class MoreViewController : BaseViewController {
    override func viewDidLoad() {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "더보기"
    }
}
