//
//  NoticeLaw.swift
//  Notissu
//
//  Copyright © 2019 Notissu. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import Kanna

class NoticeLaw: NoticeBaseModel {
    static func parseListLaw(page: Int, keyword: String?, completion: @escaping ([Notice]) -> Void) {
        var index = 0
        
        let keywordSearch = keyword?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let requestURL = NoticeRequestURL.lawURL(page: page, keyword: keywordSearch)
        
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
                            
                            print(product)
                            
                            for (index, td) in product.css("td").enumerated() {
                                let content = td.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                                
                                print(content)
                                
                                switch (index % 5) {
                                case 0:
                                    isAppendNotice = false
                                    if td.content?.contains("공지") ?? false {
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
                                    if td.content?.contains("파일") ?? false {
                                        hasAttachment = true
                                    }
                                    
                                    if isAppendNotice {
                                        attachmentCheckList.append(hasAttachment)
                                    }
                                case 3:
                                    date = content
                                    if isAppendNotice {
                                        authorList.append("")
                                        dateStringList.append(date)
                                    }
                                case 4: break
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
    
//    static func parseListIntlLaw(page: Int, keyword: String?, completion: @escaping ([Notice]) -> Void) {
//        var index = 0
//        
//        let keywordSearch = keyword?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
//        let requestURL = NoticeRequestURL.intlLawURL(page: page, keyword: keywordSearch)
//        
//        self.cleanList()
//        
//        AF.request(requestURL).responseString(encoding: .utf8, completionHandler: { response in
//            switch(response.result) {
//            case .success(_):
//                if let data = response.value {
//                    do {
//                        let doc = try HTML(html: data, encoding: .utf8)
//                        for product in doc.css("div[class='board-list-body']") {
//                            var isAppendNotice = false
//                            var title = ""
//                            var date = ""
//                            var url = ""
//                            var isNotice = false
//                            var hasAttachment = false
//                            
//                            for (index, td) in product.css("p").enumerated() {
//                                let content = td.text!.trimmingCharacters(in: .whitespacesAndNewlines)
//                                
//                                switch (index % 4) {
//                                case 0:
//                                    isAppendNotice = false
//                                    if (td.text ?? "" == " ") {
//                                        isNotice = true
//                                        if page < 2 {
//                                            isAppendNotice = true
//                                        }
//                                    } else {
//                                        isNotice = false
//                                        isAppendNotice = true
//                                    }
//                                    
//                                    if isAppendNotice {
//                                        isNoticeList.append(isNotice)
//                                    }
//                                case 1:
//                                    title = content
//                                    url = td.css("a").first?["href"] ?? ""
//                                    
//                                    if isAppendNotice {
//                                        titleList.append(title)
//                                        urlList.append(url)
//                                    }
//                                case 2:
//                                    hasAttachment = td.css("i[class='ico-file']").count > 0
//                                    
//                                    if isAppendNotice {
//                                        attachmentCheckList.append(hasAttachment)
//                                    }
//                                case 3:
//                                    date = content
//                                    if isAppendNotice {
//                                        authorList.append("")
//                                        dateStringList.append(date)
//                                    }
//                                default: break
//                                }
//                            }
//                        }
//                    } catch let error {
//                        print("Error : \(error)")
//                    }
//                    
//                    index = 0
//                    for _ in urlList {
//                        let noticeItem = Notice(author: authorList[index], title: titleList[index], url: urlList[index], date: dateStringList[index], isNotice: isNoticeList[index], hasAttachment: attachmentCheckList[index])
//                        noticeList.append(noticeItem)
//                        index += 1
//                    }
//                    
//                    completion(noticeList)
//                }
//            case .failure(_):
//                print("Error message:\(String(describing: response.error))")
//                break
//            }
//        })
//    }
}
