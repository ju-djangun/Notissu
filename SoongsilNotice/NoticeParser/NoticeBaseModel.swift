//
//  NoticeBaseModel.swift
//  Notissu
//
//  Copyright © 2021 Notissu. All rights reserved.
//

import Foundation

class NoticeBaseModel {
    static var noticeList = [Notice]()
    static var authorList = [String]()
    static var titleList  = [String]()
    static var pageStringList = [String]()
    static var dateStringList = [String]()
    static var isNoticeList = [Bool]()
    static var urlList    = [String]()
    static var attachmentCheckList = [Bool]()
    
    static func cleanList() {
        noticeList.removeAll()
        authorList.removeAll()
        titleList.removeAll()
        pageStringList.removeAll()
        dateStringList.removeAll()
        isNoticeList.removeAll()
        urlList.removeAll()
        attachmentCheckList.removeAll()
    }
}
