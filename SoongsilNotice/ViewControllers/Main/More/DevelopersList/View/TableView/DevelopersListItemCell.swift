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
        contentView.addSubview(stackView)
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
        titleLabel.text = model.name
        captionLabel.text = "@\(model.login)"
        
        loadProfileImage(from: model.avatarURL)
    }
    
    private func loadProfileImage(from url: String?) {
        if let url = url {
            ImageFetchManager.shared.loadImage(from: url) { [weak self] result in
                guard let `self` = self else { return }
                switch result {
                case .success(let data):
                    self.profileImageView.image = UIImage(data: data)
                case .failure(_):
                    YDSToast.makeToast(text: "네트워크 오류가 발생했습니다.")
                }
            }
        }
    }
}
