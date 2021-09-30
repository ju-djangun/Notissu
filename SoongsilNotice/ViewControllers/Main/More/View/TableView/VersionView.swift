//
//  VersionView.swift
//  Notissu
//
//  Copyright © 2021 Notissu. All rights reserved.
//

import UIKit
import YDS

class VersionView: UIView {
    
    private enum Dimension {
        enum Padding {
            static let horizontal: CGFloat = 48
        }
    }

    private let viewModel: MorePageViewModelProtocol
    
    private let label: YDSLabel = {
        let label = YDSLabel(style: .caption1)
        label.textColor = YDSColor.textTertiary
        return label
    }()
    
    init(with viewModel: MorePageViewModelProtocol) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        label.text = viewModel.isRecentVersion
            ? "최신 버전을 사용하고 있습니다."
            : "업데이트가 필요합니다."
        
        addSubview(label)
        label.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(Dimension.Padding.horizontal)
            $0.centerX.equalToSuperview()
        }
    }
    
}
