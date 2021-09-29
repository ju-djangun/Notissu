//
//  YDSTableViewController.swift
//  Notissu
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
        tableView.separatorColor = YDSColor.borderNormal
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableHeaderView = UIView()
        tableView.backgroundColor = .clear
    }
    
    override open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.separatorInset.left = cell.bounds.size.width
        }
    }
}

