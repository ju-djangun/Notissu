//
//  NoticeSocial.swift
//  SoongsilNotice
//
//  Created by TaeinKim on 2019/11/12.
//  Copyright © 2019 TaeinKim. All rights reserved.
//

import Foundation
import Alamofire
import UIKit
import Kanna

class NoticeSocial {
    static func parseListWelfare(page: Int, completion: @escaping ([Notice]) -> Void) {
        let noticeUrl = "\(NoticeURL.socialWelfareURL)\(page)"
        var noticeList = [Notice]()
        var authorList = [String]()
        var titleList  = [String]()
        var urlList = [String]()
        var dateStringList = [String]()
        var index = 0
        
        Alamofire.request(noticeUrl).responseString(encoding: .utf8) { response in
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
                        
                        for product in doc.css("table[class='bbs-list'] a") {
                            print(product["href"] ?? "")
                            urlList.append(product["href"] ?? "")
                        }
                    } catch let error {
                        print("Error : \(error)")
                    }
                    
                    index = 0
                    for _ in urlList {
                        let noticeItem = Notice(author: authorList[index], title: titleList[index], url: urlList[index], date: dateStringList[index])
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
    
    static func parseListAdministration(page: Int, completion: @escaping ([Notice]) -> Void) {
        let offset =  (page - 1) * 10
        let noticeUrl = "\(NoticeURL.socialAdministrationURL)\(offset)"
        var noticeList = [Notice]()
        var authorList = [String]()
        var titleList  = [String]()
        var urlList = [String]()
        var dateStringList = [String]()
        var index = 0
        
        print(noticeUrl)
        
        Alamofire.request(noticeUrl).responseString(encoding: .utf8) { response in
            switch(response.result) {
            case .success(_):
                if let data = response.result.value {
                    do {
                        let doc = try HTML(html: data, encoding: .utf8)
                        for product in doc.css("div[class='board-list'] td") {
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
                        
                        for product in doc.css("td[class='subject'] a") {
                            print("http://pubad.ssu.ac.kr\(product["href"] ?? "")")
                            urlList.append("http://pubad.ssu.ac.kr\(product["href"] ?? "")")
                        }
                    } catch let error {
                        print("Error : \(error)")
                    }
                    
                    index = 0
                    for _ in urlList {
                        let noticeItem = Notice(author: authorList[index], title: titleList[index], url: urlList[index], date: dateStringList[index])
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
    
    static func parseListSociology(page: Int, completion: @escaping ([Notice]) -> Void) {
        let offset =  (page - 1) * 10
        let noticeUrl = "\(NoticeURL.socialSociologyURL)\(offset)"
        var noticeList = [Notice]()
        var authorList = [String]()
        var titleList  = [String]()
        var urlList = [String]()
        var dateStringList = [String]()
        var index = 0
        
        print(noticeUrl)
        
        Alamofire.request(noticeUrl).responseString(encoding: .utf8) { response in
            switch(response.result) {
            case .success(_):
                if let data = response.result.value {
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
                        let noticeItem = Notice(author: authorList[index], title: titleList[index], url: urlList[index], date: dateStringList[index])
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
    
    static func parseListJournalism(page: Int, completion: @escaping ([Notice]) -> Void) {
        let noticeUrl = "\(NoticeURL.socialJournalismURL)\(page)"
        var noticeList = [Notice]()
        var authorList = [String]()
        var titleList  = [String]()
        var urlList = [String]()
        var dateStringList = [String]()
        var index = 0
        
        print("\(noticeUrl) : \(page)")
        
        Alamofire.request(noticeUrl).responseString(encoding: .utf8) { response in
            switch(response.result) {
            case .success(_):
                if let data = response.result.value {
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
                                    // Title
                                    titleList.append(content)
                                    break
                                case 1: break
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
                                // Title
                                titleList.append(content)
                                break
                            case 1: break
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
                        let noticeItem = Notice(author: authorList[index], title: titleList[index], url: urlList[index], date: dateStringList[index])
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
    
    static func parseListLifeLong(page: Int, completion: @escaping ([Notice]) -> Void) {
        let noticeUrl = "\(NoticeURL.socialLifeLongURL)\(page)"
        var noticeList = [Notice]()
        var authorList = [String]()
        var titleList  = [String]()
        var urlList = [String]()
        var dateStringList = [String]()
        var index = 0
        
        Alamofire.request(noticeUrl).responseString(encoding: .utf8) { response in
            switch(response.result) {
            case .success(_):
                if let data = response.result.value {
                    do {
                        var boldCount = 0
                        let doc = try HTML(html: data, encoding: .utf8)
                        var isAdd = false
                        for product in doc.css("table[class='board_list'] td") {
                            let content = product.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                            print(content)
                            switch (index % 5) {
                            case 0:
                                if page > 1 && content == "공지" {
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
                        let noticeItem = Notice(author: authorList[index], title: titleList[index], url: urlList[index], date: dateStringList[index])
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
    
    static func parseListPolitical(page: Int, completion: @escaping ([Notice]) -> Void) {
        
    }
}
