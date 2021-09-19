//
//  NoticeDetailAttachemtnsListItemCell.swift
//  Notissu
//
//  Copyright © 2021 Notissu. All rights reserved.
//

import UIKit
import YDS

class NoticeDetailAttachemtnsListItemCell: YDSTableViewCell {
    
    //  MARK: - View
    private let iconView: YDSIconView = {
        let iconView = YDSIconView()
        iconView.size = .large
        return iconView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = YDSFont.subtitle3
        label.lineBreakMode = .byTruncatingMiddle
        label.textColor = YDSColor.textSecondary
        return label
    }()
    
    //  MARK: - Constant
    private enum Dimension {
        enum Margin {
            static let leading: CGFloat = 8
            static let trailing: CGFloat = 20
        }
        
        static let spacing: CGFloat = 0
        static let height: CGFloat = 48
    }
    
    //  MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //  MARK: - Func
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
            $0.leading.equalToSuperview().inset(Dimension.Margin.leading)
            $0.centerY.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(iconView.snp.trailing).offset(Dimension.spacing)
            $0.trailing.equalToSuperview().inset(Dimension.Margin.trailing)
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
