//
//  NoticeSoongsil.swift
//  SoongsilNotice
//
//  Created by TaeinKim on 2019/11/19.
//  Copyright © 2019 TaeinKim. All rights reserved.
//

import Foundation
import Kanna
import Alamofire

class NoticeSoongsil {
    static var noticeList = [Notice]()
    static var authorList = [String]()
    static var titleList  = [String]()
    static var pageStringList = [String]()
    static var dateStringList = [String]()
    static var isNoticeList = [Bool]()
    static var urlList    = [String]()
    static var attachmentCheckList = [Bool]()
    
    static func cleanList() {
        noticeList.removeAll()
        authorList.removeAll()
        titleList.removeAll()
        pageStringList.removeAll()
        dateStringList.removeAll()
        isNoticeList.removeAll()
        urlList.removeAll()
        attachmentCheckList.removeAll()
    }
    
    static func parseDormitoryNotice(page: Int, keyword: String?, completion: @escaping ([Notice]) -> Void) {
        let requestURL = NoticeRequestURL.SSU_Dormitory(page: page, keyword: keyword)
        
        self.cleanList()
        
        Alamofire.request(requestURL).responseData { response in
            switch(response.result) {
            case .success(_):
                guard let data = response.data else { return }
                let responseString = NSString(data: data, encoding:CFStringConvertEncodingToNSStringEncoding(0x0422))
                
                do {
                    let doc = try HTML(html: responseString as String? ?? "", encoding: .utf8)
                    if let product = doc.css("table[frame='hsides']").first {
                        for (index, tr) in product.css("tr").enumerated() {
                            if index > 1 {
//                                print("...tr==>\(tr.toHTML)")
                                for (index, td) in tr.css("td").enumerated() {
//                                    print("...td==>\(td.css("font").first?.text)...\(td.text)")
                                    switch index {
                                    case 1:
                                        // Badge
                                        if td.css("font").first != nil {
                                            self.isNoticeList.append(true)
                                        } else {
                                            self.isNoticeList.append(false)
                                        }
                                        
                                        // Title
                                        self.titleList.append(td.text ?? "")
                                        
                                        // URL
                                        let urlScript = td.css("a").first?["href"] ?? ""
                                        let boardNo = urlScript.getArrayAfterRegex(regex: "['](.*?)[']")[0].replacingOccurrences(of: "'", with: "")
                                        let no = urlScript.getArrayAfterRegex(regex: "['](.*?)[']")[1].replacingOccurrences(of: "'", with: "")
                                        
                                        let detailURL = "https://ssudorm.ssu.ac.kr:444/SShostel/mall_main.php?viewform=B0001_noticeboard_view&formpath=&board_type=&next=0&board_no=\(boardNo)&no=\(no)"
                                        
                                        self.urlList.append(detailURL)
                                        print("detailURL : \(detailURL)")
                                        
                                        // Attachment
                                        if (td.css("img").first?["src"] ?? "").contains("ldimg052.gif") {
                                            attachmentCheckList.append(true)
                                        } else {
                                            attachmentCheckList.append(false)
                                        }
                                    case 2:
                                        // Author
                                        self.authorList.append(td.text ?? "")
                                    case 4:
                                        // Date
                                        self.dateStringList.append(td.text ?? "")
                                    default:
                                        break
                                    }
                                }
                            }
                        }
                    }
                    
                    for (index, _) in titleList.enumerated() {
                        noticeList.append(Notice(author: authorList[index], title: titleList[index], url: urlList[index], date: dateStringList[index], isNotice: isNoticeList[index], hasAttachment: attachmentCheckList[index]))
                    }
                    
                    completion(noticeList)
                } catch let error {
                    print("Error : \(error)")
                }
            case .failure(_):
                print("Error message:\(String(describing: response.result.error))")
                break
            }
        }
    }
    
    static func parseSchoolNotice(page: Int, keyword: String?, completion: @escaping ([Notice]) -> Void) {
        var noticeList = [Notice]()
        var authorList = [String]()
        var titleList  = [String]()
        var urlList    = [String]()
        var dateStringList = [String]()
        
        let keywordSearch = keyword?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let requestURL = NoticeRequestURL.SSU_Catch(page: page, keyword: keywordSearch)
        
        var index = 0
        Alamofire.request(requestURL).responseString { response in
            switch(response.result) {
            case .success(_):
                guard let data = response.data else { return }
                let utf8Text = String(data: data, encoding: .utf8) ?? String(decoding: data, as: UTF8.self)
                do {
                    let doc = try HTML(html: utf8Text, encoding: .utf8)
                    var currentDate = ""
                    for item in doc.css("ul[class^='notice-lists'] li") {
                        if item.className == "start" {
                            currentDate = ""
                            for date in item.css("div[class^='h2 text-info font-weight-bold']") {
                                if currentDate.isEmpty {
                                    currentDate.append((date.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines))
                                } else {
                                    currentDate.append(".\(date.text ?? "")".trimmingCharacters(in: .whitespacesAndNewlines))
                                }
                            }
                        }
                        
                        if item.className != "notice_head" {
                            titleList.append(item.css("span[class^='d-inline-blcok m-pt-5']").first?.text ?? "")
                            dateStringList.append(currentDate)
                            print(item.css("div[class^='notice_col3-lg-8'] a").first?["href"] ?? "")
                            urlList.append(item.css("div[class^='notice_col3'] a").first?["href"] ?? "")
                            authorList.append(item.css("div[class^='col-lg-2 m-text-right']").first?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")
                        }
                    }
                    
                    for _ in titleList {
                        noticeList.append(Notice(author: authorList[index], title: titleList[index], url: urlList[index], date: dateStringList[index], isNotice: false, hasAttachment: false))
                        index += 1
                    }
                    
                    completion(noticeList)
                } catch let error {
                    print("Error : \(error)")
                }
            case .failure(_):
                print("Error message:\(String(describing: response.result.error))")
                break
            }
        }
    }
}

