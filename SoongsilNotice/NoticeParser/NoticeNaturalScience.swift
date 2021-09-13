//
//  NoticeNaturalScience.swift
//  Notissu
//
//  Copyright © 2019 Notissu. All rights reserved.
//

import UIKit
import Alamofire
import Kanna

class NoticeNaturalScience: NoticeBaseModel {
    static func parseListMath(page: Int, keyword: String?, completion: @escaping ([Notice]) -> Void) {
        var index = 0
        
        let keywordSearch = keyword?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let requestURL = NoticeRequestURL.naturalMathURL(page: page, keyword: keywordSearch)
        
        self.cleanList()
        
        AF.request(requestURL).responseString(encoding: .utf8, completionHandler: { response in
            switch(response.result) {
            case .success(_):
                if let data = response.value {
                    do {
                        let doc = try HTML(html: data, encoding: .utf8)
                        for product in doc.css("table[class='bbs-list'] td") {
                            let content = product.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                            switch (index % 5) {
                            case 0: break
                            case 1:
                                // Title
                                titleList.append(content)
                                break
                            case 2:
                                var hasAttachment = false
                                let imgHTML = product.toHTML ?? ""
                                if imgHTML.contains("ico_file.gif") {
                                    hasAttachment = true
                                }
                                attachmentCheckList.append(hasAttachment)
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
                        
                        for product in doc.css("table[class='bbs-list'] a") {
                            urlList.append(product["href"] ?? "")
                        }
                    } catch let error {
                        print("Error : \(error)")
                    }
                    
                    index = 0
                    for _ in urlList {
                        let noticeItem = Notice(author: "", title: titleList[index], url: urlList[index], date: dateStringList[index], isNotice: false, hasAttachment: attachmentCheckList[index])
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
    
    static func parseListChemistry(page: Int, keyword: String?, completion: @escaping ([Notice]) -> Void) {
        var index = 0
        
        let keywordSearch = keyword?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let requestURL = NoticeRequestURL.naturalChemistryURL(page: page, keyword: keywordSearch)
        
        self.cleanList()
        
        AF.request(requestURL).responseString(encoding: .utf8, completionHandler: { response in
            switch(response.result) {
            case .success(_):
                if let data = response.value {
                    do {
                        let doc = try HTML(html: data, encoding: .utf8)
                        for product in doc.css("table[class='bbs-list'] td") {
                            let content = product.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                            switch (index % 6) {
                            case 0: break
                            case 1:
                                // Title
                                titleList.append(content)
                                break
                            case 2:
                                var hasAttachment = false
                                let imgHTML = product.toHTML ?? ""
                                if imgHTML.contains("ico_file.gif") {
                                    hasAttachment = true
                                }
                                attachmentCheckList.append(hasAttachment)
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
                        
                        for product in doc.css("table[class='bbs-list'] a") {
                            urlList.append(product["href"] ?? "")
                        }
                    } catch let error {
                        print("Error : \(error)")
                    }
                    
                    index = 0
                    for _ in urlList {
                        let noticeItem = Notice(author: "", title: titleList[index], url: urlList[index], date: dateStringList[index], isNotice: false, hasAttachment: attachmentCheckList[index])
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
    
    static func parseListPhysics(page: Int, keyword: String?, completion: @escaping ([Notice]) -> Void) {
        var index = 0
        
        let keywordSearch = keyword?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let requestURL = NoticeRequestURL.naturalPhysicsURL(page: page, keyword: keywordSearch)
        
        self.cleanList()
        
        AF.request(requestURL).responseString(encoding: .utf8, completionHandler: { response in
            switch(response.result) {
            case .success(_):
                if let data = response.value {
                    do {
                        let doc = try HTML(html: data, encoding: .utf8)
                        for product in doc.css("table[class='bbs-list']") {
                            var isAppendNotice = false
                            var title = ""
                            var author = ""
                            var date = ""
                            var url = ""
                            var isNotice = false
                            var hasAttachment = false
                            
                            for (index, td) in product.css("td").enumerated() {
                                let content = td.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                                
                                switch (index % 6) {
                                case 0:
                                    isAppendNotice = false
                                    if td.innerHTML?.contains("img") ?? false {
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
                                    let imgHTML = td.toHTML ?? ""
                                    if imgHTML.contains("ico_file.gif") {
                                        hasAttachment = true
                                    }
                                    
                                    if isAppendNotice {
                                        attachmentCheckList.append(hasAttachment)
                                    }
                                case 3:
                                    author = content
                                    if isAppendNotice {
                                        authorList.append(author)
                                    }
                                case 4:
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
    
    static func parseListActuarial(page: Int, keyword: String?, completion: @escaping ([Notice]) -> Void) {
        var index = 0
        
        let keywordSearch = keyword?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let requestURL = NoticeRequestURL.naturalActuaryURL(page: page, keyword: keywordSearch)
        
        self.cleanList()
        
        AF.request(requestURL).responseString(encoding: .utf8, completionHandler: { response in
            switch(response.result) {
            case .success(_):
                if let data = response.value {
                    do {
                        let doc = try HTML(html: data, encoding: .utf8)
                        for product in doc.css("div[class='tbl_head01 tbl_wrap'] td") {
                            let content = product.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                            switch (index % 5) {
                            case 0: break
                            case 1:
                                // Title
                                titleList.append(content)
                                
                                // Attachment
                                var hasAttachment = false
                                if let innerProduct = product.innerHTML {
                                    if innerProduct.contains("icon_file.gif") {
                                        hasAttachment = true
                                    }
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
                        
                        for product in doc.css("div[class='tbl_head01 tbl_wrap'] td a") {
                            urlList.append(product["href"] ?? "")
                        }
                    } catch let error {
                        print("Error : \(error)")
                    }
                    
                    index = 0
                    for _ in urlList {
                        let noticeItem = Notice(author: "", title: titleList[index], url: urlList[index], date: dateStringList[index], isNotice: false, hasAttachment: attachmentCheckList[index])
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
    
    static func parseListBiomedical(page: Int, keyword: String?, completion: @escaping ([Notice]) -> Void) {
        var index = 0
        
        let keywordSearch = keyword?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let requestURL = NoticeRequestURL.naturalBioURL(page: page, keyword: keywordSearch)
        
        self.cleanList()
        
        AF.request(requestURL).responseString(encoding: .utf8, completionHandler: { response in
            switch(response.result) {
            case .success(_):
                if let data = response.value {
                    do {
                        let doc = try HTML(html: data, encoding: .utf8)
                        for product in doc.css("table[class='bbs-list'] td") {
                            let content = product.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                            switch (index % 5) {
                            case 0: break
                            case 1:
                                // Title
                                titleList.append(content)
                                break
                            case 2:
                                var hasAttachment = false
                                let imgHTML = product.toHTML ?? ""
                                if imgHTML.contains("ico_file.gif") {
                                    hasAttachment = true
                                }
                                attachmentCheckList.append(hasAttachment)
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
                        
                        for product in doc.css("table[class='bbs-list'] a") {
                            urlList.append(product["href"] ?? "")
                        }
                    } catch let error {
                        print("Error : \(error)")
                    }
                    
                    index = 0
                    for _ in urlList {
                        let noticeItem = Notice(author: "", title: titleList[index], url: urlList[index], date: dateStringList[index], isNotice: false, hasAttachment: attachmentCheckList[index])
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
