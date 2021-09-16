//
//  YDSTableViewCell.swift
//  SoongsilNotice
//
//  Copyright © 2021 Notissu. All rights reserved.
//

import UIKit
import YDS

class YDSTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
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
