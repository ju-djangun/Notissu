//
//  MajorListViewController.swift
//  Notissu
//
//  Copyright © 2021 Notissu. All rights reserved.
//

import Foundation
import SnapKit
import UIKit
import YDS

final class MajorListViewController: BaseViewController {
    private let tableView: UITableView = {
        $0.tableFooterView = UIView()
        return $0
    }(UITableView())
    
    let viewModel: MajorListViewModel
    
    init(viewModel: MajorListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = MajorListViewModel()
        super.init(coder: coder)
//        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewLayout()
        bindViewModel()
        setNavigationTitleLabelFont()
    }
    
    private func bindViewModel() {
        viewModel.majorSectionList.bind { _ in
            self.tableView.reloadData()
        }
    }
    
    private func setupViewLayout() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MajorListSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: MajorListSectionHeaderView.identifier)
        tableView.register(MajorListCell.self, forCellReuseIdentifier: MajorListCell.identifier)
    }
}

extension MajorListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.majorSectionList.value.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MajorSection(rawValue: section)?.getMajorList().count ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: MajorListSectionHeaderView.identifier) as? MajorListSectionHeaderView {
            headerView.titleContent = MajorSection(rawValue: section)?.getSectionTitle() ?? ""
            return headerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let majorList = MajorSection(rawValue: indexPath.section)?.getMajorList(), let cell = tableView.dequeueReusableCell(withIdentifier: MajorListCell.identifier) as? MajorListCell {
            cell.major = majorList[indexPath.row]
            cell.separatorInset = .zero
            cell.selectionStyle = .none
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let deptCode = MajorSection(rawValue: indexPath.section)?
                                .getMajorList()[indexPath.row]
                                .majorCode
        else { return }
        
        let viewModel = NoticesListViewModel(deptCode: deptCode)
        let viewController = NoticesListViewController(with: viewModel)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
