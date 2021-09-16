//
//  NoticeDetailAttachemtnsListItemCell.swift
//  SoongsilNotice
//
//  Copyright © 2021 Notissu. All rights reserved.
//

import UIKit
import YDS

class NoticeDetailAttachemtnsListItemCell: YDSTableViewCell {
    
    private let iconView: YDSIconView = {
        let iconView = YDSIconView()
        iconView.size = .medium
        return iconView
    }()
    
    private let nameLabel: YDSLabel = {
        let label = YDSLabel(style: .body2)
        label.textColor = YDSColor.textSecondary
        return label
    }()
    
    private enum Dimension {
        enum Margin {
            static let horizontal: CGFloat = 20
        }
        
        static let spacing: CGFloat = 8
        static let height: CGFloat = 48
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        setViewHierarchy()
        setAutolayouts()
    }
    
    private func setViewHierarchy() {
        [iconView, nameLabel].forEach {
            self.contentView.addSubview($0)
        }
    }
    
    private func setAutolayouts() {
        iconView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(Dimension.Margin.horizontal)
            $0.centerY.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(iconView.snp.trailing).offset(Dimension.spacing)
            $0.trailing.equalToSuperview().inset(Dimension.Margin.horizontal)
            $0.centerY.equalToSuperview()
        }
    }
    
}

//  MARK: - INPUT
extension NoticeDetailAttachemtnsListItemCell {
    func fillData(with model: Attachment) {
        self.iconView.image = model.fileName.fileTypeIconImage
        self.nameLabel.text = model.fileName
    }
}
