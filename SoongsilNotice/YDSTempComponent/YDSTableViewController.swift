//
//  YDSTableViewController.swift
//  SoongsilNotice
//
//  Copyright © 2021 Notissu. All rights reserved.
//

//  YDS에 편입시킬 컴포넌트입니다.

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
        self.tableView.rowHeight = UITableView.automaticDimension
    }
}
