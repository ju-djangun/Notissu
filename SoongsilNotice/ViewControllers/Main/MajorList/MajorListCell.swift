//
//  MajorListCell.swift
//  SoongsilNotice
//
//  Copyright © 2021 Notissu. All rights reserved.
//

import Foundation
import SnapKit
import UIKit

final class MajorListCell: UITableViewCell {
    static let identifier: String = "MajorListCell"
    private let titleLabel: UILabel = {
        $0.font = UIFont(name: "NotoSansKR-Medium", size: 20)
        $0.textColor = .black
        return $0
    }(UILabel())
    
    private let subTitleLabel: UILabel = {
        $0.font = UIFont(name: "Poppins-Regular", size: 12)
        $0.textColor = .gray
        return $0
    }(UILabel())
    
    var major: Major? {
        didSet {
            titleLabel.text = major?.majorName.map { $0.rawValue }
            subTitleLabel.text = major?.majorNameEng.map { $0.rawValue }
            
            majorCode = major?.majorCode
            majorName = major?.majorName
        }
    }
    
    private var majorCode: DeptCode?
    private var majorName: DeptName?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCellLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCellLayout() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
}
