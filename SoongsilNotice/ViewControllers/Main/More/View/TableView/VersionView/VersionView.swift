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

    private let viewModel: VersionViewModel
    
    private let label: YDSLabel = {
        let label = YDSLabel(style: .caption1)
        label.textColor = YDSColor.textTertiary
        return label
    }()
    
    init(with viewModel: VersionViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        label.text = viewModel.text
        
        addSubview(label)
        label.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(Dimension.Padding.horizontal)
            $0.centerX.equalToSuperview()
        }
    }
    
}
