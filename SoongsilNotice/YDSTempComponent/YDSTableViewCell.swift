//
//  YDSTableViewCell.swift
//  Notissu
//
//  Copyright © 2021 Notissu. All rights reserved.
//

//  YDS에 편입시킬 컴포넌트입니다.

import UIKit
import YDS

open class YDSTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        setViewProperties()
    }
    
    private func setViewProperties() {
        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = YDSColor.bgSelected
    }

}
