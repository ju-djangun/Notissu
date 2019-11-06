//
//  NoticeDetailPresenter.swift
//  SoongsilNotice
//
//  Created by TaeinKim on 2019/11/06.
//  Copyright © 2019 TaeinKim. All rights reserved.
//

import Foundation
import Kanna

class NoticeDetailPresenter: NoticeDetail {
    private var view: NoticeDetailView?
    
    init(view: NoticeDetailView) {
        self.view = view
    }
    
    func parseComputer(html: HTMLDocument, completion: @escaping ([Attachment], String) -> Void) {
        let detailHTML = html.css("div[class|=smartOutput]").first?.innerHTML ?? ""
        completion([Attachment](), detailHTML)
    }
    
    func parseElectric(html: HTMLDocument, completion: @escaping ([Attachment], String) -> Void) {
        let detailHTML = html.css("div[class^='content']").first?.innerHTML ?? ""
        //let attachments = doc.css("div[class^='attach']")
        completion([Attachment](), detailHTML)
    }
}
