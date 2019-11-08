//
//  NoticeDetailPresenter.swift
//  SoongsilNotice
//
//  Created by TaeinKim on 2019/11/06.
//  Copyright © 2019 TaeinKim. All rights reserved.
//

import Foundation
import Kanna
import JavaScriptCore

class NoticeDetailPresenter: NoticeDetail {
    private var view: NoticeDetailView?
    
    let htmlStart = "<hml><head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, shrink-to-fit=no\"><style>html,body{padding:0 5px 5px;margin:0;font-size:18px !important;}iframe,img{max-width:100%;height:auto;}</style></head><bpdy>"
    let htmlEnd = "</bpdy></hml>"
    
    init(view: NoticeDetailView) {
        self.view = view
    }
    
    func parseComputer(html: HTMLDocument, completion: @escaping ([Attachment], String) -> Void) {
        let contentHTML = html.css("div[class|=smartOutput]").first?.innerHTML ?? ""
        
        let detailHTML = "\(htmlStart)\(contentHTML)\(htmlEnd)"
        var attachmentList = [Attachment]()
        
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
        
        let detailHTML = "\(htmlStart)\(contentHTML)\(htmlEnd)"
        
        let attachments = html.css("div[class^='attach'] a")
        var attachmentList = [Attachment]()
        for attachment in attachments {
            let fileUrl = "http://infocom.ssu.ac.kr\(attachment["href"]!)"
            attachmentList.append(Attachment(fileName: attachment.text!, fileURL: fileUrl))
        }
        completion(attachmentList, detailHTML)
    }
    
    func parseSoftware(html: HTMLDocument, completion: @escaping ([Attachment], String) -> Void) { 
        let contentHTML = html.css("div[class^='bo_view_2']").first?.innerHTML ?? ""
        //        let downloadUrl = "https://sw.ssu.ac.kr/bbs/download.php?bo_table=sub6_1&wr_id=1023&no=1"
        let detailHTML = "\(htmlStart)\(contentHTML)\(htmlEnd)"
        var attachmentList = [Attachment]()
        
        var index = 0
        for link in html.css("div[class^='bo_view_1'] a") {
            let url = link["href"]?.getArrayAfterRegex(regex: "[=](.*?)[&]")[1] ?? ""
            let wr_id = url.replacingOccurrences(of: "&", with: "").replacingOccurrences(of: "=", with: "")
            
            let realUrl = "https://sw.ssu.ac.kr/bbs/download.php?bo_table=sub6_1&wr_id=\(wr_id)&no=\(index)"
            attachmentList.append(Attachment(fileName: link.content ?? "", fileURL: realUrl))
            index += 1
        }
        
        completion(attachmentList, detailHTML)
    }
    
    func parseMedia(html: HTMLDocument, completion: @escaping ([Attachment], String) -> Void) {
        let contentHTML = html.css("td[class^='s_default_view_body_2']").first?.innerHTML ?? ""
        let detailHTML = "\(htmlStart)\(contentHTML)\(htmlEnd)"
        let mediaUrl = "http://media.ssu.ac.kr/"
        var attachmentList = [Attachment]()
        
        for link in html.css("td[width^=480] a") {
            let url = "\(mediaUrl)\(link["href"] ?? "")"
            print("media : \(url)")
            attachmentList.append(Attachment(fileName: link.text ?? "", fileURL: url))
        }
        
        completion(attachmentList, detailHTML)
    }
    
    func parseLaw(html: HTMLDocument, completion: @escaping ([Attachment], String) -> Void) {
        let contentHTML = html.css("div[class^='frame-box']").first?.innerHTML ?? ""
        let detailHTML = "\(htmlStart)\(contentHTML)\(htmlEnd)"
        var attachmentList = [Attachment]()
        
        for link in html.css("table[class='bbs-view'] a") {
            //            print(link["href"])
            //            print(link.content)
            attachmentList.append(Attachment(fileName: link.content ?? "", fileURL: link["href"] ?? ""))
        }
        
        completion(attachmentList, detailHTML)
    }
    
    func parseIntlLaw(html: HTMLDocument, completion: @escaping ([Attachment], String) -> Void) {
        let contentHTML = html.css("div[class^='frame-box']").first?.innerHTML ?? ""
        let detailHTML = "\(htmlStart)\(contentHTML)\(htmlEnd)"
        var attachmentList = [Attachment]()
        
        for link in html.css("table[class='bbs-view'] a") {
            print(link["href"])
            print(link.content)
            attachmentList.append(Attachment(fileName: link.content ?? "", fileURL: link["href"] ?? ""))
        }
        
        completion(attachmentList, detailHTML)
    }
    
    func parseKorean(html: HTMLDocument, completion: @escaping ([Attachment], String) -> Void) {
        let contentHTML = html.css("div[class^='frame-box']").first?.innerHTML ?? ""
        let detailHTML = "\(htmlStart)\(contentHTML)\(htmlEnd)"
        var attachmentList = [Attachment]()
        
        for link in html.css("table[class='bbs-view'] a") {
            print(link["href"])
            print(link.content)
            attachmentList.append(Attachment(fileName: link.content ?? "", fileURL: link["href"] ?? ""))
        }
        
        completion(attachmentList, detailHTML)
    }
    
    func parseFrench(html: HTMLDocument, completion: @escaping ([Attachment], String) -> Void) {
        let contentHTML = html.css("div[class^='frame-box']").first?.innerHTML ?? ""
        let detailHTML = "\(htmlStart)\(contentHTML)\(htmlEnd)"
        var attachmentList = [Attachment]()
        
        for link in html.css("table[class='bbs-view'] a") {
            print(link["href"])
            print(link.content)
            attachmentList.append(Attachment(fileName: link.content ?? "", fileURL: link["href"] ?? ""))
        }
        
        completion(attachmentList, detailHTML)
    }
}
