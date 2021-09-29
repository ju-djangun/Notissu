//
//  DevelopersListItemCell.swift
//  SoongsilNotice
//
//  Created by Gyuni on 2021/09/29.
//  Copyright © 2021 Notissu. All rights reserved.
//

import UIKit
import YDS

class DevelopersListItemCell: YDSTableViewCell {
    
    //  MARK: - Identifier
    static let identifier = "DevelopersListItemCell"
    
    //  MARK: - Constant
    private enum Dimension {
        enum Padding {
            static let vertical: CGFloat = 16
            static let horizontal: CGFloat = 20
        }
    }
    
    //  MARK: - View
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center
        
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: Dimension.Padding.vertical,
                                               left: Dimension.Padding.horizontal,
                                               bottom: Dimension.Padding.vertical,
                                               right: Dimension.Padding.horizontal)
        return stackView
    }()
    
    private let profileImageView: YDSProfileImageView = {
        let imageView = YDSProfileImageView()
        imageView.size = .medium
        return imageView
    }()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .fill
        return stackView
    }()
    
    private let titleLabel: YDSLabel = {
        let label = YDSLabel(style: .subtitle2)
        label.textColor = YDSColor.textPrimary
        return label
    }()
    
    private let captionLabel: YDSLabel = {
        let label = YDSLabel(style: .caption1)
        label.textColor = YDSColor.textSecondary
        return label
    }()
    
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
        setAutolayout()
    }
    
    private func setViewHierarchy() {
        self.contentView.addSubview(stackView)
        [profileImageView, labelStackView].forEach {
            stackView.addArrangedSubview($0)
        }
        [titleLabel, captionLabel].forEach {
            labelStackView.addArrangedSubview($0)
        }
    }
    
    private func setAutolayout() {
        stackView.snp.makeConstraints {
            $0.top.leading.bottom.trailing.equalToSuperview()
        }
    }
}

//  MARK: - INPUT
extension DevelopersListItemCell {
    func fillData(with model: Developer) {
        self.titleLabel.text = model.name
        self.captionLabel.text = model.login
    }
}
