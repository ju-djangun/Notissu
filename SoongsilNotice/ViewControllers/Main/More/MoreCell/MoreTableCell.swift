//
//  MoreTableCell.swift
//  Notissu
//
//  Copyright © 2019 Notissu. All rights reserved.
//

import Foundation
import UIKit

class MoreTableCell : UITableViewCell {
    static let identifier: String = "MoreTableCell"
    private let contentLabel: UILabel = UILabel()
    
    public var content: String? {
        didSet {
            contentLabel.text = content
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCellLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCellLayout() {
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-10)
        }
        
        contentLabel.font = UIFont(name: "NotoSansKR-Regular", size: 14)
    }
}
