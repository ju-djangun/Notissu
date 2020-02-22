//
//  NoticeListViewCell.swift
//  SoongsilNotice
//
//  Created by TaeinKim on 2019/11/05.
//  Copyright © 2019 TaeinKim. All rights reserved.
//

import UIKit

class NoticeListViewCell: UITableViewCell {

    @IBOutlet var noticeBadge: UILabel!
    @IBOutlet var noticeTitle: UILabel!
    @IBOutlet var noticeDate: UILabel!
    @IBOutlet var noticeBadgeWidthConstraint: NSLayoutConstraint!
    
    var deptName: DeptName?
    var isBookmark: Bool = false
    
    var notice  : Notice? {
        didSet {
            self.noticeTitle.text = notice?.title
            
            if isBookmark {
                self.noticeDate.text = "\(notice?.date ?? "") | \(deptName?.rawValue ?? "")"
            } else {
                self.noticeDate.text = notice?.date
            }
            
            self.noticeBadge.isHidden = !(notice?.isNotice ?? false) && !isBookmark
            
            if notice?.isNotice ?? false && !isBookmark {
                noticeBadgeWidthConstraint.constant = 36
            } else {
                noticeBadgeWidthConstraint.constant = 0
            }
        }
    }
}
