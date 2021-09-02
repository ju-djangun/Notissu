//
//  NoticeIT.swift
//  Notissu
//
//  Copyright © 2019 Notissu. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import Kanna

class NoticeIT: NoticeBaseModel {
    static func parseListComputer(page: Int, keyword: String?, completion: @escaping ([Notice]) -> Void) {
        var index = 0
        
        let keywordSearch = keyword?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let requestURL = NoticeRequestURL.IT_computer(page: page, keyword: keywordSearch)
        
        self.cleanList()
        
        AF.request(requestURL).responseString(encoding: .utf8, completionHandler: { response in
            switch(response.result) {
            case .success(_):
                if let data = response.value {
                    do {
                        let doc = try HTML(html: data, encoding: .utf8)
                        for product in doc.xpath("//table/tbody/tr/*") {
                            if product.nextSibling?.className ?? "" == "center" {
                                let noticeAuthor = product.nextSibling?.text ?? ""
                                let noticeDate = product.nextSibling?.nextSibling?.text ?? ""
                                let pageString = product.at_xpath("a")?["href"] ?? ""
                                
                                if !pageString.isEmpty {
                                    switch index % 2 {
                                    case 0:
                                        // Attachment
                                        var hasAttachment = false
                                        if let inner = product.innerHTML {
                                            if inner.contains("ico_file_chk.gif") {
                                                // Attachment
                                                hasAttachment = true
                                            }
                                        }
                                        attachmentCheckList.append(hasAttachment)
                                        
                                        // Title & Author
                                        let noticeTitle = product.content ?? ""
                                        authorList.append(noticeAuthor)
                                        titleList.append(noticeTitle)
                                        pageStringList.append("http://cse.ssu.ac.kr/03_sub/01_sub.htm\(pageString)")
                                        dateStringList.append(noticeDate)
                                        isNoticeList.append(false)
                                        break;
                                    case 1:  break;
                                    default: break
                                    }
                                }
                                index += 1
                                
                            } else if product.nextSibling?.className ?? "" == "etc" {
                                // 첫 페이지만 보여주기
                                
                                if page < 2 {
                                    let noticeAuthor = product.nextSibling?.text ?? ""
                                    let noticeDate = product.nextSibling?.nextSibling?.text ?? ""
                                    let pageString = product.css("a").first?["href"] ?? ""
                                    
                                    if !pageString.isEmpty {
                                        //http://cse.ssu.ac.kr/03_sub/01_sub.htm
                                        
                                        switch index % 2 {
                                        case 0:
                                            // Attachment
                                            var hasAttachment = false
                                            if let inner = product.innerHTML {
                                                if inner.contains("ico_file_chk.gif") {
                                                    // Attachment
                                                    hasAttachment = true
                                                }
                                            }
                                            attachmentCheckList.append(hasAttachment)
                                            
                                            let noticeTitle = product.content ?? ""
                                            authorList.append(noticeAuthor)
                                            titleList.append(noticeTitle)
                                            pageStringList.append("http://cse.ssu.ac.kr/03_sub/01_sub.htm\(pageString)")
                                            dateStringList.append(noticeDate)
                                            isNoticeList.append(true)
                                            break;
                                        case 1: break;
                                        default: break
                                        }
                                    }
                                    index += 1
                                }
                            }
                        }
                        
                        index = 0
                        if authorList.count < 1 {
                            ConfigSetting.canFetchData = false
                        }
                        
                        for _ in authorList {
                            let noticeItem = Notice(author: authorList[index], title: titleList[index], url: pageStringList[index], date: dateStringList[index], isNotice: isNoticeList[index], hasAttachment: attachmentCheckList[index])
                            
                            noticeList.append(noticeItem)
                            index += 1
                        }
                        
                        completion(noticeList)
                    } catch let error {
                        print("Error : \(error)")
                    }
                }
            case .failure(_):
                print("Error message:\(String(describing: response.error))")
                break
            }
        })
    }
    
