//
//  MajorListViewController.swift
//  SoongsilNotice
//
//  Created by denny on 2021/07/11.
//  Copyright © 2021 Notissu. All rights reserved.
//

import Foundation
import SnapKit
import UIKit

final class MajorListViewController: BaseViewController {
    let viewModel: MajorListViewModel
    
    init(viewModel: MajorListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
