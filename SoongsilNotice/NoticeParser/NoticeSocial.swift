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
    static func parseListWelfare(page: Int, keyword: String?, completion: @escaping ([Notice]) -> Void) {
        let noticeUrl = "\(NoticeURL.socialWelfareURL)\(page)"
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
            let searchUrl = "http://pre.ssu.ac.kr/web/mysoongsil/bbs_notice?p_p_id=EXT_BBS&p_p_lifecycle=0&p_p_state=normal&p_p_mode=view&p_p_col_id=column-1&p_p_col_count=1&_EXT_BBS_struts_action=%2Fext%2Fbbs%2Fview&_EXT_BBS_sCategory=&_EXT_BBS_sTitle=\(keywordSearch ?? "")&_EXT_BBS_sWriter=&_EXT_BBS_sTag=&_EXT_BBS_sContent=&_EXT_BBS_sCategory2=&_EXT_BBS_sKeyType=title&_EXT_BBS_sKeyword=\(keywordSearch ?? "")&_EXT_BBS_curPage=\(page)"
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
                        for product in doc.css("table[class='bbs-list'] td") {
                            //print("***")
                            let content = product.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                            print(content)
                            switch (index % 6) {
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
    
    static func parseListAdministration(page: Int, keyword: String?, completion: @escaping ([Notice]) -> Void) {
        let noticeUrl = "\(NoticeURL.socialAdministrationURL)\(page)/"
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
            let searchUrl = "https://pubad.ssu.ac.kr/%EC%A0%95%EB%B3%B4%EA%B4%91%EC%9E%A5/%ED%95%99%EB%B6%80-%EA%B3%B5%EC%A7%80%EC%82%AC%ED%95%AD/page/\(page)/?select=title&keyword=\(keywordSearch ?? "")#038;keyword=\(keywordSearch ?? "")"
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
                        for product in doc.css("div[class='table_wrap'] td") {
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
                        
                        for product in doc.css("td[class='title'] a") {
                            print(product["href"] ?? "")
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
    
    static func parseListSociology(page: Int, keyword: String?, completion: @escaping ([Notice]) -> Void) {
        let offset =  (page - 1) * 10
        let noticeUrl = "\(NoticeURL.socialSociologyURL)\(offset)"
        var noticeList = [Notice]()
        var authorList = [String]()
        var titleList  = [String]()
        var urlList = [String]()
        var dateStringList = [String]()
        var index = 0
        var requestURL = ""
        
        if keyword != nil {
            let keywordSearch = keyword!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            let searchUrl = "http://inso.ssu.ac.kr/sub/sub04_01.php?boardid=notice&sk=\(keywordSearch ?? "")&sw=a&category=%ED%95%99%EA%B3%BC%EA%B3%B5%EC%A7%80&offset=\(offset)"
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
                print("Error message:\(String(describing: response.result.error))")
                break
            }
        }
    }
    
    static func parseListJournalism(page: Int, keyword: String?, completion: @escaping ([Notice]) -> Void) {
        let noticeUrl = "\(NoticeURL.socialJournalismURL)\(page)"
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
            let searchUrl = "http://pre.ssu.ac.kr/web/ssja/20?p_p_id=EXT_BBS&p_p_lifecycle=0&p_p_state=normal&p_p_mode=view&p_p_col_id=column-1&p_p_col_count=1&_EXT_BBS_struts_action=%2Fext%2Fbbs%2Fview&_EXT_BBS_sCategory=&_EXT_BBS_sTitle=\(keywordSearch ?? "")&_EXT_BBS_sWriter=&_EXT_BBS_sTag=&_EXT_BBS_sContent=&_EXT_BBS_sCategory2=&_EXT_BBS_sKeyType=title&_EXT_BBS_sKeyword=\(keywordSearch ?? "")&_EXT_BBS_curPage=\(page)"
            requestURL = searchUrl
        } else {
            requestURL = noticeUrl
        }
        
        Alamofire.request(requestURL).responseString(encoding: .utf8) { response in
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
                                    isNoticeList.append(false)
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
                                    isNoticeList.append(item.className == "trNotice")
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
    
    static func parseListLifeLong(page: Int, keyword: String?, completion: @escaping ([Notice]) -> Void) {
        let noticeUrl = "\(NoticeURL.socialLifeLongURL)\(page)"
        var noticeList = [Notice]()
        var authorList = [String]()
        var titleList  = [String]()
        var urlList = [String]()
        var dateStringList = [String]()
        var index = 0
        var requestURL = ""
        
        if keyword != nil {
            let keywordSearch = keyword!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            let searchUrl = "http://lifelongedu.ssu.ac.kr/bbs/board.php?bo_table=univ&sca=&sfl=wr_subject&stx=\(keywordSearch ?? "")&sop=and&page=\(page)"
            requestURL = searchUrl
        } else {
            requestURL = noticeUrl
        }
        
        Alamofire.request(requestURL).responseString(encoding: .utf8) { response in
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
    
    static func parseListPolitical(page: Int, keyword: String?, completion: @escaping ([Notice]) -> Void) {
        let noticeUrl = "\(NoticeURL.socialPoliticsURL)\(page)"
        var noticeList = [Notice]()
        var authorList = [String]()
        var titleList  = [String]()
        var urlList = [String]()
        var dateStringList = [String]()
        var index = 0
        var requestURL = ""
        
        if keyword != nil {
            let keywordSearch = keyword!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            let searchUrl = "http://pre.ssu.ac.kr/web/psir/board_a?p_p_id=EXT_BBS&p_p_lifecycle=0&p_p_state=normal&p_p_mode=view&p_p_col_id=column-1&p_p_col_count=1&_EXT_BBS_struts_action=%2Fext%2Fbbs%2Fview&_EXT_BBS_sCategory=&_EXT_BBS_sTitle=\(keywordSearch ?? "")&_EXT_BBS_sWriter=&_EXT_BBS_sTag=&_EXT_BBS_sContent=&_EXT_BBS_sCategory2=&_EXT_BBS_sKeyType=title&_EXT_BBS_sKeyword=\(keywordSearch ?? "")&_EXT_BBS_curPage=\(page)"
            requestURL = searchUrl
        } else {
            requestURL = noticeUrl
        }
        
        Alamofire.request(requestURL).responseString(encoding: .utf8) { response in
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
                print("Error message:\(String(describing: response.result.error))")
                break
            }
        }
    }
}
