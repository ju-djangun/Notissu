//
//  WidgetNoticeView.swift
//  Notissu Today Extension
//
//  Created by TaeinKim on 2020/02/09.
//  Copyright © 2020 TaeinKim. All rights reserved.
//

import UIKit

class WidgetNoticeView: UIView {
    
    @IBOutlet weak var noticeTagLbl: UILabel!
    @IBOutlet weak var noticeTitleLbl: UILabel!
    @IBOutlet weak var noticeDateLbl: UILabel!
    @IBOutlet var noticeTagWidth: NSLayoutConstraint!
    
    var noticeItem: Notice? {
        didSet {
            self.setNoticeItem()
        }
    }
    
    private func setNoticeItem() {
        if let item = noticeItem {
            self.noticeTitleLbl.text = item.title
            self.noticeDateLbl.text = item.date
            self.noticeTagWidth.constant = (item.isNotice ?? false) ? 32 : 0
        }
    }
    
    class func viewFromNib() -> Self {
        
        guard let view = Bundle.main.loadNibNamed(String(describing: Self.self), owner: nil, options: nil)?[0] as? Self else {
            
            fatalError("\(String(describing: Self.self)) viewFromNib fail")
            
        }
        
        return view
        
    }
    
}
