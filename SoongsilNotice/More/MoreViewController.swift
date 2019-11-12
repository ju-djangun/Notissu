//
//  MoreViewController.swift
//  SoongsilNotice
//
//  Created by TaeinKim on 2019/11/11.
//  Copyright © 2019 TaeinKim. All rights reserved.
//

import UIKit

class MoreViewController : BaseViewController {
    @IBOutlet var mailButton: UIButton!
    
    @IBAction func onClickMailButton(_ sender: Any?) {
        let email = "della.kimko@gmail.com"
        if let url = URL(string: "mailto:\(email)") {
            UIApplication.shared.open(url)
        }
    }
    
    override func viewDidLoad() {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "더보기"
    }
}
