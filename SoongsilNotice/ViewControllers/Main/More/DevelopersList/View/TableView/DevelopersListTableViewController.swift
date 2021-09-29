//
//  DevelopersListTableViewController.swift
//  Notissu
//
//  Copyright © 2021 Notissu. All rights reserved.
//

import UIKit
import YDS

class DevelopersListTableViewController: YDSTableViewController {
    
    //  MARK: - ViewModel
    private var viewModel: DevelopersListViewModelProtocol
    
    //  MARK: - Delegate
    var progressBarDelegate: ProgressBarDelegate?
    
    //  MARK: - Init
    init(with viewModel: DevelopersListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //  MARK: - Func
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setupViews()
        loadDevelopersList()
    }
    
    private func bindViewModel() {
        viewModel.developersList.bind { [weak self] value in
            guard let `self` = self else { return }
            self.tableView.reloadData()
            self.progressBarDelegate?.hideProgressBar()
        }
        
        viewModel.error.bind {
            YDSToast.makeToast(text: $0)
            self.progressBarDelegate?.hideProgressBar()
        }
    }
    
    private func setupViews() {
        setViewProperties()
    }
    
    private func setViewProperties() {
        tableView.register(DevelopersListItemCell.self,
                           forCellReuseIdentifier: DevelopersListItemCell.identifier)
    }

    private func loadDevelopersList() {
        progressBarDelegate?.showProgressBar()
        viewModel.loadDevelopersList()
    }
}

//  MARK: - Data Source
extension DevelopersListTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.developersList.value.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DevelopersListItemCell =
            tableView.dequeueReusableCell(withIdentifier: DevelopersListItemCell.identifier,
                                          for: indexPath)
        as? DevelopersListItemCell
        ?? DevelopersListItemCell()
        
        let developer = viewModel.developersList.value[indexPath.row]
        cell.fillData(with: developer)
        return cell
    }
}

//  MARK: - Delegate
extension DevelopersListTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.itemDidTap(at: indexPath)
    }
}
