//
//  NoticeEngineering.swift
//  SoongsilNotice
//
//  Created by TaeinKim on 2019/11/07.
//  Copyright © 2019 TaeinKim. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import Kanna

class NoticeEngineering {
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
    
    static func parseListMachine(page: Int, keyword: String?, completion: @escaping ([Notice]) -> Void) {
        var index = 0
        
        let keywordSearch = keyword?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let requestURL = NoticeRequestURL.engineerMachineURL(page: page, keyword: keywordSearch)
        
        self.cleanList()
        
        Alamofire.request(requestURL).responseString(encoding: .utf8) { response in
            switch(response.result) {
            case .success(_):
                if let data = response.result.value {
                    do {
                        let doc = try HTML(html: data, encoding: .utf8)
                        for product in doc.css("table[class^='t_list hover'] td") {
                            let content = product.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                            //                            print(content)
                            switch (index % 5) {
                            case 0: break
                            case 1:
                                // Title
                                titleList.append(content)
                                break
                            case 2:
                                // File
                                if !content.isEmpty {
                                    attachmentCheckList.append(true)
                                } else {
                                    attachmentCheckList.append(false)
                                }
                                break
                            case 3:
                                // Date
                                dateStringList.append(content)
                                break
                            case 4:
                                break
                            default: break
                            }
                            index += 1
                        }
                        
                        for product in doc.css("table[class^='t_list hover'] td a") {
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
                print("Error message:\(String(describing: response.result.error))")
                break
            }
        }
    }
    
    static func parseListChemistryEngineering(page: Int, keyword: String?, completion: @escaping ([Notice]) -> Void) {
        // offset : 0 / 10 / 20 / etc.
        // offset : 0 * 10 / 1 * 10
        let offset = (page - 1) * 10
        var index = 0
        
        let keywordSearch = keyword?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let requestURL = NoticeRequestURL.engineerChemistryURL(offset: offset, keyword: keywordSearch)
        
        self.cleanList()
        
        Alamofire.request(requestURL).responseString(encoding: .utf8) { response in
            switch(response.result) {
            case .success(_):
                if let data = response.result.value {
                    do {
                        let doc = try HTML(html: data, encoding: .utf8)
                        
                        for product in doc.css("div[class^='board-list'] tr") {
                            let number = product.css("td[class^='no']").first?.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                            let title = product.css("td[class^='subject'] a").first?.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                            let author = product.css("td[class^='name']").first?.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                            let date = product.css("td[class^='date']").first?.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                            
                            if index > 0 {
                                if (number ?? "").isNumeric() {
                                    // normal
                                    isNoticeList.append(false)
                                } else {
                                    // notice
                                    isNoticeList.append(true)
                                }
                                titleList.append(title ?? "")
                                authorList.append(author ?? "")
                                dateStringList.append(date ?? "")
                                
                            }
                            
                            index += 1
                        }
                        
                        for product in doc.css("div[class^='board-list'] td a") {
                            print("http://chemeng.ssu.ac.kr\(product["href"] ?? "")")
                            urlList.append("http://chemeng.ssu.ac.kr\(product["href"] ?? "")")
                        }
                    } catch let error {
                        print("Error : \(error)")
                    }
                    
                    index = 0
                    for _ in urlList {
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
        // offset : 0 / 10 / 20 / etc.
        // offset : 0 * 10 / 1 * 10
        let offset = (page - 1) * 10
        var index = 0
        
        let keywordSearch = keyword?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let requestURL = NoticeRequestURL.engineerElectricURL(offset: offset, keyword: keywordSearch)
        
        self.cleanList()
        
        Alamofire.request(requestURL).responseString(encoding: .utf8) { response in
            switch(response.result) {
            case .success(_):
                if let data = response.result.value {
                    do {
                        let doc = try HTML(html: data, encoding: .utf8)
                        for product in doc.css("div[class^='num']") {
                            isNoticeList.append(!(product.text!.isNumeric()))
                        }
                        
                        for product in doc.css("div[class^='subject']") {
                            //print("***")
                            let content = product.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                            //                            print(content)
                            let detailUrl = product.css("a").first?["href"]
                            titleList.append(content)
                            urlList.append("http://ee.ssu.ac.kr\(detailUrl ?? "")")
                            
                            //                            print("http://ee.ssu.ac.kr\(detailUrl ?? "")")
                        }
                        
                        index = 0
                        for product in doc.css("div[class^='info'] span") {
                            let content = product.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                            //                            print(content)
                            
                            switch (index % 3) {
                            case 0:
                                // Date
                                dateStringList.append(content)
                                break
                            case 1:
                                // Author
                                authorList.append(content)
                                break
                            default: break
                            }
                            index += 1
                        }
                    } catch let error {
                        print("Error : \(error)")
                    }
                    
                    index = 0
                    for _ in urlList {
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
    
    static func parseListIndustry(page: Int, keyword: String?, completion: @escaping ([Notice]) -> Void) {
        var index = 0
        
        let keywordSearch = keyword?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let requestURL = NoticeRequestURL.engineerIndustryURL(page: page, keyword: keywordSearch)
        
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
                            var date = ""
                            var url = ""
                            var isNotice = false
                            var hasAttachment = false
                            
                            for (index, td) in product.css("td").enumerated() {
                                let content = td.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                                
                                switch (index % 5) {
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
                                    date = content
                                    if isAppendNotice {
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
                print("Error message:\(String(describing: response.result.error))")
                break
            }
        }
    }
    
    static func parseListOrganic(page: Int, keyword: String?, completion: @escaping ([Notice]) -> Void) {
        var index = 0
        
        let keywordSearch = keyword?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let requestURL = NoticeRequestURL.engineerOrganicURL(page: page, keyword: keywordSearch)
        
        self.cleanList()
        
        Alamofire.request(requestURL).responseString { response in
            switch(response.result) {
            case .success(_):
                if let data = response.result.value {
                    do {
                        let doc = try HTML(html: data, encoding: .utf8)
                        for product in (doc.css("div[class='mt40']").first?.css("td[align=left] a"))! {
                            let content = product.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                            titleList.append(content)
                            urlList.append("http://materials.ssu.ac.kr\(product["href"] ?? "")")
                        }
                        // Remove Frist Item
                        index = 0
                        for product in (doc.css("div[class='mt40']").first?.css("tr[height=35]"))! {
                            var realContent = product.content ?? ""
                            realContent = realContent.replacingOccurrences(of: "\t", with: "")
                            realContent = realContent.replacingOccurrences(of: " ", with: "")
                            if index > 0 {
                                var postItem = (realContent.split(separator: "\n"))
                                if postItem.count > 9 {
                                    // 번호를 지운다
                                    postItem.remove(at: 0)
                                }
                                authorList.append(String(postItem[3]))
                                dateStringList.append(String(postItem[5]))
                            }
                            index += 1
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
                    // 17
                    completion(noticeList)
                }
            case .failure(_):
                print("Error message:\(String(describing: response.result.error))")
                break
            }
        }
    }
    
    // 건축학부 (검색을 위한 작업이 필요할듯)
    static func parseListArchitect(page: Int, keyword: String, completion: @escaping ([Notice]) -> Void) {
        var isSearchMode = false
        
        var index = 0
        let requestURL = NoticeRequestURL.engineerArchitectURL()
        
        self.cleanList()
        
        if keyword.isEmpty {
            isSearchMode = false
        } else {
            isSearchMode = true
        }
        
        if page < 2 {
            Alamofire.request(requestURL).responseString { response in
                switch(response.result) {
                case .success(_):
                    guard let data = response.data else { return }
                    let utf8Text = String(data: data, encoding: .utf8) ?? String(decoding: data, as: UTF8.self)
                    
                    do {
                        let doc = try HTML(html: utf8Text, encoding: .utf8)
                        for product in doc.css("tr[class='clickableRow']") {
                            let paramURL = product["href"] ?? ""
                            urlList.append("http://soar.ssu.ac.kr\(paramURL)")
                            var index = 0
                            for text in product.css("td") {
                                let content = text.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                                switch (index) {
                                case 0:
                                    //Category
                                    break
                                case 1:
                                    //title
                                    titleList.append(content)
                                    break
                                case 2:
                                    //date
                                    dateStringList.append(content)
                                    break
                                default:
                                    break
                                }
                                index += 1
                            }
                        }
                    } catch let error {
                        print("Error : \(error)")
                    }
                    
                    index = 0
                    for _ in urlList {
                        let noticeItem = Notice(author: "", title: titleList[index], url: urlList[index], date: dateStringList[index], isNotice: false)
                        // 검색모드에서 키워드가 포함되면
                        if isSearchMode {
                            if noticeItem.title?.contains(keyword) ?? false {
                                noticeList.append(noticeItem)
                            }
                        } else {
                            noticeList.append(noticeItem)
                        }
                        index += 1
                    }
                    // 17
                    completion(noticeList)
                case .failure(_):
                    print("Error message:\(String(describing: response.result.error))")
                    break
                }
            }
        } else {
            ConfigSetting.canFetchData = false
        }
    }
}

