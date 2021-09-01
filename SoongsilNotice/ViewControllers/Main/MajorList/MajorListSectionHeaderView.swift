//
//  MajorListSectionHeaderView.swift
//  Notissu
//
//  Copyright © 2021 Notissu. All rights reserved.
//

import Foundation
import SnapKit
import UIKit

final class MajorListSectionHeaderView: UITableViewHeaderFooterView {
    static let identifier: String = "MajorListSectionHeaderView"
    private let titleLabel: UILabel = {
        $0.font = UIFont(name: "NotoSansKR-Regular", size: 12)
        $0.textColor = .gray
        return $0
    }(UILabel())
    
    var titleContent: String = "" {
        didSet {
            titleLabel.text = titleContent
        }
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViewLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViewLayout() {
        contentView.backgroundColor = .white
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-4)
        }
    }
}
