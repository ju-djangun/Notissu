//
//  MorePageItemListTableViewController.swift
//  Notissu
//
//  Copyright © 2021 Notissu. All rights reserved.
//

import UIKit

class MorePageItemsListTableViewController: YDSTableViewController {
    
    //  MARK: - Property
    private var viewModel: MorePageViewModelProtocol
    
    //  MARK: - Constant
    private enum Dimension {
        enum Margin {
            static let vertical: CGFloat = 8
        }
    }
    
    //  MARK: - Init
    init(with viewModel: MorePageViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //  MARK: - Func
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        setViewProperties()
    }
    
    private func setViewProperties() {
        tableView.register(YDSSingleLineTableViewCell.self, forCellReuseIdentifier: "YDSSingleLineTableViewCell")
        tableView.contentInset = UIEdgeInsets(top: Dimension.Margin.vertical,
                                              left: 0,
                                              bottom: Dimension.Margin.vertical,
                                              right: 0)
    }
    
}

//  MARK: - DataSource
extension MorePageItemsListTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: YDSSingleLineTableViewCell = tableView.dequeueReusableCell(withIdentifier: "YDSSingleLineTableViewCell",
                                                                             for: indexPath)
        as? YDSSingleLineTableViewCell ?? YDSSingleLineTableViewCell()
        
        cell.fillData(title: viewModel.items[indexPath.row].title)
        return cell
    }
}

//  MARK: - Delegate
extension MorePageItemsListTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.itemDidTap(at: indexPath)
    }
}

//  MARK: - Header, Footer View Height Setting
extension MorePageItemsListTableViewController {
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if let header = tableView.tableHeaderView {
            let newSize = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            header.frame.size.height = newSize.height
        }
        
        if let footer = tableView.tableFooterView {
            let newSize = footer.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            footer.frame.size.height = newSize.height
        }
    }
}
