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
            //            print(link["href"])
            //            print(link.content)
            attachmentList.append(Attachment(fileName: link.content ?? "", fileURL: link["href"] ?? ""))
        }
        
        completion(attachmentList, detailHTML)
    }
    
    func parseInmun(html: HTMLDocument, host: String?, completion: @escaping ([Attachment], String) -> Void) {
        let contentHTML = html.css("div[class^='frame-box']").first?.innerHTML ?? ""
        var detailHTML = "\(htmlStart)\(contentHTML)\(htmlEnd)"
        detailHTML = detailHTML.replacingOccurrences(of: "src=\"/", with: "src=\"\(host ?? "")/")
        var attachmentList = [Attachment]()
        
        for link in html.css("table[class='bbs-view'] a") {
            //            print(link["href"])
            //            print(link.content)
            attachmentList.append(Attachment(fileName: link.content ?? "", fileURL: link["href"] ?? ""))
        }
        
        completion(attachmentList, detailHTML)
    }
    
    // 공과대학
    // 화학공학과
    func parseEngineerChemistry(html: HTMLDocument, completion: @escaping ([Attachment], String) -> Void) {
        let contentHTML = html.css("div[class^='body']").first?.innerHTML ?? ""
        var detailHTML = "\(htmlStart)\(contentHTML)\(htmlEnd)"
        detailHTML = detailHTML.replacingOccurrences(of: "src=\"", with: "src=\"http://chemeng.ssu.ac.kr")
        print(detailHTML)
        completion([Attachment](), detailHTML)
    }
    
    // 기계공학과
    func parseEngineerMachine(html: HTMLDocument, host: String?, completion: @escaping ([Attachment], String) -> Void) {
        let contentHTML = html.css("div[class^='frame-box']").first?.innerHTML ?? ""
        var detailHTML = "\(htmlStart)\(contentHTML)\(htmlEnd)"
        detailHTML = detailHTML.replacingOccurrences(of: "src=\"/", with: "src=\"\(host ?? "")/")
        var attachmentList = [Attachment]()
        
        for link in html.css("table[class='bbs-view'] a") {
            //            print(link["href"])
            //            print(link.content)
            attachmentList.append(Attachment(fileName: link.content ?? "", fileURL: link["href"] ?? ""))
        }
        
        completion(attachmentList, detailHTML)
    }
    
    func parseEngineerElectric(html: HTMLDocument, host: String?, completion: @escaping ([Attachment], String) -> Void) {
        let contentHTML = html.css("div[class^='body']").first?.innerHTML ?? ""
        var detailHTML = "\(htmlStart)\(contentHTML)\(htmlEnd)"
        detailHTML = detailHTML.replacingOccurrences(of: "src=\"/", with: "src=\"\(host ?? "")/")
        var attachmentList = [Attachment]()
        
        for link in html.css("div[class='fileLayer'] a") {
            let arguments = link["href"]?.getArrayAfterRegex(regex: "[(](.*?)[)]") ?? []
            if arguments.count > 0 {
                let params = arguments[0].replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "'", with: "")
                let boardId = params.split(separator: ",")[0]
                let bIndex = params.split(separator: ",")[1]
                let index = params.split(separator: ",")[2]
                
                let attachmentURL = "http://ee.ssu.ac.kr/module/board/download.php?boardid=\(boardId)&b_idx=\(bIndex)&idx=\(index)"
                print(attachmentURL)
                attachmentList.append(Attachment(fileName: link.content ?? "", fileURL: attachmentURL))
            }
        }
