//
//  NoticeDetailContract.swift
//  SoongsilNotice
//
//  Created by TaeinKim on 2019/11/06.
//  Copyright © 2019 TaeinKim. All rights reserved.
//

import Foundation
import UIKit
import Kanna

struct Attachment {
    var fileName: String
    var fileURL: String
}

// View
protocol NoticeDetailView {
    func showWebViewPage(attachments: [Attachment], html: String)
}

// Presenter
protocol NoticeDetail {
    // Attachment : 첨부파일, String : 내용이 담긴 HTML
    func parseComputer(html: HTMLDocument, completion: @escaping ([Attachment], String) -> Void)
    
    func parseElectric(html: HTMLDocument, completion: @escaping ([Attachment], String) -> Void)
}
