//
//  YDSTableViewController.swift
//  SoongsilNotice
//
//  Created by Gyuni on 2021/09/16.
//  Copyright © 2021 Notissu. All rights reserved.
//

import UIKit
import YDS

open class YDSTableViewController: UITableViewController {
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func viewDidLoad() {
        self.tableView.separatorColor = YDSColor.borderNormal
    }
}