//        attachmentList.remove(at: attachmentList.count - 1)
        completion(attachmentList, detailHTML)
    }
    
    func parseEngineerIndustry(html: HTMLDocument, host: String?, completion: @escaping ([Attachment], String) -> Void) {
        let contentHTML = html.css("div[class^='frame-box']").first?.innerHTML ?? ""
        var detailHTML = "\(htmlStart)\(contentHTML)\(htmlEnd)"
        detailHTML = detailHTML.replacingOccurrences(of: "src=\"/", with: "src=\"\(host ?? "")/")
        var attachmentList = [Attachment]()
        
        for link in html.css("table[class='bbs-view'] a") {
            //            print(link["href"])
            //            print(link.content)
            attachmentList.append(Attachment(fileName: link.content ?? "", fileURL: link["href"] ?? ""))
        }
        completion(attachmentList, detailHTML)
    }
    
    func parseNaturalMath(html: HTMLDocument, host: String?, completion: @escaping ([Attachment], String) -> Void) {
        let contentHTML = html.css("div[class^='frame-box']").first?.innerHTML ?? ""
        var detailHTML = "\(htmlStart)\(contentHTML)\(htmlEnd)"
        detailHTML = detailHTML.replacingOccurrences(of: "src=\"/", with: "src=\"\(host ?? "")/")
        var attachmentList = [Attachment]()
        
        for link in html.css("table[class='bbs-view'] a") {
            //            print(link["href"])
            //            print(link.content)
            attachmentList.append(Attachment(fileName: link.content ?? "", fileURL: link["href"] ?? ""))
        }
        completion(attachmentList, detailHTML)
    }
    
    func parseNaturalPhysics(html: HTMLDocument, host: String?, completion: @escaping ([Attachment], String) -> Void) {
        let contentHTML = html.css("div[class^='frame-box']").first?.innerHTML ?? ""
        var detailHTML = "\(htmlStart)\(contentHTML)\(htmlEnd)"
        detailHTML = detailHTML.replacingOccurrences(of: "src=\"/", with: "src=\"\(host ?? "")/")
        var attachmentList = [Attachment]()
        
        for link in html.css("table[class='bbs-view'] a") {
            //            print(link["href"])
            //            print(link.content)
            attachmentList.append(Attachment(fileName: link.content ?? "", fileURL: link["href"] ?? ""))
        }
        completion(attachmentList, detailHTML)
    }
    
    func parseNaturalChemistry(html: HTMLDocument, host: String?, completion: @escaping ([Attachment], String) -> Void) {
        let contentHTML = html.css("div[class^='frame-box']").first?.innerHTML ?? ""
        var detailHTML = "\(htmlStart)\(contentHTML)\(htmlEnd)"
        detailHTML = detailHTML.replacingOccurrences(of: "src=\"/", with: "src=\"\(host ?? "")/")
        var attachmentList = [Attachment]()
        
        for link in html.css("table[class='bbs-view'] a") {
            //            print(link["href"])
            //            print(link.content)
            attachmentList.append(Attachment(fileName: link.content ?? "", fileURL: link["href"] ?? ""))
        }
        completion(attachmentList, detailHTML)
    }
    
    func parseNaturalActuarial(html: HTMLDocument, host: String?, completion: @escaping ([Attachment], String) -> Void) {
        let contentHTML = html.css("section[id^='bo_v_atc']").first?.innerHTML ?? ""
        var detailHTML = "\(htmlStart)\(contentHTML)\(htmlEnd)"
        detailHTML = detailHTML.replacingOccurrences(of: "src=\"/", with: "src=\"\(host ?? "")/")
        var attachmentList = [Attachment]()
        
        for link in html.css("section[id='bo_v_file'] a") {
            print(link["href"])
            print(link.css("strong").first?.content)
            attachmentList.append(Attachment(fileName: link.css("strong").first?.content ?? "", fileURL: link["href"] ?? ""))
        }
        completion(attachmentList, detailHTML)
    }
    
    func parseNaturalMedical(html: HTMLDocument, host: String?, completion: @escaping ([Attachment], String) -> Void) {
        let contentHTML = html.css("div[class^='frame-box']").first?.innerHTML ?? ""
        var detailHTML = "\(htmlStart)\(contentHTML)\(htmlEnd)"
        detailHTML = detailHTML.replacingOccurrences(of: "src=\"/", with: "src=\"\(host ?? "")/")
        var attachmentList = [Attachment]()
        
        for link in html.css("table[class='bbs-view'] a") {
            //            print(link["href"])
            //            print(link.content)
            attachmentList.append(Attachment(fileName: link.content ?? "", fileURL: link["href"] ?? ""))
        }
        completion(attachmentList, detailHTML)
    }
    
    func parseBusinessBiz(html: HTMLDocument, host: String?, completion: @escaping ([Attachment], String) -> Void) {
        let contentHTML = html.css("div[id^='postContents']").first?.innerHTML ?? ""
        var detailHTML = "\(htmlStart)\(contentHTML)\(htmlEnd)"
        detailHTML = detailHTML.replacingOccurrences(of: "src=\"/", with: "src=\"\(host ?? "")/")
        var attachmentList = [Attachment]()
        
        for link in html.css("ul[id='postFileList'] a") {
            print("\(host ?? "")\(link["href"] ?? "")")
            print(link.content)
            attachmentList.append(Attachment(fileName: link.content ?? "", fileURL: "\(host ?? "")\(link["href"] ?? "")" ))
        }
        completion(attachmentList, detailHTML)
    }
    
    func parseBusinessVenture(html: HTMLDocument, host: String?, completion: @escaping ([Attachment], String) -> Void) {
        let contentHTML = html.css("div[class^='frame-box']").first?.innerHTML ?? ""
        var detailHTML = "\(htmlStart)\(contentHTML)\(htmlEnd)"
        detailHTML = detailHTML.replacingOccurrences(of: "src=\"/", with: "src=\"\(host ?? "")/")
        var attachmentList = [Attachment]()
        
        for link in html.css("table[class='bbs-view'] a") {
            //            print(link["href"])
            //            print(link.content)
            attachmentList.append(Attachment(fileName: link.content ?? "", fileURL: link["href"] ?? ""))
        }
        completion(attachmentList, detailHTML)
    }
    
    func parseBusinessAccount(html: HTMLDocument, host: String?, completion: @escaping ([Attachment], String) -> Void) {
        let contentHTML = html.css("div[class^='frame-box']").first?.innerHTML ?? ""
        var detailHTML = "\(htmlStart)\(contentHTML)\(htmlEnd)"
        detailHTML = detailHTML.replacingOccurrences(of: "src=\"/", with: "src=\"\(host ?? "")/")
        var attachmentList = [Attachment]()
        
        for link in html.css("table[class='bbs-view'] a") {
            attachmentList.append(Attachment(fileName: link.content ?? "", fileURL: link["href"] ?? ""))
        }
        completion(attachmentList, detailHTML)
    }
    
    func parseBusinessFinance(html: HTMLDocument, host: String?, completion: @escaping ([Attachment], String) -> Void) {
        let contentHTML = html.css("div[class^='frame-box']").first?.innerHTML ?? ""
        var detailHTML = "\(htmlStart)\(contentHTML)\(htmlEnd)"
        detailHTML = detailHTML.replacingOccurrences(of: "src=\"/", with: "src=\"\(host ?? "")/")
        var attachmentList = [Attachment]()
        
        for link in html.css("table[class='bbs-view'] a") {
            attachmentList.append(Attachment(fileName: link.content ?? "", fileURL: link["href"] ?? ""))
        }
        completion(attachmentList, detailHTML)
    }
    
    func parseEconomyEconomics(html: HTMLDocument, host: String?, completion: @escaping ([Attachment], String) -> Void) {
        let contentHTML = html.css("div[class^='frame-box']").first?.innerHTML ?? ""
        var detailHTML = "\(htmlStart)\(contentHTML)\(htmlEnd)"
        detailHTML = detailHTML.replacingOccurrences(of: "src=\"/", with: "src=\"\(host ?? "")/")
        var attachmentList = [Attachment]()
        
        for link in html.css("table[class='bbs-view'] a") {
            attachmentList.append(Attachment(fileName: link.content ?? "", fileURL: link["href"] ?? ""))
        }
        completion(attachmentList, detailHTML)
    }
    
    func parseEconomyGlobalCommerce(html: HTMLDocument, host: String?, completion: @escaping ([Attachment], String) -> Void) {
        let contentHTML = html.css("div[class^='frame-box']").first?.innerHTML ?? ""
        var detailHTML = "\(htmlStart)\(contentHTML)\(htmlEnd)"
        detailHTML = detailHTML.replacingOccurrences(of: "src=\"/", with: "src=\"\(host ?? "")/")
        var attachmentList = [Attachment]()
        
        for link in html.css("table[class='bbs-view'] a") {
            attachmentList.append(Attachment(fileName: link.content ?? "", fileURL: link["href"] ?? ""))
        }
        completion(attachmentList, detailHTML)
    }
    
    // 사회과학대학
    func parseSocialWelfare(html: HTMLDocument, host: String?, completion: @escaping ([Attachment], String) -> Void) {
        let contentHTML = html.css("div[class^='frame-box']").first?.innerHTML ?? ""
        var detailHTML = "\(htmlStart)\(contentHTML)\(htmlEnd)"
        detailHTML = detailHTML.replacingOccurrences(of: "src=\"/", with: "src=\"\(host ?? "")/")
        var attachmentList = [Attachment]()
        
        for link in html.css("table[class='bbs-view'] a") {
            attachmentList.append(Attachment(fileName: link.content ?? "", fileURL: link["href"] ?? ""))
        }
        completion(attachmentList, detailHTML)
    }
    
    func parseSocialAdministration(html: HTMLDocument, host: String?, completion: @escaping ([Attachment], String) -> Void) {
        let contentHTML = html.css("div[class^='frame-box']").first?.innerHTML ?? ""
        var detailHTML = "\(htmlStart)\(contentHTML)\(htmlEnd)"
        detailHTML = detailHTML.replacingOccurrences(of: "src=\"/", with: "src=\"\(host ?? "")/")
        var attachmentList = [Attachment]()
        
        for link in html.css("table[class='bbs-view'] a") {
            attachmentList.append(Attachment(fileName: link.content ?? "", fileURL: link["href"] ?? ""))
        }
        completion(attachmentList, detailHTML)
    }
    
}
