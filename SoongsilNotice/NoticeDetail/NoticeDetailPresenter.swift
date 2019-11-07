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
        let contentHTML = html.css("div[class|=smartOutput]").first?.innerHTML ?? ""
        let htmlStart = "<hml><head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, shrink-to-fit=no\"><style>html,body{padding:0 5px 5px;margin:0;font-size:18px !important;}iframe,img{max-width:100%;height:auto;}</style></head><bpdy>"
        let htmlEnd = "</bpdy></hml>"
        
        let detailHTML = "\(htmlStart)\(contentHTML)\(htmlEnd)"
        var attachmentList = [Attachment]()
        
//        html.css("span[class|=file] a")
        let attachmentHTML = html.xpath("//span[@class='file']/a")
        var attachmentNames = Array<XMLElement>()
        attachmentNames.append(contentsOf: attachmentHTML.reversed())

        for name in attachmentNames {
            let fileUrl = "http://cse.ssu.ac.kr\(name["href"] ?? "")"
            let fileName = name.content
            
            if !(name["href"] ?? "").isEmpty {
                attachmentList.append(Attachment(fileName: fileName!, fileURL: fileUrl))
            }
        }
        completion(attachmentList, detailHTML)
    }
    
    func parseElectric(html: HTMLDocument, completion: @escaping ([Attachment], String) -> Void) {
        let contentHTML = html.css("div[class^='content']").first?.innerHTML ?? ""
        
        let htmlStart = "<hml><head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, shrink-to-fit=no\"><style>html,body{padding:0 5px 5px;margin:0;font-size:18px !important;}iframe,img{max-width:100%;height:auto;}</style></head><bpdy>"
        let htmlEnd = "</bpdy></hml>"
        
        let detailHTML = "\(htmlStart)\(contentHTML)\(htmlEnd)"
        
        let attachments = html.css("div[class^='attach'] a")
        var attachmentList = [Attachment]()
        for attachment in attachments {
            let fileUrl = "http://infocom.ssu.ac.kr\(attachment["href"]!)"
            attachmentList.append(Attachment(fileName: attachment.text!, fileURL: fileUrl))
        }
        completion(attachmentList, detailHTML)
    }
    
    func downloadFile(url: String, fileName: String) {
        
    }
}
