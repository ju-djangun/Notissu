//
//  MyMajorView.swift
//  SoongsilNotice
//
//  Copyright © 2021 Notissu. All rights reserved.
//

import UIKit
import YDS

class MyMajorView: UIView {
    
    //  MARK: - ViewModel
    private let viewModel: MorePageViewModelProtocol
    
    //  MARK: - Constant
    private enum Dimension {
        enum Margin {
            static let vertical: CGFloat = 16
            static let horizontal: CGFloat = 20
        }
        
        enum Padding {
            static let vertical: CGFloat = 20
            static let horizontal: CGFloat = 20
        }
    }

    //  MARK: - View
    private let captionLabel: YDSLabel = {
        let label = YDSLabel(style: .caption1)
        label.textColor = YDSColor.textSecondary
        label.text = "내 전공"
        return label
    }()
    
    private let titleLabel: YDSLabel = {
        let label = YDSLabel(style: .subtitle1)
        label.textColor = YDSColor.violetItemText
        return label
    }()
    
    private let deptChangeButton: YDSBoxButton = {
        let button = YDSBoxButton()
        button.size = .small
        button.text = "바꿀래요"
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return button
    }()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .fill
        return stackView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        
        stackView.layer.cornerRadius = 12
        stackView.clipsToBounds = true
        stackView.backgroundColor = YDSColor.violetItemBG
        
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: Dimension.Padding.vertical,
                                               left: Dimension.Padding.horizontal,
                                               bottom: Dimension.Padding.vertical,
                                               right: Dimension.Padding.horizontal)
        return stackView
    }()

    //  MARK: - Init
    init(with viewModel: MorePageViewModelProtocol) {
        self.viewModel = viewModel
        super.init(frame: .zero)

        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //  MARK: - Func
    private func setupViews() {
        setViewProperties()
        setViewHierarchy()
        setAutolayouts()
    }
    
    private func setViewProperties() {
        titleLabel.text = viewModel.deptCode.getName()
        
        deptChangeButton.addTarget(self,
                                   action: #selector(buttonDidTap(_:)),
                                   for: .touchUpInside)
    }
    
    private func setViewHierarchy() {
        self.addSubview(stackView)
        
        [labelStackView, deptChangeButton].forEach {
            stackView.addArrangedSubview($0)
        }
        
        [captionLabel, titleLabel].forEach {
            labelStackView.addArrangedSubview($0)
        }
    }
    
    private func setAutolayouts() {
        stackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(Dimension.Margin.vertical)
            $0.leading.trailing.equalToSuperview().inset(Dimension.Margin.horizontal)
        }
    }
}

//  MARK: - Action
extension MyMajorView {
    @objc
    private func buttonDidTap(_ sender: UIControl) {
        viewModel.deptChangeButtonDidTap()
    }
}
