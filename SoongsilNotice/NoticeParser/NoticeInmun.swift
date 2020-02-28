//
//  NoticeInmun.swift
//  SoongsilNotice
//
//  Created by TaeinKim on 2019/11/08.
//  Copyright © 2019 TaeinKim. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import Kanna

class NoticeInmun {
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
    
    static func parseListKorean(page: Int, keyword: String?, completion: @escaping ([Notice]) -> Void) {
        var index = 0
        
        let keywordSearch = keyword?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let requestURL = NoticeRequestURL.korlanURL(page: page, keyword: keywordSearch)
        
        self.cleanList()
        
        Alamofire.request(requestURL).responseString(encoding: .utf8) { response in
            switch(response.result) {
            case .success(_):
                if let data = response.result.value {
                    do {
                        let doc = try HTML(html: data, encoding: .utf8)
                        for product in doc.css("table[class='bbs-list'] td") {
                            //print("***")
                            let content = product.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                            print(content)
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
                            //print(product["href"] ?? "")
                            urlList.append(product["href"] ?? "")
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
                print("Error message:\(String(describing: response.result.error))")
                break
            }
        }
    }
    
    static func parseListEnglish(page: Int, keyword: String?, completion: @escaping ([Notice]) -> Void) {
        var index = 0
        
        let keywordSearch = keyword?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let requestURL = NoticeRequestURL.englanURL(page: page, keyword: keywordSearch)
        
        self.cleanList()
        
        Alamofire.request(requestURL).responseString(encoding: .utf8) { response in
            switch(response.result) {
            case .success(_):
                if let data = response.result.value {
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
                                    let imgHTML = product.toHTML ?? ""
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
                        let noticeItem = Notice(author: authorList[index], title: titleList[index], url: urlList[index], date: dateStringList[index], isNotice: isNoticeList[index], hasAttachment: attachmentCheckList[index])
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
    
    static func parseListGerman(page: Int, keyword: String?, completion: @escaping ([Notice]) -> Void) {
        var index = 0
        
        let keywordSearch = keyword?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let requestURL = NoticeRequestURL.germanURL(page: page, keyword: keywordSearch)
        
        self.cleanList()
        
        Alamofire.request(requestURL).responseString(encoding: .utf8) { response in
            switch(response.result) {
            case .success(_):
                if let data = response.result.value {
                    do {
                        let doc = try HTML(html: data, encoding: .utf8)
                        for product in doc.css("table[class='bbs-list'] td") {
                            //print("***")
                            let content = product.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                            print(content)
                            switch (index % 3) {
                            case 0:
                                // Title
                                titleList.append(content)
                                break
                            case 1:
                                // Date
                                dateStringList.append(content)
                                break
                            case 2: break
                            default: break
                            }
                            index += 1
                        }
                        
                        for product in doc.css("table[class='bbs-list'] a") {
                            //print(product["href"] ?? "")
                            urlList.append(product["href"] ?? "")
                        }
                    } catch let error {
                        print("Error : \(error)")
                    }
                    
                    index = 0
                    for _ in urlList {
                        let noticeItem = Notice(author: "", title: titleList[index], url: urlList[index], date: dateStringList[index], isNotice: false)
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
    
    static func parseListFrench(page: Int, keyword: String?, completion: @escaping ([Notice]) -> Void) {
        var index = 0
        
        let keywordSearch = keyword?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let requestURL = NoticeRequestURL.frenchURL(page: page, keyword: keywordSearch)
        
        self.cleanList()
        
        Alamofire.request(requestURL).responseString(encoding: .utf8) { response in
            switch(response.result) {
            case .success(_):
                if let data = response.result.value {
                    do {
                        let doc = try HTML(html: data, encoding: .utf8)
                        for product in doc.css("table[class='bbs-list'] td") {
                            //print("***")
                            let content = product.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                            print(content)
                            switch (index % 5) {
                            case 0: break
                            case 1:
                                // Title
                                titleList.append(content)
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
                        
                        for product in doc.css("table[class='bbs-list'] a") {
                            //print(product["href"] ?? "")
                            urlList.append(product["href"] ?? "")
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
                print("Error message:\(String(describing: response.result.error))")
                break
            }
        }
    }
    
    static func parseListChinese(page: Int, keyword: String?, completion: @escaping ([Notice]) -> Void) {
        var index = 0
        
        let keywordSearch = keyword?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let requestURL = NoticeRequestURL.chineseURL(page: page, keyword: keywordSearch)
        
        self.cleanList()
        
        Alamofire.request(requestURL).responseString(encoding: .utf8) { response in
            switch(response.result) {
            case .success(_):
                if let data = response.result.value {
                    do {
                        let doc = try HTML(html: data, encoding: .utf8)
                        for product in doc.css("table[class='bbs-list'] td") {
                            //print("***")
                            let content = product.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                            print(content)
                            switch (index % 5) {
                            case 0:
                                if product.innerHTML?.contains("img") ?? false {
                                    // isNotice
                                    if page < 2 {
                                        isNoticeList.append(true)
                                    } else {
                                        isNoticeList.append(false)
                                    }
                                } else {
                                    isNoticeList.append(false)
                                }
                                break
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
                            //print(product["href"] ?? "")
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
                print("Error message:\(String(describing: response.result.error))")
                break
            }
        }
    }
    
    static func parseListJapanese(page: Int, keyword: String?, completion: @escaping ([Notice]) -> Void) {
        var index = 0
        
        let keywordSearch = keyword?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let requestURL = NoticeRequestURL.japaneseURL(page: page, keyword: keywordSearch)
        
        self.cleanList()
        
        Alamofire.request(requestURL).responseString(encoding: .utf8) { response in
            switch(response.result) {
            case .success(_):
                if let data = response.result.value {
                    do {
                        let doc = try HTML(html: data, encoding: .utf8)
                        for product in doc.css("table[class='bbs-list'] td") {
                            //print("***")
                            let content = product.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                            print(content)
                            switch (index % 6) {
                            case 0:
                                if product.innerHTML?.contains("img") ?? false {
                                    // isNotice
                                    if page < 2 {
                                        isNoticeList.append(true)
                                    } else {
                                        isNoticeList.append(false)
                                    }
                                } else {
                                    isNoticeList.append(false)
                                }
                                break
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
                            //print(product["href"] ?? "")
                            urlList.append(product["href"] ?? "")
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
                print("Error message:\(String(describing: response.result.error))")
                break
            }
        }
    }
    
    static func parseListPhilo(page: Int, keyword: String?, completion: @escaping ([Notice]) -> Void) {
        var index = 0
        
        let keywordSearch = keyword?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let requestURL = NoticeRequestURL.philoURL(page: page, keyword: keywordSearch)
        
        self.cleanList()
        
        Alamofire.request(requestURL).responseString(encoding: .utf8) { response in
            switch(response.result) {
            case .success(_):
                if let data = response.result.value {
                    do {
                        let doc = try HTML(html: data, encoding: .utf8)
                        for product in doc.css("table[class='bbs-list'] td") {
                            //print("***")
                            let content = product.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                            print(content)
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
                            //print(product["href"] ?? "")
                            urlList.append(product["href"] ?? "")
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
                print("Error message:\(String(describing: response.result.error))")
                break
            }
        }
    }
    
    static func parseListHistory(page: Int, keyword: String?, completion: @escaping ([Notice]) -> Void) {
        var index = 0
        
        let keywordSearch = keyword?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let requestURL = NoticeRequestURL.historyURL(page: page, keyword: keywordSearch)
        
        self.cleanList()
        
        Alamofire.request(requestURL).responseString(encoding: .utf8) { response in
            switch(response.result) {
            case .success(_):
                if let data = response.result.value {
                    do {
                        let doc = try HTML(html: data, encoding: .utf8)
                        for product in doc.css("table[class='bbs-list'] td") {
                            //print("***")
                            let content = product.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                            print(content)
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
                            //print(product["href"] ?? "")
                            urlList.append(product["href"] ?? "")
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
                print("Error message:\(String(describing: response.result.error))")
                break
            }
        }
    }
}
