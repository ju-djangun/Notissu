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
    
    enum Margin {
        static var vertical: CGFloat = 0
        static var horizontal: CGFloat = 0
    }
    
    enum Paragraph {
        static var fontSize = ""
        static var lineHeight = ""
        static var textColor = ""
        static var pointColor = ""
    }
    
    private var htmlStart: String {
        // special thx to dino han
        """
        <head>
            <meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'>
        </head>
        <style>
            img {
                height: auto !important;
                width: auto !important;
            }

            iframe {
                width: calc(100vw - \(Margin.horizontal*2)px) !important;
                height: calc((100vw - \(Margin.horizontal*2)px)/ 16*9) !important;
                overflow: scroll;
            }

            table {
                width: 100% !important;
                height: auto !important;
            }

            body {
                margin: \(Margin.vertical)px \(Margin.horizontal)px;
            }
        
            * {
                line-height: \(Paragraph.lineHeight); !important;
                color: \(Paragraph.textColor); !important;
                font-size: \(Paragraph.fontSize); !important;
                font-family: '-apple-system' !important;
                max-width: 100% !important;
                -webkit-touch-callout: none;
            }

            a {
                color: \(Paragraph.pointColor);
                word-break: break-all; !important;
            }
        </style>
        """
    }
    private let htmlEnd = ""
    
    private init() { }
    
    public func parseNoticeList(type: DeptCode, page: Int, keyword: String?, completion: @escaping ([Notice]) -> Void) {
        type.parseList(page: page, keyword: keyword, completion: completion)
    }
    
    public func parseNoticeDetail(html: HTMLDocument, type: DeptCode, completion: @escaping ([Attachment], String) -> Void) {
        switch type {
        case .Soongsil:
            self.parseSoongsil(html: html, completion: completion)
        case .Dormitory:
            self.parseDormitory(html: html, completion: completion)
        case .MIX_mix:
            self.parseConvergence(html: html, host: "http://pre.ssu.ac.kr", completion: completion)
        case .IT_Computer:
            self.parseComputer(html: html, completion: completion)
        case .IT_Media:
            self.parseMedia(html: html, completion: completion)
        case .IT_Software:
            self.parseSoftware(html: html, completion: completion)
        case .IT_SmartSystem:
            break
        case .IT_Electric:
            self.parseElectric(html: html, completion: completion)
        case .LAW_Law:
            self.parseLaw(html: html, completion: completion)
        case .LAW_IntlLaw:
            self.parseIntlLaw(html: html, completion: completion)
        case .Inmun_Korean:
            self.parseInmun(html: html, host: "http://korlan.ssu.ac.kr", completion: completion)
        case .Inmun_French:
            self.parseInmun(html: html, host: "http://france.ssu.ac.kr", completion: completion)
        case .Inmun_German:
            self.parseInmun(html: html, host: "http://gerlan.ssu.ac.kr", completion: completion)
        case .Inmun_Chinese:
            self.parseInmun(html: html, host: "http://chilan.ssu.ac.kr", completion: completion)
        case .Inmun_English:
            self.parseInmun(html: html, host: "http://englan.ssu.ac.kr", completion: completion)
        case .Inmun_History:
            self.parseInmun(html: html, host: "http://history.ssu.ac.kr", completion: completion)
        case .Inmun_Writing:
            break
        case .Inmun_Philosophy:
            self.parseInmun(html: html, host: nil, completion: completion)
        case .Inmun_Japanese:
            self.parseInmun(html: html, host: "http://japanstu.ssu.ac.kr", completion: completion)
        case .Engineering_Machine:
            self.parseEngineerMachine(html: html, host: "http://me.ssu.ac.kr", completion: completion)
        case .Engineering_Organic:
            break
        case .Engineering_Chemistry:
            self.parseEngineerChemistry(html: html, completion: completion)
        case .Engineering_Electonic:
            self.parseEngineerElectric(html: html, host: "http://ee.ssu.ac.kr", completion: completion)
        case .Engineering_Architect:
            self.parseEngineerArchitect(html: html, host: "http://soar.ssu.ac.kr", completion: completion)
        case .Engineering_Industrial:
            self.parseEngineerIndustry(html: html, host: "http://iise.ssu.ac.kr", completion: completion)
        case .Economy_Economics:
            self.parseEconomyEconomics(html: html, host:"http://eco.ssu.ac.kr", completion: completion)
        case .Economy_GlobalCommerce:
            self.parseEconomyGlobalCommerce(html: html, host:nil, completion: completion)
        case .Business_biz:
            self.parseBusinessBiz(html: html, host: "http://biz.ssu.ac.kr", completion: completion)
        case .Business_venture:
            self.parseBusinessVenture(html: html, host: "http://ensb.ssu.ac.kr", completion: completion)
        case .Business_Account:
            self.parseBusinessAccount(html: html, host: "http://accounting.ssu.ac.kr", completion: completion)
        case .Business_Finance:
            self.parseBusinessFinance(html: html, host: "http://finance.ssu.ac.kr", completion: completion)
        case .NaturalScience_Math:
            self.parseNaturalMath(html: html, host: nil, completion: completion)
        case .NaturalScience_Chemistry:
            self.parseNaturalChemistry(html: html, host: nil, completion: completion)
        case .NaturalScience_Physics:
            self.parseNaturalPhysics(html: html, host: nil, completion: completion)
        case .NaturalScience_Actuarial:
            self.parseNaturalActuarial(html: html, host: nil, completion: completion)
        case .NaturalScience_Medical:
            self.parseNaturalMedical(html: html, host: nil, completion: completion)
        case .Social_Welfare:
            self.parseSocialWelfare(html: html, host:nil, completion: completion)
        case .Social_Administration:
            self.parseSocialAdministration(html: html, host:"http://pubad.ssu.ac.kr", completion: completion)
        case .Social_Sociology:
            self.parseSocialSociology(html: html, host:"http://inso.ssu.ac.kr", completion: completion)
        case .Social_Journalism:
            self.parseSocialJournalism(html: html, host:"http://pre.ssu.ac.kr", completion: completion)
        case .Social_LifeLong:
            self.parseSocialLifeLong(html: html, host: "http://lifelongedu.ssu.ac.kr", completion: completion)
        case .Social_Political:
            self.parseSocialPolitical(html: html, host: "http://pre.ssu.ac.kr", completion: completion)
        }
    }
}