    static func parseListMedia(page: Int, keyword: String?, completion: @escaping ([Notice]) -> Void) {
        var index = 0
        
        let keywordSearch = keyword?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let requestURL = NoticeRequestURL.IT_media(page: page, keyword: keywordSearch)
        
        self.cleanList()
        
        AF.request(requestURL).responseString(completionHandler: { response in
            switch(response.result) {
            case .success(_):
                guard let data = response.data else { return }
                let utf8Text = String(data: data, encoding: .utf8) ?? String(decoding: data, as: UTF8.self)
                
                do {
                    let doc = try HTML(html: utf8Text, encoding: .utf8)
                    for product in doc.css("table tbody tr a") {
                        let noticeId = product["onclick"]?.getArrayAfterRegex(regex: "['](.*?)[']")[0] ?? ""
                        let url = "http://media.ssu.ac.kr/sub.php?code=XxH00AXY&mode=view&board_num=\(noticeId)&category=1"
                        urlList.append(url)
                        titleList.append(product.content ?? "")
                    }
                    
                    index = 0
                    for product in doc.css("td[align='center']") {
                        if index % 4 == 0 {
                            let isNotice = product.text ?? ""
                            if !isNotice.isNumeric() {
                                isNoticeList.append(true)
                            } else {
                                isNoticeList.append(false)
                            }
                        }
                        
                        if index % 4 == 1 {
                            authorList.append(product.content ?? "")
                        } else if index % 4 == 2 {
                            dateStringList.append(product.content ?? "")
                        }
                        index += 1
                    }
                    
                    index = 0
                    if authorList.count < 1 {
                        ConfigSetting.canFetchData = false
                    }
                    
                    for _ in authorList {
                        let noticeItem = Notice(author: authorList[index], title: titleList[index], url: urlList[index], date: dateStringList[index], isNotice: isNoticeList[index])
                        
                        noticeList.append(noticeItem)
                        index += 1
                    }
                    
                    completion(noticeList)
                } catch let error {
                    print("Error : \(error)")
                }
            case .failure(_):
                print("Error message:\(String(describing: response.error))")
                break
            }
        })
    }
    
    static func parseListSoftware(page: Int, keyword: String?, completion: @escaping ([Notice]) -> Void) {
        var index = 0
        
        let keywordSearch = keyword?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let requestURL = NoticeRequestURL.IT_software(page: page, keyword: keywordSearch)
        
        self.cleanList()
        
        AF.request(requestURL).responseString(encoding: .utf8, completionHandler: { response in
            switch(response.result) {
            case .success(_):
                if let data = response.value {
                    do {
                        let doc = try HTML(html: data, encoding: .utf8)
                        for product in doc.css("td[class^=num]") {
                            let num = product.css("b").first?.text ?? ""
                            
                            if num.isEmpty {
                                // isNotice
                                isNoticeList.append(false)
                            } else {
                                isNoticeList.append(true)
                            }
                        }
                        
                        for product in doc.css("td[class^=subject]") {
                            var hasAttachment = false
                            for image in product.css("img") {
                                let imageSrc = image["src"] ?? ""
                                if imageSrc.contains("icon_file.gif") {
                                    hasAttachment = true
                                }
                            }
                            attachmentCheckList.append(hasAttachment)
                        }
                        
                        for product in doc.css("td[class^=subject] a") {
                            var url = product["href"] ?? ""
                            url = url.replacingOccurrences(of: "..", with: "https://sw.ssu.ac.kr")
                            titleList.append(product.text ?? "")
                            urlList.append(url)
                        }
                        
                        for product in doc.css("td[class^=datetime]") {
                            dateStringList.append(product.text ?? "")
                        }
                        
                        for product in doc.css("td[class^=name]") {
                            authorList.append(product.text ?? "")
                        }
                    } catch let error {
                        print("Error : \(error)")
                    }
                    
                    index = 0
                    if authorList.count < 1 {
                        ConfigSetting.canFetchData = false
                    }
                    
                    for _ in authorList {
                        let noticeItem = Notice(author: authorList[index], title: titleList[index], url: urlList[index], date: dateStringList[index], isNotice: isNoticeList[index], hasAttachment: attachmentCheckList[index])
                        
                        noticeList.append(noticeItem)
                        index += 1
                    }
                    
                    completion(noticeList)
                }
            case .failure(_):
                print("Error message:\(String(describing: response.error))")
                break
            }
        })
    }
    
