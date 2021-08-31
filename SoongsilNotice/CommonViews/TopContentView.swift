//
//  TopContentView.swift
//  SoongsilNotice
//
//  Copyright © 2021 Notissu. All rights reserved.
//

import Foundation
import SnapKit
import UIKit

final class TopContentView: UIView {
    private let titleLabel: UILabel = {
        $0.font = UIFont(name: "NotoSansKR-Bold", size: 24)
        return $0
    }(UILabel())
    
    var titleContent: String = "" {
        didSet {
            titleLabel.text = titleContent
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViewLayout() {
        backgroundColor = .white
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }
    }
}