extension NoticeParser {
    private func parseDormitory(html: HTMLDocument, completion: @escaping ([Attachment], String) -> Void) {
        let contentHTML = html.css("td[class=descript]").first?.innerHTML ?? ""
        let detailHTML = "\(htmlStart)\(contentHTML)\(htmlEnd)"
        var attachmentList = [Attachment]()
        
        for attachment in html.css("td[align=left] a") {
            if let fileName = attachment.text?.replacingOccurrences(of: "첨부)", with: ""), let fileLink = attachment["href"] {
                attachmentList.append(Attachment(fileName: fileName, fileURL: fileLink))
            }
        }
        
        completion(attachmentList, detailHTML)
    }
    
    private func parseSoongsil(html: HTMLDocument, completion: @escaping ([Attachment], String) -> Void) {
        var index = 0
        var contentHTML = ""
        for div in html.css("div[class^='bg-white p-4 mb-5'] div") {
            if index == 4 {
                contentHTML = div.toHTML ?? ""
            }
            index += 1
        }
        
        let detailHTML = "\(htmlStart)\(contentHTML)\(htmlEnd)"
        var attachmentList = [Attachment]()
        
        for attachment in html.css("ul[class^='download-list mt-5'] li") {
            let link = "https://scatch.ssu.ac.kr/\(attachment.css("a").first?["href"] ?? "")"
            let title = (attachment.css("a span").first?.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            
            print(link)
            print(title)
            
            attachmentList.append(Attachment(fileName: title, fileURL: link))
        }
        completion(attachmentList, detailHTML)
    }
    
    private func parseComputer(html: HTMLDocument, completion: @escaping ([Attachment], String) -> Void) {
        let contentHTML = html.css("td[class=content]").first?.innerHTML ?? ""
        
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
    
    private func parseElectric(html: HTMLDocument, completion: @escaping ([Attachment], String) -> Void) {
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
    
    private func parseSoftware(html: HTMLDocument, completion: @escaping ([Attachment], String) -> Void) {
        let contentHTML = html.css("div[class^='bo_view_2']").first?.innerHTML ?? ""
        //        let downloadUrl = "https://sw.ssu.ac.kr/bbs/download.php?bo_table=sub6_1&wr_id=1023&no=1"
        let detailHTML = "\(htmlStart)\(contentHTML)\(htmlEnd)"
        var attachmentList = [Attachment]()
        
        var index = 0
        for link in html.css("div[class^='bo_view_1'] a") {
            let url = link["href"]?.getArrayAfterRegex(regex: "[=](.*?)[&]")[1] ?? ""
            let fileName = link["href"]?.getArrayAfterRegex(regex: "['](.*?)[']")[1].decodeUrl() ?? ""
            let wr_id = url.replacingOccurrences(of: "&", with: "").replacingOccurrences(of: "=", with: "")
            
            let realUrl = "https://sw.ssu.ac.kr/bbs/download.php?bo_table=sub6_1&wr_id=\(wr_id)&no=\(index)"
            attachmentList.append(Attachment(fileName: fileName.replacingOccurrences(of: "'", with: ""), fileURL: realUrl))
            index += 1
        }
        
        completion(attachmentList, detailHTML)
    }
    
    private func parseMedia(html: HTMLDocument, completion: @escaping ([Attachment], String) -> Void) {
        let contentHTML = html.css("td[class^='s_default_view_body_2']").first?.innerHTML ?? ""
        var detailHTML = "\(htmlStart)\(contentHTML)\(htmlEnd)"
        let host = "http://media.ssu.ac.kr"
        detailHTML = detailHTML.replacingOccurrences(of: "src=\"/", with: "src=\"\(host )/")
        
        let mediaUrl = "http://media.ssu.ac.kr/"
        var attachmentList = [Attachment]()
        
        for link in html.css("td[width^=480] a") {
            let url = "\(mediaUrl)\(link["href"] ?? "")"
            attachmentList.append(Attachment(fileName: link.text ?? "", fileURL: url))
        }
        
        completion(attachmentList, detailHTML)
    }
    
    private func parseLaw(html: HTMLDocument, completion: @escaping ([Attachment], String) -> Void) {
        let contentHTML = html.css("div[class^='td_box']").first?.innerHTML ?? ""
        let detailHTML = "\(htmlStart)\(contentHTML)\(htmlEnd)"
        var attachmentList = [Attachment]()
        
        for link in html.css("ul[class='flie_list'] li") {
                        print(link.css("a").first?["href"])
            print(link.css("a").first?.content?.trimmingCharacters(in: .whitespacesAndNewlines))
            attachmentList.append(Attachment(fileName: link.css("a").first?.content?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "", fileURL: link.css("a").first?["href"] ?? ""))
        }
        
        completion(attachmentList, detailHTML)
    }
    
    private func parseIntlLaw(html: HTMLDocument, completion: @escaping ([Attachment], String) -> Void) {
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
    
    private func parseInmun(html: HTMLDocument, host: String?, completion: @escaping ([Attachment], String) -> Void) {
        let contentHTML = html.css("div[class^='frame-box']").first?.innerHTML ?? ""
        var detailHTML = "\(htmlStart)\(contentHTML)\(htmlEnd)"
        detailHTML = detailHTML.replacingOccurrences(of: "src=\"/", with: "src=\"\(host ?? "")/")
        var attachmentList = [Attachment]()
        
        for link in html.css("table[class='bbs-view'] a") {
            attachmentList.append(Attachment(fileName: link.content ?? "", fileURL: link["href"] ?? ""))
        }
        
        completion(attachmentList, detailHTML)
    }
    
    private func parseWriting(html: HTMLDocument, uid: String?, host: String?, completion: @escaping ([Attachment], String) -> Void) {
        let tables = html.css("span[id^='PrintLayer\(uid ?? "")'] table").makeIterator()
        let _ = tables.next()
        var contentHTML: String?
        
        guard let contentTable = tables.next() else {
            return
        }
        
        for (index, tr) in contentTable.css("tr").enumerated() {
            switch index {
            case 4:
                // Content
                contentHTML = tr.innerHTML ?? ""
            default:
                break
            }
        }
        
        let detailHTML = "\(htmlStart)\(contentHTML ?? "")\(htmlEnd)"
        completion([Attachment](), detailHTML)
    }
    
    // 공과대학
    // 화학공학과
    private func parseEngineerChemistry(html: HTMLDocument, completion: @escaping ([Attachment], String) -> Void) {
        let contentHTML = html.css("div[class^='body']").first?.innerHTML ?? ""
        var detailHTML = "\(htmlStart)\(contentHTML)\(htmlEnd)"
        detailHTML = detailHTML.replacingOccurrences(of: "src=\"", with: "src=\"http://chemeng.ssu.ac.kr")
        completion([Attachment](), detailHTML)
    }
    
    // 기계공학과
    private func parseEngineerMachine(html: HTMLDocument, host: String?, completion: @escaping ([Attachment], String) -> Void) {
        let contentHTML = html.css("div[class^='td_box']").first?.innerHTML ?? ""
        var detailHTML = "\(htmlStart)\(contentHTML)\(htmlEnd)"
        detailHTML = detailHTML.replacingOccurrences(of: "src=\"/", with: "src=\"\(host ?? "")/")
        let attachmentList = [Attachment]()
        
        completion(attachmentList, detailHTML)
    }
    
    private func parseEngineerElectric(html: HTMLDocument, host: String?, completion: @escaping ([Attachment], String) -> Void) {
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
                attachmentList.append(Attachment(fileName: link.content ?? "", fileURL: attachmentURL))
            }
        }
        completion(attachmentList, detailHTML)
    }
    
    private func parseEngineerIndustry(html: HTMLDocument, host: String?, completion: @escaping ([Attachment], String) -> Void) {
        let contentHTML = html.css("div[class^='frame-box']").first?.innerHTML ?? ""
        var detailHTML = "\(htmlStart)\(contentHTML)\(htmlEnd)"
        detailHTML = detailHTML.replacingOccurrences(of: "src=\"/", with: "src=\"\(host ?? "")/")
        var attachmentList = [Attachment]()
        
        for link in html.css("table[class='bbs-view'] a") {
            attachmentList.append(Attachment(fileName: link.content ?? "", fileURL: link["href"] ?? ""))
        }
        completion(attachmentList, detailHTML)
    }
    
    private func parseEngineerArchitect(html: HTMLDocument, host: String?, completion: @escaping ([Attachment], String) -> Void) {
        let fullHTML = html.css("table[class='table'] tr")
        var contentHTML = ""
        var attachmentList = [Attachment]()
        
        for tr in fullHTML {
            // 마지막 제외하고 모두 첨부파일임
            if tr.css("td p").count < 1 {
                let fileName = tr.css("a").first?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                let fileLink = tr.css("a").first?["href"]?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                attachmentList.append(Attachment(fileName: fileName, fileURL: "\(host!)\(fileLink)"))
            } else {
                contentHTML = tr.innerHTML ?? ""
                break
            }
        }
        
        let detailHTML = "\(htmlStart)\(contentHTML)\(htmlEnd)"
        // Attachment Format
        // http://soar.ssu.ac.kr/upload/20191008184403_붙임1-이수구분-변경-기준.hwp
        completion(attachmentList, detailHTML)
    }
    
    private func parseNaturalMath(html: HTMLDocument, host: String?, completion: @escaping ([Attachment], String) -> Void) {
        let contentHTML = html.css("div[class^='frame-box']").first?.innerHTML ?? ""
        var detailHTML = "\(htmlStart)\(contentHTML)\(htmlEnd)"
        detailHTML = detailHTML.replacingOccurrences(of: "src=\"/", with: "src=\"\(host ?? "")/")
        var attachmentList = [Attachment]()
        
        for link in html.css("table[class='bbs-view'] a") {
            attachmentList.append(Attachment(fileName: link.content ?? "", fileURL: link["href"] ?? ""))
        }
        completion(attachmentList, detailHTML)
    }
    
    private func parseNaturalPhysics(html: HTMLDocument, host: String?, completion: @escaping ([Attachment], String) -> Void) {
        let contentHTML = html.css("div[class^='frame-box']").first?.innerHTML ?? ""
        var detailHTML = "\(htmlStart)\(contentHTML)\(htmlEnd)"
        detailHTML = detailHTML.replacingOccurrences(of: "src=\"/", with: "src=\"\(host ?? "")/")
        var attachmentList = [Attachment]()
        
        for link in html.css("table[class='bbs-view'] a") {
            attachmentList.append(Attachment(fileName: link.content ?? "", fileURL: link["href"] ?? ""))
        }
        completion(attachmentList, detailHTML)
    }
    
    private func parseNaturalChemistry(html: HTMLDocument, host: String?, completion: @escaping ([Attachment], String) -> Void) {
        let contentHTML = html.css("div[class^='frame-box']").first?.innerHTML ?? ""
        var detailHTML = "\(htmlStart)\(contentHTML)\(htmlEnd)"
        detailHTML = detailHTML.replacingOccurrences(of: "src=\"/", with: "src=\"\(host ?? "")/")
        var attachmentList = [Attachment]()
        
        for link in html.css("table[class='bbs-view'] a") {
            attachmentList.append(Attachment(fileName: link.content ?? "", fileURL: link["href"] ?? ""))
        }
        completion(attachmentList, detailHTML)
    }
    
    private func parseNaturalActuarial(html: HTMLDocument, host: String?, completion: @escaping ([Attachment], String) -> Void) {
        let contentHTML = html.css("section[id^='bo_v_atc']").first?.innerHTML ?? ""
        var detailHTML = "\(htmlStart)\(contentHTML)\(htmlEnd)"
        detailHTML = detailHTML.replacingOccurrences(of: "src=\"/", with: "src=\"\(host ?? "")/")
        var attachmentList = [Attachment]()
        
        for link in html.css("section[id='bo_v_file'] a") {
            attachmentList.append(Attachment(fileName: link.css("strong").first?.content ?? "", fileURL: link["href"] ?? ""))
        }
        completion(attachmentList, detailHTML)
    }
    
    private func parseNaturalMedical(html: HTMLDocument, host: String?, completion: @escaping ([Attachment], String) -> Void) {
        let contentHTML = html.css("div[class^='frame-box']").first?.innerHTML ?? ""
        var detailHTML = "\(htmlStart)\(contentHTML)\(htmlEnd)"
        detailHTML = detailHTML.replacingOccurrences(of: "src=\"/", with: "src=\"\(host ?? "")/")
        var attachmentList = [Attachment]()
        
        for link in html.css("table[class='bbs-view'] a") {
            attachmentList.append(Attachment(fileName: link.content ?? "", fileURL: link["href"] ?? ""))
        }
        completion(attachmentList, detailHTML)
    }
    
    private func parseBusinessBiz(html: HTMLDocument, host: String?, completion: @escaping ([Attachment], String) -> Void) {
        let contentHTML = html.css("div[id^='postContents']").first?.innerHTML ?? ""
        var detailHTML = "\(htmlStart)\(contentHTML)\(htmlEnd)"
        detailHTML = detailHTML.replacingOccurrences(of: "src=\"/", with: "src=\"\(host ?? "")/")
        var attachmentList = [Attachment]()
        
        for link in html.css("ul[id='postFileList'] a") {
            attachmentList.append(Attachment(fileName: link.content ?? "", fileURL: "\(host ?? "")\(link["href"] ?? "")" ))
        }
        completion(attachmentList, detailHTML)
    }
    
    private func parseBusinessVenture(html: HTMLDocument, host: String?, completion: @escaping ([Attachment], String) -> Void) {
        let contentHTML = html.css("div[class^='frame-box']").first?.innerHTML ?? ""
        var detailHTML = "\(htmlStart)\(contentHTML)\(htmlEnd)"
        detailHTML = detailHTML.replacingOccurrences(of: "src=\"/", with: "src=\"\(host ?? "")/")
        var attachmentList = [Attachment]()
        
        for link in html.css("table[class='bbs-view'] a") {
            attachmentList.append(Attachment(fileName: link.content ?? "", fileURL: link["href"] ?? ""))
        }
        completion(attachmentList, detailHTML)
    }
    
    private func parseBusinessAccount(html: HTMLDocument, host: String?, completion: @escaping ([Attachment], String) -> Void) {
        let contentHTML = html.css("div[class^='frame-box']").first?.innerHTML ?? ""
        var detailHTML = "\(htmlStart)\(contentHTML)\(htmlEnd)"
        detailHTML = detailHTML.replacingOccurrences(of: "src=\"/", with: "src=\"\(host ?? "")/")
        var attachmentList = [Attachment]()
        
        for link in html.css("table[class='bbs-view'] a") {
            attachmentList.append(Attachment(fileName: link.content ?? "", fileURL: link["href"] ?? ""))
        }
        completion(attachmentList, detailHTML)
    }
    
    private func parseBusinessFinance(html: HTMLDocument, host: String?, completion: @escaping ([Attachment], String) -> Void) {
        let contentHTML = html.css("div[class^='frame-box']").first?.innerHTML ?? ""
        var detailHTML = "\(htmlStart)\(contentHTML)\(htmlEnd)"
        detailHTML = detailHTML.replacingOccurrences(of: "src=\"/", with: "src=\"\(host ?? "")/")
        var attachmentList = [Attachment]()
        
        for link in html.css("table[class='bbs-view'] a") {
            attachmentList.append(Attachment(fileName: link.content ?? "", fileURL: link["href"] ?? ""))
        }
        completion(attachmentList, detailHTML)
    }
    
    private func parseEconomyEconomics(html: HTMLDocument, host: String?, completion: @escaping ([Attachment], String) -> Void) {
        let contentHTML = html.css("section[id^='bo_v_atc']").first?.innerHTML ?? ""
        var detailHTML = "\(htmlStart)\(contentHTML)\(htmlEnd)"
        detailHTML = detailHTML.replacingOccurrences(of: "src=\"/", with: "src=\"\(host ?? "")/")
        var attachmentList = [Attachment]()
        
        for link in html.css("section[id^='bo_v_file'] a") {
            attachmentList.append(Attachment(fileName: link.css("strong").first?.content ?? "", fileURL: link["href"] ?? ""))
        }
        completion(attachmentList, detailHTML)
    }
    
    private func parseEconomyGlobalCommerce(html: HTMLDocument, host: String?, completion: @escaping ([Attachment], String) -> Void) {
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
    private func parseSocialWelfare(html: HTMLDocument, host: String?, completion: @escaping ([Attachment], String) -> Void) {
        let contentHTML = html.css("div[class^='td_box']").first?.innerHTML ?? ""
        var detailHTML = "\(htmlStart)\(contentHTML)\(htmlEnd)"
        detailHTML = detailHTML.replacingOccurrences(of: "src=\"/", with: "src=\"\(host ?? "")/")
        var attachmentList = [Attachment]()
        
        for link in html.css("ul[class='flie_list'] a") {
            attachmentList.append(Attachment(fileName: (link.content ?? "").trimmingCharacters(in: .whitespacesAndNewlines), fileURL: link["href"] ?? ""))
        }
        completion(attachmentList, detailHTML)
    }
    
    private func parseSocialAdministration(html: HTMLDocument, host: String?, completion: @escaping ([Attachment], String) -> Void) {
        let contentHTML = html.css("div[class^='td_box']").first?.innerHTML ?? ""
        let detailHTML = "\(htmlStart)\(contentHTML)\(htmlEnd)"
        var attachmentList = [Attachment]()
        
        for link in html.css("ul[class='flie_list'] li a") {
            let fileUrl = link["href"] ?? ""
            let fileName = (link.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            attachmentList.append(Attachment(fileName: fileName, fileURL: fileUrl))
        }
        completion(attachmentList, detailHTML)
    }
    
    private func parseSocialSociology(html: HTMLDocument, host: String?, completion: @escaping ([Attachment], String) -> Void) {
        //view_content
        let contentHTML = html.css("div[class='view_content']").first?.innerHTML ?? ""
        var detailHTML = "\(htmlStart)\(contentHTML)\(htmlEnd)"
        detailHTML = detailHTML.replacingOccurrences(of: "src=\"/", with: "src=\"\(host ?? "")/")
        var attachmentList = [Attachment]()
        
        for link in html.css("div[class='board_view'] a") {
            let arguments = link["href"]?.getArrayAfterRegex(regex: "[(](.*?)[)]") ?? []
            if arguments.count > 0 {
                let params = arguments[0].replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "'", with: "")
                let boardId = params.split(separator: ",")[0]
                let bIndex = params.split(separator: ",")[1]
                let index = params.split(separator: ",")[2]
                
                let attachmentURL = "\(host ?? "")/module/board/download.php?boardid=\(boardId)&b_idx=\(bIndex)&idx=\(index)"
                attachmentList.append(Attachment(fileName: link.content ?? "", fileURL: attachmentURL))
            }
        }
        completion(attachmentList, detailHTML)
    }
    
    private func parseSocialJournalism(html: HTMLDocument, host: String?, completion: @escaping ([Attachment], String) -> Void) {
        let contentHTML = html.css("div[class^='frame-box']").first?.innerHTML ?? ""
        var detailHTML = "\(htmlStart)\(contentHTML)\(htmlEnd)"
        detailHTML = detailHTML.replacingOccurrences(of: "src=\"/", with: "src=\"\(host ?? "")/")
        var attachmentList = [Attachment]()
        
        for link in html.css("table[class='bbs-view'] a") {
            attachmentList.append(Attachment(fileName: link.content ?? "", fileURL: link["href"] ?? ""))
        }
        completion(attachmentList, detailHTML)
    }
    
    private func parseSocialLifeLong(html: HTMLDocument, host: String?, completion: @escaping ([Attachment], String) -> Void) {
        let contentHTML = html.css("span[id='writeContents']").first?.toHTML ?? ""
        var detailHTML = "\(htmlStart)\(contentHTML)\(htmlEnd)"
        detailHTML = detailHTML.replacingOccurrences(of: "src=\"/", with: "src=\"\(host ?? "")/")
        var attachmentList = [Attachment]()
        var index = 0
        for link in html.css("div[id='content'] a") {
            if index > 1 {
                if "\(link["href"] ?? "")".contains("download") && link["href"]?.getArrayAfterRegex(regex: "[=](.*?)[&]").count ?? 0 > 1 {
                    let url = link["href"]?.getArrayAfterRegex(regex: "[=](.*?)[&]")[1] ?? ""
                    let wr_id = url.replacingOccurrences(of: "&", with: "").replacingOccurrences(of: "=", with: "")
                    let realUrl = "http://lifelongedu.ssu.ac.kr/bbs/download.php?bo_table=univ&wr_id=\(wr_id)&no=\(index - 2)"
                    attachmentList.append(Attachment(fileName: link.css("span").first?.content ?? "", fileURL: realUrl))
                }
            }
            index += 1
        }
        completion(attachmentList, detailHTML)
    }
    
    private func parseSocialPolitical(html: HTMLDocument, host: String?, completion: @escaping ([Attachment], String) -> Void) {
        let contentHTML = html.css("div[class^='frame-box']").first?.innerHTML ?? ""
        var detailHTML = "\(htmlStart)\(contentHTML)\(htmlEnd)"
        detailHTML = detailHTML.replacingOccurrences(of: "src=\"/", with: "src=\"\(host ?? "")/")
        var attachmentList = [Attachment]()
        
        for link in html.css("table[class='bbs-view'] a") {
            attachmentList.append(Attachment(fileName: link.content ?? "", fileURL: link["href"] ?? ""))
        }
        completion(attachmentList, detailHTML)
    }
    
    private func parseConvergence(html: HTMLDocument, host: String?, completion: @escaping ([Attachment], String) -> Void) {
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