    static func parseListElectric(page: Int, keyword: String?, completion: @escaping ([Notice]) -> Void) {
        var index = 0
        
        let keywordSearch = keyword?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let requestURL = NoticeRequestURL.IT_electric(page: page, keyword: keywordSearch)
        
        self.cleanList()
        
        AF.request(requestURL).responseString(completionHandler: { response in
            //            print("\(response.result.isSuccess)")
            //            print(response.result.value ?? "")
            switch(response.result) {
            case .success(_):
                if let data = response.value {
                    print(data)
                    do {
                        let doc = try HTML(html: data, encoding: .utf8)
                        for product in doc.css("div[class^='list']") {
                            let url = "http://infocom.ssu.ac.kr\((product.toHTML?.getArrayAfterRegex(regex: "(?=')\\S+(?=')")[0].split(separator: "'")[0] ?? "")!.replacingOccurrences(of: "&amp;", with: "&"))"
                            
                            // Attachment
                            var hasAttachment = false
                            if let imgSrc = product.css("div[class^='info'] img").first?["src"] {
                                if imgSrc.contains("ico_file.gif") {
                                    hasAttachment = true
                                }
                            }
                            attachmentCheckList.append(hasAttachment)
                            
                            let strs = (product.css("div[class^='info']").first?.text ?? "")!.split(separator: "|")
                            
                            urlList.append(url)
                            authorList.append(strs[0].trimmingCharacters(in: .whitespacesAndNewlines))
                            dateStringList.append(strs[1].trimmingCharacters(in: .whitespacesAndNewlines))
                            
                            if product.css("span[class^='subject']").first!.text == "" {
                                titleList.append("(제목없음)")
                            } else {
                                titleList.append(product.css("span[class^='subject']").first!.text!)
                            }
                            
                            if product.innerHTML?.contains("img") ?? false {
                                // isNotice
                                isNoticeList.append(true)
                            } else {
                                isNoticeList.append(false)
                            }
                        }
                    } catch let error {
                        print("Error : \(error)")
                    }
                }
                
                index = 0
                for _ in authorList {
                    let noticeItem = Notice(author: authorList[index], title: titleList[index], url: urlList[index], date: dateStringList[index], isNotice: isNoticeList[index], hasAttachment: attachmentCheckList[index])
                    noticeList.append(noticeItem)
                    index += 1
                }
                
                completion(noticeList)
            case .failure(_):
                print("Error message:\(String(describing: response.error))")
                break
            }
        })
    }
    
    static func parseListSmartSystem(page: Int, keyword: String?, completion: @escaping ([Notice]) -> Void) {
        var index = 0
        
        let keywordSearch = keyword?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let requestURL = NoticeRequestURL.IT_smartsw(page: page, keyword: keywordSearch)
        
        self.cleanList()
        
        AF.request(requestURL).responseString(encoding: .utf8, completionHandler: { response in
            switch(response.result) {
            case .success(_):
                if let data = response.value {
                    do {
                        let doc = try HTML(html: data, encoding: .utf8)
                        
                        for product in doc.css("table[class='ui celled padded table'] tbody td") {
                            let content = (product.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
                            switch(index % 4) {
                            case 0:
                                //title
                                titleList.append(content)
                                break
                            case 1:
                                //author
                                authorList.append(content)
                                break
                            case 2:
                                //date
                                dateStringList.append(content)
                                break
                            default: break
                            }
                            
                            if let url = product.css("a").first {
                                let realUrl = "http://smartsw.ssu.ac.kr\(url["href"] ?? "")"
                                urlList.append(realUrl)
                            }
                            
                            index += 1
                        }
                    } catch let error {
                        print("Error : \(error)")
                    }
                }
                
                index = 0
                for _ in authorList {
                    let noticeItem = Notice(author: authorList[index], title: titleList[index], url: urlList[index], date: dateStringList[index], isNotice: false)
                    noticeList.append(noticeItem)
                    index += 1
                }
                
                completion(noticeList)
            case .failure(_):
                print("Error message:\(String(describing: response.error))")
                break
            }
        })
    }
    
}

extension String{
    func getArrayAfterRegex(regex: String) -> [String] {
        
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: self,
                                        range: NSRange(self.startIndex..., in: self))
            return results.map {
                String(self[Range($0.range, in: self)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    func isNumeric() -> Bool {
        return Double(self) != nil
    }
}

