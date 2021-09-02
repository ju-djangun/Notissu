//
//  noticeConvergence.swift
//  Notissu
//
//  Copyright © 2019 Notissu. All rights reserved.
//

import Foundation
import Kanna
import Alamofire

class NoticeConvergence: NoticeBaseModel {
    static func parseListConvergence(page: Int, keyword: String?, completion: @escaping ([Notice]) -> Void) {
        var index = 0
        
        let keywordSearch = keyword?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let requestURL = NoticeRequestURL.convergenceURL(page: page, keyword: keywordSearch)
        
        self.cleanList()
        
        AF.request(requestURL).responseString(encoding: .utf8, completionHandler: { response in
            switch(response.result) {
            case .success(_):
                if let data = response.value {
                    do {
                        let doc = try HTML(html: data, encoding: .utf8)
                        index = 0
                        
                        let product = doc.css("table[class='bbs-list']").first!
                        
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
                                var hasAttachment = false
                                let imgHTML = item.toHTML ?? ""
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
                        
                        
                        for product in doc.css("td[class='left'] a") {
                            print("\(product["href"] ?? "")")
                            urlList.append("\(product["href"] ?? "")")
                        }
                    } catch let error {
                        print("Error : \(error)")
                    }
                    
                    index = 0
                    for _ in urlList {
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
}

