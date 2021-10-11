//
//  Notice.swift
//  Notissu
//
//  Copyright © 2019 Notissu. All rights reserved.
//

import Foundation

class Notice: Codable, Equatable {
    var author        : String?
    var title         : String?
    var url           : String?
    var date          : String?
    var writingUID    : String?
    var isNotice      : Bool?
    var hasAttachment : Bool?
    
    init(author: String, title: String, url: String, date: String, isNotice: Bool) {
        self.author        = author
        self.title         = title
        self.url           = url
        self.date          = date
        self.isNotice      = isNotice
        self.hasAttachment = false
    }
    
    init(author: String, title: String, url: String, date: String, isNotice: Bool, writingUID: String) {
        self.author        = author
        self.title         = title
        self.url           = url
        self.date          = date
        self.isNotice      = isNotice
        self.hasAttachment = false
        self.writingUID    = writingUID
    }
    
    init(author: String, title: String, url: String, date: String, isNotice: Bool, hasAttachment: Bool) {
        self.author        = author
        self.title         = title
        self.url           = url
        self.date          = date
        self.isNotice      = isNotice
        self.hasAttachment = hasAttachment
    }
    
    static func == (lhs: Notice, rhs: Notice) -> Bool {
        if lhs.author == rhs.author && lhs.title == rhs.title && lhs.url == rhs.url && lhs.date == rhs.date && lhs.isNotice == rhs.isNotice && lhs.hasAttachment == rhs.hasAttachment {
            return true
        }
        return false
    }
}
