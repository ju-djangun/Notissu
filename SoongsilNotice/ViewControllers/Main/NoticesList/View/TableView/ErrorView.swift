//
//  ErorrView.swift
//  SoongsilNotice
//
//  Copyright © 2021 Notissu. All rights reserved.
//

import UIKit
import YDS

class ErrorView: UIView {
    
    //  MARK: - Property
    
    var text: String? {
        get { return label.text }
        set {
            label.text = newValue
            label.isHidden = (newValue == nil)
        }
    }
    
    override var tintColor: UIColor! {
        didSet { label.textColor = tintColor }
    }
    
    
    //  MARK: - View
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .center
        return stackView
    }()
    
    private let warningIconView: YDSIconView = {
        let iconView = YDSIconView()
        let configuration = UIImage.SymbolConfiguration(weight: .ultraLight)
        iconView.image = UIImage(systemName: "exclamationmark.triangle",
                                  withConfiguration: configuration)
        iconView.size = .large
        return iconView
    }()
    
    private let label = YDSLabel(style: .body1)

    
    //  MARK: - Init
    
    init(text: String? = nil) {
        super.init(frame: .zero)
        self.text = text
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    //  MARK: - Func
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
