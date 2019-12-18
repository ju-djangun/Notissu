//
//  NoticeIT.swift
//  SoongsilNotice
//
//  Created by TaeinKim on 2019/11/05.
//  Copyright © 2019 TaeinKim. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import Kanna

class NoticeIT {
    static func parseListComputer(page: Int, keyword: String?, completion: @escaping ([Notice]) -> Void) {
        var noticeList = [Notice]()
        var authorList = [String]()
        var titleList  = [String]()
        var pageStringList = [String]()
        var dateStringList = [String]()
        var isNoticeList = [Bool]()
        var requestURL = ""
        let noticeUrl = "http://cse.ssu.ac.kr/03_sub/01_sub.htm?page=\(page)&key=&keyfield=&category=&bbs_code=Ti_BBS_1"
        
        var index = 0
        
        if keyword != nil {
            let keywordSearch = keyword!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            let searchUrl = "http://cse.ssu.ac.kr/03_sub/01_sub.htm?page=\(page)&key=\(keywordSearch!)&keyfield=subject&category=&bbs_code=Ti_BBS_1"
            
            requestURL = searchUrl
        } else {
            requestURL = noticeUrl
        }
        
        print(requestURL)
        
        Alamofire.request(requestURL).responseString(encoding: .utf8) { response in
            switch(response.result) {
            case .success(_):
                if let data = response.result.value {
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
                                        let noticeTitle = product.content ?? ""
                                        //                                    print("product1 : \(noticeTitle)")
                                        //                                    print("product1 : \(noticeAuthor)")
                                        //                                    print("product1 : \(noticeDate)")
                                        //                                    print("product1 : \(pageString)")
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
                            let noticeItem = Notice(author: authorList[index], title: titleList[index], url: pageStringList[index], date: dateStringList[index], isNotice: isNoticeList[index])
                            
                            noticeList.append(noticeItem)
                            index += 1
                        }
                        
                        completion(noticeList)
                    } catch let error {
                        print("Error : \(error)")
                    }
                }
            case .failure(_):
                print("Error message:\(String(describing: response.result.error))")
                break
            }
        }
    }
    
    static func parseListMedia(page: Int, keyword: String?, completion: @escaping ([Notice]) -> Void) {
        var noticeList = [Notice]()
        var authorList = [String]()
        var titleList  = [String]()
        var urlList    = [String]()
        var dateStringList = [String]()
        var isNoticeList = [Bool]()
        var requestURL = ""
        let noticeUrl = "http://media.ssu.ac.kr/sub.php?code=XxH00AXY&mode=&category=1&searchType=&search=&orderType=&orderBy=&page=\(page)"
        
        if keyword != nil {
            let keywordSearch = keyword!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            let searchUrl = "http://media.ssu.ac.kr/sub.php?code=XxH00AXY&mode=&category=1&searchType=title&search=\(keywordSearch!)&orderType=&orderBy=&page=\(page)"
            
            requestURL = searchUrl
        } else {
            requestURL = noticeUrl
        }
        
        var index = 0
        Alamofire.request(requestURL).responseString { response in
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
                print("Error message:\(String(describing: response.result.error))")
                break
            }
        }
    }
    
    static func parseListSoftware(page: Int, keyword: String?, completion: @escaping ([Notice]) -> Void) {
        let noticeUrl = "https://sw.ssu.ac.kr/bbs/board.php?bo_table=sub6_1&page=\(page)"
        var noticeList = [Notice]()
        var authorList = [String]()
        var titleList  = [String]()
        var urlList = [String]()
        var dateStringList = [String]()
        var isNoticeList = [Bool]()
        var index = 0
        
        var requestURL = ""
        
        if keyword != nil {
            let keywordSearch = keyword!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            let searchUrl = "https://sw.ssu.ac.kr/bbs/board.php?bo_table=sub6_1&sca=&stx=\(keywordSearch ?? "")&sop=and&page=\(page)"
            requestURL = searchUrl
        } else {
            requestURL = noticeUrl
        }
        
        Alamofire.request(requestURL).responseString(encoding: .utf8) { response in
            switch(response.result) {
            case .success(_):
                if let data = response.result.value {
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
                        let noticeItem = Notice(author: authorList[index], title: titleList[index], url: urlList[index], date: dateStringList[index], isNotice: isNoticeList[index])
                        
                        noticeList.append(noticeItem)
                        index += 1
                    }
                    
                    completion(noticeList)
                }
            case .failure(_):
                print("Error message:\(String(describing: response.result.error))")
                break
            }
        }
    }
    
    static func parseListElectric(page: Int, keyword: String?, completion: @escaping ([Notice]) -> Void) {
        let noticeUrl = "http://infocom.ssu.ac.kr/rb/?c=2/38&p=\(page)"
        var noticeList = [Notice]()
        var authorList = [String]()
        var titleList  = [String]()
        var urlList = [String]()
        var dateStringList = [String]()
        var isNoticeList = [Bool]()
        var index = 0
        var requestURL = ""
        
        if keyword != nil {
            let keywordSearch = keyword!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            let searchUrl = "http://infocom.ssu.ac.kr/rb/?c=2/38&where=subject%7Ctag&keyword=\(keywordSearch ?? "")&p=\(page)"
            requestURL = searchUrl
        } else {
            requestURL = noticeUrl
        }
        
        Alamofire.request(requestURL).responseString { response in
            //            print("\(response.result.isSuccess)")
            //            print(response.result.value ?? "")
            switch(response.result) {
            case .success(_):
                if let data = response.result.value {
                    print(data)
                    do {
                        let doc = try HTML(html: data, encoding: .utf8)
                        for product in doc.css("div[class^='list']") {
                            let url = "http://infocom.ssu.ac.kr\((product.toHTML?.getArrayAfterRegex(regex: "(?=')\\S+(?=')")[0].split(separator: "'")[0] ?? "")!.replacingOccurrences(of: "&amp;", with: "&"))"
                            
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
                    let noticeItem = Notice(author: authorList[index], title: titleList[index], url: urlList[index], date: dateStringList[index], isNotice: isNoticeList[index])
                    noticeList.append(noticeItem)
                    index += 1
                }
                
                completion(noticeList)
            case .failure(_):
                print("Error message:\(String(describing: response.result.error))")
                break
            }
        }
    }
    
    static func parseListSmartSystem(page: Int, keyword: String?, completion: @escaping ([Notice]) -> Void) {
        let noticeUrl = "http://smartsw.ssu.ac.kr/board/notice/\(page)"
        var noticeList = [Notice]()
        var authorList = [String]()
        var titleList  = [String]()
        var urlList = [String]()
        var dateStringList = [String]()
        var index = 0
        var requestURL = ""
        
        if keyword != nil {
            let keywordSearch = keyword!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            let searchUrl = "http://smartsw.ssu.ac.kr/board/notice/\(page)?search=\(keywordSearch ?? "")"
            requestURL = searchUrl
        } else {
            requestURL = noticeUrl
        }
        
        Alamofire.request(requestURL).responseString(encoding: .utf8) { response in
            switch(response.result) {
            case .success(_):
                if let data = response.result.value {
                    do {
                        let doc = try HTML(html: data, encoding: .utf8)
                        
                        for product in doc.css("table[class='ui celled padded table'] tbody td") {
                            let content = (product.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
                            switch(index % 3) {
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
                print("Error message:\(String(describing: response.result.error))")
                break
            }
        }
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
