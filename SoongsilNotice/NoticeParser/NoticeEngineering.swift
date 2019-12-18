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
    static func parseListMachine(page: Int, keyword: String?, completion: @escaping ([Notice]) -> Void) {
        let noticeUrl = "\(NoticeURL.engineerMachineURL)\(page)"
        var noticeList = [Notice]()
        var authorList = [String]()
        var titleList  = [String]()
        var urlList = [String]()
        var dateStringList = [String]()
        var index = 0
        var requestURL = ""
        
        if keyword != nil {
            let keywordSearch = keyword!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            let searchUrl = "http://me.ssu.ac.kr/web/me/notice_a?p_p_id=EXT_BBS&p_p_lifecycle=0&p_p_state=normal&p_p_mode=view&p_p_col_id=column-1&p_p_col_count=1&_EXT_BBS_struts_action=%2Fext%2Fbbs%2Fview&_EXT_BBS_sCategory=&_EXT_BBS_sTitle=\(keywordSearch ?? "")&_EXT_BBS_sWriter=&_EXT_BBS_sTag=&_EXT_BBS_sContent=&_EXT_BBS_sCategory2=&_EXT_BBS_sKeyType=title&_EXT_BBS_sKeyword=\(keywordSearch ?? "")&_EXT_BBS_curPage=\(page)"
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
                        for product in doc.css("table[class^='bbs-list'] td") {
                            let content = product.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                            //                            print(content)
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
                            case 4:
                                break
                            default: break
                            }
                            index += 1
                        }
                        
                        for product in doc.css("table[class^='bbs-list'] td a") {
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
    
    static func parseListChemistryEngineering(page: Int, keyword: String?, completion: @escaping ([Notice]) -> Void) {
        // offset : 0 / 10 / 20 / etc.
        // offset : 0 * 10 / 1 * 10
        let offset = (page - 1) * 10
        let noticeUrl = "\(NoticeURL.engineerChemistryURL)\(offset)"
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
            let searchUrl = "http://chemeng.ssu.ac.kr/sub/sub03_01.php?boardid=notice1&sk=\(keywordSearch ?? "")&sw=a&category=&offset=\(offset)"
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
        let noticeUrl = "\(NoticeURL.engineerElectricURL)\(offset)"
        var noticeList = [Notice]()
        var authorList = [String]()
        var titleList  = [String]()
        var urlList = [String]()
        var isNoticeList = [Bool]()
        var dateStringList = [String]()
        var index = 0
        var requestURL = ""
        
        if keyword != nil {
            let keywordSearch = keyword!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            let searchUrl = "http://ee.ssu.ac.kr/sub/sub05_01.php?boardid=notice&sk=\(keywordSearch ?? "")&sw=a&category=&offset=\(offset)"
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
        let noticeUrl = "\(NoticeURL.engineerIndustryURL)\(page)"
        var noticeList = [Notice]()
        var authorList = [String]()
        var titleList  = [String]()
        var urlList = [String]()
        var isNoticeList = [Bool]()
        var dateStringList = [String]()
        var index = 0
        var requestURL = ""
        
        if keyword != nil {
            let keywordSearch = keyword!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            let searchUrl = "http://iise.ssu.ac.kr/web/iise/notice?p_p_id=EXT_BBS&p_p_lifecycle=0&p_p_state=normal&p_p_mode=view&p_p_col_id=column-1&p_p_col_count=1&_EXT_BBS_struts_action=%2Fext%2Fbbs%2Fview&_EXT_BBS_sCategory=&_EXT_BBS_sTitle=\(keywordSearch ?? "")&_EXT_BBS_sWriter=&_EXT_BBS_sTag=&_EXT_BBS_sContent=&_EXT_BBS_sCategory2=&_EXT_BBS_sKeyType=title&_EXT_BBS_sKeyword=\(keywordSearch ?? "")&_EXT_BBS_curPage=\(page)"
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
                        for product in doc.css("table[class^='bbs-list'] td") {
                            //print("***")
                            let content = product.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                            switch (index % 5) {
                            case 0:
                                if product.innerHTML?.contains("img") ?? false {
                                    // isNotice
                                    isNoticeList.append(true)
                                } else {
                                    isNoticeList.append(false)
                                }
                                break
                            case 1:
                                // Title
                                titleList.append(content)
                                break
                            case 2: break
                            case 3:
                                // Date
                                dateStringList.append(content)
                                break
                            case 4: break
                            default: break
                            }
                            index += 1
                        }
                        
                        for product in doc.css("table[class^='bbs-list'] td a") {
                            urlList.append(product["href"] ?? "")
                        }
                    } catch let error {
                        print("Error : \(error)")
                    }
                    
                    index = 0
                    for _ in urlList {
                        let noticeItem = Notice(author: "", title: titleList[index], url: urlList[index], date: dateStringList[index], isNotice: isNoticeList[index])
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
        let noticeUrl = "\(NoticeURL.engineerOrganicURL)\(page)"
        var noticeList = [Notice]()
        var authorList = [String]()
        var titleList  = [String]()
        var urlList = [String]()
        var dateStringList = [String]()
        var index = 0
        var requestURL = ""
        
        if keyword != nil {
            let keywordSearch = keyword!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            let searchUrl = "http://materials.ssu.ac.kr/bbs/board.php?tbl=notice&&category=&findType=&findWord=\(keywordSearch ?? "")&sort1=&sort2=&it_id=&shop_flag=&mobile_flag=&page=\(page)"
            requestURL = searchUrl
        } else {
            requestURL = noticeUrl
        }
        
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
    
    static func parseListArchitect(page: Int, completion: @escaping ([Notice]) -> Void) {
        let noticeUrl = "\(NoticeURL.engineerArchitectURL)"
        var noticeList = [Notice]()
        var authorList = [String]()
        var titleList  = [String]()
        var urlList = [String]()
        var dateStringList = [String]()
        var index = 0
        var requestURL = ""
        
        requestURL = noticeUrl
        
        Alamofire.request(requestURL).responseString { response in
            switch(response.result) {
            case .success(_):
                guard let data = response.data else { return }
                let utf8Text = String(data: data, encoding: .utf8) ?? String(decoding: data, as: UTF8.self)
                
                do {
                    let doc = try HTML(html: utf8Text, encoding: .utf8)
                    for product in doc.css("tr[class='clickableRow']") {
                        print("URL : \(product["href"])")
                        var index = 0
                        for text in product.css("td") {
                            let content = text.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                            switch (index) {
                            case 0:
                                //Category
                                print("TEXT : \(content)")
                                break
                            case 1:
                                //title
                                titleList.append(content)
                                print("TITLE : \(content)")
                                break
                            case 2:
                                //date
                                dateStringList.append(content)
                                print("DATE : \(content)")
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
                    let noticeItem = Notice(author: authorList[index], title: titleList[index], url: urlList[index], date: dateStringList[index], isNotice: false)
                    noticeList.append(noticeItem)
                    index += 1
                }
                // 17
                completion(noticeList)
            case .failure(_):
                print("Error message:\(String(describing: response.result.error))")
                break
            }
        }
    }
}
