//
//  NoticeDetailContract.swift
//  Notissu
//
//  Copyright © 2019 Notissu. All rights reserved.
//

import Foundation
import UIKit
import Kanna

// View
protocol NoticeDetailView {
    func showWebViewPage(attachments: [Attachment], html: String)
}

// Presenter
protocol NoticeDetail {
    // Attachment : 첨부파일, String : 내용이 담긴 HTML
    func isNoticeFavorite(title: String, date: String, major: DeptCode) -> Bool
    
    func setFavorite(notice: Notice, majorCode: DeptCode, favorite: Bool)
}
