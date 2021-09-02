//
//  NoticeSocial.swift
//  Notissu
//
//  Copyright © 2019 Notissu. All rights reserved.
//

import Foundation
import Alamofire
import UIKit
import Kanna

class NoticeSocial: NoticeBaseModel {
    static func parseListWelfare(page: Int, keyword: String?, completion: @escaping ([Notice]) -> Void) {
        var index = 0
        
        let keywordSearch = keyword?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let requestURL = NoticeRequestURL.socialWelfare(page: page, keyword: keywordSearch)
        
        self.cleanList()
        
        AF.request(requestURL).responseString(encoding: .utf8, completionHandler: { response in
            switch(response.result) {
            case .success(_):
                if let data = response.value {
                    do {
                        let doc = try HTML(html: data, encoding: .utf8)
                        for product in doc.css("table[class='t_list hover']") {
                            var isAppendNotice = false
                            var title = ""
                            var date = ""
                            var url = ""
                            var isNotice = false
                            var hasAttachment = false
                            
                            for (index, td) in product.css("td").enumerated() {
                                let content = td.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                                
                                switch (index % 5) {
                                case 0:
                                    isAppendNotice = false
                                    if td.innerHTML?.contains("공지") ?? false {
                                        isNotice = true
                                        if page < 2 {
                                            isAppendNotice = true
                                        }
                                    } else {
                                        isNotice = false
                                        isAppendNotice = true
                                    }
                                    
                                    if isAppendNotice {
                                        isNoticeList.append(isNotice)
                                    }
                                case 1:
                                    title = content
                                    url = td.css("a").first?["href"] ?? ""
                                    
                                    if isAppendNotice {
                                        titleList.append(title)
                                        urlList.append(url)
                                    }
                                case 2:
                                    hasAttachment = false
                                    if td.innerHTML?.contains("파일") ?? false {
                                        hasAttachment = true
                                    }
                                    
                                    if isAppendNotice {
                                        attachmentCheckList.append(hasAttachment)
                                    }
                                case 3:
                                    date = content
                                    if isAppendNotice {
                                        dateStringList.append(date)
                                    }
                                default: break
                                }
                            }
                        }
                    } catch let error {
                        print("Error : \(error)")
                    }
                    
                    index = 0
                    for _ in urlList {
                        let noticeItem = Notice(author: "", title: titleList[index], url: urlList[index], date: dateStringList[index], isNotice: isNoticeList[index], hasAttachment: attachmentCheckList[index])
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
    
    static func parseListAdministration(page: Int, keyword: String?, completion: @escaping ([Notice]) -> Void) {
        var index = 0
        
        let keywordSearch = keyword?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let requestURL = NoticeRequestURL.socialAdministration(page: page, keyword: keywordSearch)
        
        self.cleanList()
        
        AF.request(requestURL).responseString(encoding: .utf8, completionHandler: { response in
            switch(response.result) {
            case .success(_):
                if let data = response.value {
                    do {
                        let doc = try HTML(html: data, encoding: .utf8)
                        for product in doc.css("div[class='table_wrap baord_table'] td") {
                            //print("***")
                            let content = product.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                            switch (index % 5) {
                            case 0:
                                isNoticeList.append(!(product.text ?? "").isNumeric())
                                break
                            case 1:
                                // Title
                                titleList.append(content)
                                break
                            case 2:
                                if content.isEmpty {
                                    attachmentCheckList.append(false)
                                } else {
                                    attachmentCheckList.append(true)
                                }
                                break
                            case 3:
                                // Date
                                dateStringList.append(content)
                                break
                            case 4: break
                            default: break
                            }
                            index += 1
                        }
                        
                        for product in doc.css("td[class='title'] a") {
                            print(product["href"] ?? "")
                            urlList.append(product["href"] ?? "")
                        }
                    } catch let error {
                        print("Error : \(error)")
                    }
                    
                    index = 0
                    for _ in urlList {
                        let noticeItem = Notice(author: "", title: titleList[index], url: urlList[index], date: dateStringList[index], isNotice: isNoticeList[index], hasAttachment: attachmentCheckList[index])
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
    
    static func parseListSociology(page: Int, keyword: String?, completion: @escaping ([Notice]) -> Void) {
        var index = 0
        let offset =  (page - 1) * 10
        let keywordSearch = keyword?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let requestURL = NoticeRequestURL.socialSociology(offset: offset, keyword: keywordSearch)
        
        self.cleanList()
        
        AF.request(requestURL).responseString(encoding: .utf8, completionHandler: { response in
            switch(response.result) {
            case .success(_):
                if let data = response.value {
                    do {
                        let doc = try HTML(html: data, encoding: .utf8)
                        for product in doc.css("div[class='board_list'] td") {
                            //print("***")
                            let content = product.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                            print(content)
                            switch (index % 6) {
                            case 0: break
                            case 1:
                                break
                            case 2:
                                // Title
                                titleList.append(content)
                                break
                            case 3:
                                // Author
                                authorList.append(content)
                                break
                            case 4:
                                // Date
                                dateStringList.append(content)
                                break
                            case 5: break
                            default: break
                            }
                            index += 1
                        }
                        
                        for product in doc.css("td[class='subject'] a") {
                            var url = "http://inso.ssu.ac.kr\(product["href"] ?? "")"
                            url = url.replacingOccurrences(of: "학과공지", with: "")
                            print(url)
                            urlList.append(url)
                        }
                    } catch let error {
                        print("Error : \(error)")
                    }
                    
                    index = 0
                    for _ in urlList {
                        let noticeItem = Notice(author: authorList[index], title: titleList[index], url: urlList[index], date: dateStringList[index], isNotice: false)
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
    
    static func parseListJournalism(page: Int, keyword: String?, completion: @escaping ([Notice]) -> Void) {
        var index = 0
        
        let keywordSearch = keyword?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let requestURL = NoticeRequestURL.socialJournalism(page: page, keyword: keywordSearch)
        
        self.cleanList()
        
        AF.request(requestURL).responseString(encoding: .utf8, completionHandler: { response in
            switch(response.result) {
            case .success(_):
                if let data = response.value {
                    do {
                        print("after request")
                        let doc = try HTML(html: data, encoding: .utf8)
                        index = 0
                        
                        let product = doc.css("table[class='bbs-list']").first!
                        
                        if page > 1 {
                            for item in product.css("tbody tr:not(.trNotice) td") {
                                //print("***")
                                let content = item.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                                print(content)
                                switch (index % 5) {
                                case 0:
                                    isNoticeList.append(false)
                                    // Title
                                    titleList.append(content)
                                    break
                                case 1:
                                    // Attachment
                                    var hasAttachment = false
                                    let imgHTML = item.toHTML ?? ""
                                    if imgHTML.contains("ico_file.gif") {
                                        hasAttachment = true
                                    }
                                    attachmentCheckList.append(hasAttachment)
                                    break
                                case 2:
                                    // Author
                                    authorList.append(content)
                                    break
                                case 3:
                                    // Date
                                    dateStringList.append(content)
                                    break
                                case 4: break
                                default: break
                                }
                                index += 1
                            }
                        } else {
                            for item in product.css("tbody tr td") {
                                //print("***")
                                let content = item.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                                print(content)
                                switch (index % 5) {
                                case 0:
                                    isNoticeList.append(item.className == "trNotice")
                                    // Title
                                    titleList.append(content)
                                    break
                                case 1:
                                    // Attachment
                                    var hasAttachment = false
                                    let imgHTML = item.toHTML ?? ""
                                    if imgHTML.contains("ico_file.gif") {
                                        hasAttachment = true
                                    }
                                    attachmentCheckList.append(hasAttachment)
                                    break
                                case 2:
                                    // Author
                                    authorList.append(content)
                                    break
                                case 3:
                                    // Date
                                    dateStringList.append(content)
                                    break
                                case 4: break
                                default: break
                                }
                                index += 1
                            }
                        }
                        
                        for product in doc.css("td[class='left'] a") {
                            print("\(product["href"] ?? "")")
                            urlList.append("\(product["href"] ?? "")")
                        }
                    } catch let error {
                        print("Error : \(error)")
                    }
                    
                    index = 0
                    for _ in urlList {
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
    
    static func parseListLifeLong(page: Int, keyword: String?, completion: @escaping ([Notice]) -> Void) {
        var index = 0
        
        let keywordSearch = keyword?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let requestURL = NoticeRequestURL.socialLifelong(page: page, keyword: keywordSearch)
        
        self.cleanList()
        
        AF.request(requestURL).responseString(encoding: .utf8, completionHandler: { response in
            switch(response.result) {
            case .success(_):
                if let data = response.value {
                    do {
                        var boldCount = 0
                        let doc = try HTML(html: data, encoding: .utf8)
                        var isAdd = false
                        for product in doc.css("table[class='board_list'] td") {
                            let content = product.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                            print(content)
                            switch (index % 5) {
                            case 0:
                                if page > 1 && !content.isNumeric() {
                                    isAdd = false
                                    boldCount += 1
                                } else {
                                    isAdd = true
                                }
                                break
                            case 1:
                                // Title
                                if isAdd {
                                    titleList.append(content)
                                    
                                    // Attachment
                                    var hasAttachment = false
                                    if let innerProduct = product.innerHTML {
                                        if innerProduct.contains("icon_file.gif") {
                                            hasAttachment = true
                                        }
                                    }
                                    attachmentCheckList.append(hasAttachment)
                                }
                                break
                            case 2:
                                // Author
                                if isAdd {
                                    authorList.append(content)
                                }
                                break
                            case 3:
                                // Date
                                if isAdd {
                                    dateStringList.append(content)
                                }
                                break
                            case 4: break
                            default: break
                            }
                            
                            print("index : \(index) / isAdd : \(isAdd)")
                            index += 1
                        }
                        
                        print("bold Count : \(boldCount)")
                        
                        index = 0
                        for product in doc.css("td[class='subject'] a") {
                            var url = "http://lifelongedu.ssu.ac.kr\(product["href"] ?? "")"
                            url = url.replacingOccurrences(of: "..", with: "")
                            print(url)
                            if index < boldCount {
                                if page < 2 {
                                    urlList.append(url)
                                }
                            } else {
                                urlList.append(url)
                            }
                            
                            index += 1
                        }
                    } catch let error {
                        print("Error : \(error)")
                    }
                    
                    index = 0
                    for _ in urlList {
                        print(authorList[index])
                        print(titleList[index])
                        print(urlList[index])
                        print(dateStringList[index])
                        
                        let noticeItem = Notice(author: authorList[index], title: titleList[index], url: urlList[index], date: dateStringList[index], isNotice: false, hasAttachment: attachmentCheckList[index])
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
    
    static func parseListPolitical(page: Int, keyword: String?, completion: @escaping ([Notice]) -> Void) {
        var index = 0
        
        let keywordSearch = keyword?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let requestURL = NoticeRequestURL.socialPolitical(page: page, keyword: keywordSearch)
        
        self.cleanList()
        
        AF.request(requestURL).responseString(encoding: .utf8, completionHandler: { response in
            switch(response.result) {
            case .success(_):
                if let data = response.value {
                    do {
                        print("after request")
                        let doc = try HTML(html: data, encoding: .utf8)
                        index = 0
                        
                        let product = doc.css("table[class='bbs-list']").first!
                        
                        if page > 1 {
                            for item in product.css("tbody tr:not(.trNotice) td") {
                                //print("***")
                                let content = item.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                                print(content)
                                switch (index % 6) {
                                case 0: break
                                case 1:
                                    // Title
                                    titleList.append(content)
                                    break
                                case 2: break
                                case 3:
                                    // Author
                                    authorList.append(content)
                                    break
                                case 4:
                                    // Date
                                    dateStringList.append(content)
                                    break
                                case 5: break
                                default: break
                                }
                                index += 1
                            }
                        } else {
                            for item in product.css("tbody tr td") {
                                //print("***")
                                let content = item.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                                print(content)
                                switch (index % 6) {
                                case 0: break
                                case 1:
                                    // Title
                                    titleList.append(content)
                                    break
                                case 2:
                                    break
                                case 3:
                                    // Author
                                    authorList.append(content)
                                    break
                                case 4:
                                    // Date
                                    dateStringList.append(content)
                                    break
                                case 5: break
                                default: break
                                }
                                index += 1
                            }
                        }
                        
                        if page > 1 {
                            for item in product.css("tbody tr:not(.trNotice) td a") {
                                print("\(item["href"] ?? "")")
                                urlList.append("\(item["href"] ?? "")")
                            }
                        } else {
                            for item in product.css("tbody tr td a") {
                                print("\(item["href"] ?? "")")
                                urlList.append("\(item["href"] ?? "")")
                            }
                        }
                    } catch let error {
                        print("Error : \(error)")
                    }
                    
                    index = 0
                    for _ in urlList {
                        let noticeItem = Notice(author: authorList[index], title: titleList[index], url: urlList[index], date: dateStringList[index], isNotice: false)
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
}
