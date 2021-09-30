//
//  YDSSingleLineTableViewCell.swift
//  Notissu
//
//  Copyright © 2021 Notissu. All rights reserved.
//

import UIKit
import YDS

final class YDSSingleLineTableViewCell: YDSTableViewCell {
    
    //  MARK: - Constant
    private enum Dimension {
        enum Padding {
            static let vertical: CGFloat = 16
            static let horizontal: CGFloat = 20
        }
        
        static let spacing: CGFloat = 8
    }
    
    //  MARK: - View
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Dimension.spacing
        stackView.alignment = .center
        
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: Dimension.Padding.vertical,
                                               left: Dimension.Padding.horizontal,
                                               bottom: Dimension.Padding.vertical,
                                               right: Dimension.Padding.horizontal)
        return stackView
    }()
    
    private let titleLabel: YDSLabel = {
        let label = YDSLabel(style: .body1)
        label.textColor = YDSColor.textSecondary
        return label
    }()
    
    private let iconView: YDSIconView = {
        let iconView = YDSIconView()
        iconView.size = .small
        iconView.image = YDSIcon.arrowRightLine.withRenderingMode(.alwaysTemplate)
        iconView.tintColor = YDSColor.textSecondary
        iconView.setContentHuggingPriority(.defaultHigh,
                                           for: .horizontal)
        return iconView
    }()
    
    //  MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //  MARK: - Func
    private func setupViews() {
        setViewHierarchy()
        setAutolayouts()
    }
    
    private func setViewHierarchy() {
        contentView.addSubview(stackView)
        [titleLabel, iconView].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    private func setAutolayouts() {
        stackView.snp.makeConstraints {
            $0.top.leading.bottom.trailing.equalToSuperview()
        }
    }

}

//  MARK: - Input
extension YDSSingleLineTableViewCell {
    func fillData(title: String?) {
        self.titleLabel.text = title
    }
}
