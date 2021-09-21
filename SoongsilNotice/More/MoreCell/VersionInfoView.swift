//
//  VersionInfoCell.swift
//  Notissu
//
//  Copyright © 2020 Notissu. All rights reserved.
//

import Foundation
import UIKit
import YDS

struct Version {
    let currentVersion: String
    let recentVersion: String
    let isUpdateRequired: Bool
}

class VersionInfoView: UIView {
    @IBOutlet var lblCurrentVersion: UILabel!
    @IBOutlet var lblRecentVersion : UILabel!
    @IBOutlet var lblStateMessage  : UILabel!
    @IBOutlet var updateBtn: UIButton!
    
    @IBAction func onClickUpdate(_ sender: Any) {
        if let url = URL(string: "itms-apps://itunes.apple.com/app/id1488050194"),
            UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    var version: Version? {
        didSet {
            self.applyVersionToView()
        }
    }
    
    class func viewFromNib() -> Self {
        guard let view = Bundle.main.loadNibNamed(String(describing: Self.self), owner: nil, options: nil)?[0] as? Self else {
            fatalError("\(String(describing: Self.self)) viewFromNib fail")
        }
        return view
    }
    
    private func applyVersionToView() {
        if let ver = self.version {
            updateBtn.layer.borderColor = YDSColor.buttonPoint.cgColor
            updateBtn.layer.borderWidth = 1
            
            updateBtn.layer.masksToBounds = true
            updateBtn.layer.cornerRadius = 6
            
            lblCurrentVersion.text = "현재 버전 : \(ver.currentVersion)"
            lblRecentVersion.text = "최신 버전 : \(ver.recentVersion)"
            lblRecentVersion.textColor = YDSColor.textPointed
            
            updateBtn.isHidden = !ver.isUpdateRequired
            
            if ver.isUpdateRequired {
                lblStateMessage.text = "업데이트가 필요합니다."
                lblStateMessage.textColor = UIColor(named: "notissuRed1000s")
            } else {
                lblStateMessage.text = "최신 버전을 사용중입니다."
                lblStateMessage.textColor = UIColor(named: "notissuGray500s")
            }
        }
    }
}
