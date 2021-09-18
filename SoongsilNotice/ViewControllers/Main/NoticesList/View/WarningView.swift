//
//  WarningView.swift
//  SoongsilNotice
//
//  Created by Gyuni on 2021/09/18.
//  Copyright © 2021 Notissu. All rights reserved.
//

import UIKit
import YDS

class WarningView: UIView {
    
    var text: String? {
        get { return label.text }
        set {
            label.text = newValue
            label.isHidden = (newValue == nil)
        }
    }
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center
        return stackView
    }()
    
    private let warningIconView: UIImageView = {
        let imageView = UIImageView()
        let configuration = UIImage.SymbolConfiguration(pointSize: 48, weight: .ultraLight)
        imageView.image = UIImage(systemName: "exclamationmark.triangle",
                                  withConfiguration: configuration)
        return imageView
    }()
    
    private let label = YDSLabel(style: .body1)
    
    override var tintColor: UIColor! {
        didSet { label.textColor = tintColor }
    }

    init(keyword: String? = nil) {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.addSubview(stackView)
        
        [warningIconView, label].forEach {
            stackView.addArrangedSubview($0)
        }
        
        stackView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        
        self.tintColor = YDSColor.textTertiary
    }
    
}
