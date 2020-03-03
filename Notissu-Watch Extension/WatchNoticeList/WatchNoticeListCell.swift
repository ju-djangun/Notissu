//
//  WatchNoticeListCell.swift
//  Notissu-Watch Extension
//
//  Created by TaeinKim on 2020/03/03.
//  Copyright © 2020 TaeinKim. All rights reserved.
//

import Foundation
import WatchKit

class WatchNoticeListCell: NSObject {
    @IBOutlet weak var lblTitle: WKInterfaceLabel!
    @IBOutlet weak var lblDate: WKInterfaceLabel!
    
    var item: Notice? {
        didSet {
            self.setTitleLabel()
            self.setDateLabel()
        }
    }
    
    private func setTitleLabel() {
        self.lblTitle.setText(item?.title)
    }
    
    private func setDateLabel() {
        self.lblDate.setText(item?.date)
    }
}

