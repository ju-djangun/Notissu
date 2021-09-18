//
//  NoticeSearchViewController.swift
//  Notissu
//
//  Copyright © 2021 Notissu. All rights reserved.
//

import Foundation
import SnapKit
import UIKit

final class NoticeSearchViewController: BaseViewController {
    private let containerView: UIView = {
        $0.backgroundColor = UIColor(named: "notissuBlue1000s")
        return $0
    }(UIView())
    
    private let searchBtn: UIButton = {
        $0.backgroundColor = .white
        return $0
    }(UIButton())
    
    private let contentStackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 4
        $0.distribution = .fillEqually
        return $0
    }(UIStackView())
    
    private let majorSelectBtn: UIButton = {
        return $0
    }(UIButton())
    
    private let keywordTextField: UITextField = {
        return $0
    }(UITextField())
    
    private let resultTableView: UITableView = {
        return $0
    }(UITableView())
    
    let viewModel: NoticeSearchViewModel
    
    init(viewModel: NoticeSearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewLayout()
        bindViewModel()
        setNavigationTitleLabelFont()
    }
    
    private func bindViewModel() {
        
    }
    
    private func setupViewLayout() {
        view.addSubview(containerView)
        containerView.addSubview(searchBtn)
        containerView.addSubview(contentStackView)
        contentStackView.addArrangedSubview(majorSelectBtn)
        contentStackView.addArrangedSubview(keywordTextField)
        
        containerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        searchBtn.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().offset(4)
            make.bottom.equalToSuperview().offset(-4)
            make.width.equalTo(60)
        }
        
        contentStackView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(4)
            make.bottom.equalToSuperview().offset(-4)
            make.trailing.equalTo(searchBtn.snp.leading).offset(-4)
        }
        
        [majorSelectBtn, keywordTextField].forEach {
            $0.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()
            }
        }
    }
}
