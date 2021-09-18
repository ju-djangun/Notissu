//
//  NoticesListItemCell.swift
//  SoongsilNotice
//
//  Copyright © 2021 Notissu. All rights reserved.
//

import UIKit
import YDS

class NoticesListItemCell: UITableViewCell {
    
    private var viewModel: NoticesListItemViewModel?
    
    //  MARK: - Constant
    
    private enum Dimension {
        enum Margin {
            static let vertical: CGFloat = 6
            static let horizontal: CGFloat = 16
        }
        
        enum Padding {
            static let vertical: CGFloat = 16
            static let horizontal: CGFloat = 20
        }
    }
    
    
    //  MARK: - View
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 6
        
        stackView.backgroundColor = YDSColor.monoItemBG
        stackView.layer.cornerRadius = 12
        stackView.clipsToBounds = true
        
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: Dimension.Padding.vertical,
                                               left: Dimension.Padding.horizontal,
                                               bottom: Dimension.Padding.vertical,
                                               right: Dimension.Padding.horizontal)
        return stackView
    }()
    
    private let titleLabel: YDSLabel = {
        let label = YDSLabel(style: .subtitle2)
        label.textColor = YDSColor.textPrimary
        label.numberOfLines = 0
        return label
    }()
    
    private let captionLabel: YDSLabel = {
        let label = YDSLabel(style: .caption1)
        label.textColor = YDSColor.textTertiary
        return label
    }()
    
    private let tagStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 4
        return stackView
    }()
    
    private let tagIconView: YDSIconView = {
        let iconView = YDSIconView()
        iconView.size = .extraSmall
        iconView.image = YDSIcon.noticeFilled.withRenderingMode(.alwaysTemplate)
        iconView.tintColor = YDSColor.violetItemText
        return iconView
    }()
    
    private let tagCaptionLabel: YDSLabel = {
        let label = YDSLabel(style: .caption1)
        label.text = "공지"
        label.textColor = YDSColor.violetItemText
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
        setViewProperties()
        setViewHierarchy()
        setAutolayout()
    }
    
    private func setViewProperties() {
        self.selectionStyle = .none
    }
    
    private func setViewHierarchy() {
        self.contentView.addSubview(stackView)
        [tagStackView, titleLabel, captionLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        [tagIconView, tagCaptionLabel].forEach {
            tagStackView.addArrangedSubview($0)
        }
    }
    
    private func setAutolayout() {
        stackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(Dimension.Margin.vertical)
            $0.leading.trailing.equalToSuperview().inset(Dimension.Margin.horizontal)
        }
    }
    
    
    //  MARK: - Input
    func fillData(with viewModel: NoticesListItemViewModel) {
        self.viewModel = viewModel
        
        titleLabel.text = viewModel.title
        captionLabel.text = viewModel.caption
        
        tagStackView.isHidden = !viewModel.isNotice
        stackView.backgroundColor = viewModel.isNotice
            ? YDSColor.violetItemBG
            : YDSColor.monoItemBG
    }
}

