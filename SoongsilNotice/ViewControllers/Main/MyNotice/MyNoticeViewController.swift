//
//  MyNoticeViewController.swift
//  SoongsilNotice
//
//  Created by denny on 2021/07/11.
//  Copyright © 2021 Notissu. All rights reserved.
//

import Foundation
import SnapKit
import UIKit

final class MyNoticeViewController: BaseViewController {
    let viewModel: MyNoticeViewModel
    
    init(viewModel: MyNoticeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        viewModel.fetchNoticeList()
    }
    
    private func bindViewModel() {
        viewModel.noticeList.bind({ list in
            
        })
    }
}
