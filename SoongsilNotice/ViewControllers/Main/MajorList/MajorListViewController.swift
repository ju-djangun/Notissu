//
//  MajorListViewController.swift
//  Notissu
//
//  Copyright © 2021 Notissu. All rights reserved.
//

import Foundation
import SnapKit
import UIKit

final class MajorListViewController: BaseViewController {
    private let topContentView: TopContentView = {
        $0.titleContent = "전공 목록"
        return $0
    }(TopContentView())
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.topItem?.title = "전공 목록"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewLayout()
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.majorSectionList.bind { _ in
            self.tableView.reloadData()
        }
    }
    
    private func setupViewLayout() {
        view.addSubview(topContentView)
        view.addSubview(tableView)
        
        topContentView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(56)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(topContentView.snp.bottom)
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
        let storyBoard = UIStoryboard(name: "Main", bundle: .main)
        
        if let noticeListViewController = storyBoard.instantiateViewController(withIdentifier: "noticeListVC") as? NoticeListViewController {
            
            noticeListViewController.department = MajorSection(rawValue: indexPath.section)?.getMajorList()[indexPath.row]
            noticeListViewController.isSearchResult = false
            noticeListViewController.listType = .normalList
//            noticeListViewController.modalPresentationStyle = .fullScreen
            
//            self.present(noticeListViewController, animated: true, completion: nil)
            self.navigationController?.pushViewController(noticeListViewController, animated: true)
        }
    }
}
