//
//  NoticesListItemViewModel.swift
//  Notissu
//
//  Copyright © 2021 Notissu. All rights reserved.
//

import Foundation

struct NoticesListItemViewModel {
    let title: String?
    let caption: String?
    let url: String?
    let isNotice: Bool
    
    init(notice: Notice) {
        self.title = notice.title
        self.caption = notice.date
        self.url = notice.url
        self.isNotice = notice.isNotice ?? false
    }
}
