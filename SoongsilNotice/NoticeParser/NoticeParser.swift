//
//  NoticeParser.swift
//  Notissu
//
//  Copyright © 2021 Notissu. All rights reserved.
//

import Foundation
import Kanna

final class NoticeParser {
    public static let shared: NoticeParser = NoticeParser()
    
    private init() { }
    
    public func parseNoticeList(type: DeptCode, page: Int, keyword: String?, completion: @escaping ([Notice]) -> Void) {
        type.parseList(page: page, keyword: keyword, completion: completion)
    }
    
    public func parseNoticeDetail(html: HTMLDocument, type: DeptCode, completion: @escaping ([Attachment], String) -> Void) {
        
    }
}
