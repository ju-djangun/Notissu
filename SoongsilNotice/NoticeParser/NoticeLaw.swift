//
//  NoticeLaw.swift
//  SoongsilNotice
//
//  Created by TaeinKim on 2019/11/07.
//  Copyright © 2019 TaeinKim. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import Kanna

class NoticeLaw {
    static func parseListLaw(page: Int, keyword: String?, completion: @escaping ([Notice]) -> Void) {
        let noticeUrl = "http://law.ssu.ac.kr/web/law/board1?p_p_id=EXT_BBS&p_p_lifecycle=0&p_p_state=normal&p_p_mode=view&p_p_col_id=column-1&p_p_col_count=1&_EXT_BBS_struts_action=%2Fext%2Fbbs%2Fview&_EXT_BBS_sCategory=&_EXT_BBS_sTitle=&_EXT_BBS_sWriter=&_EXT_BBS_sTag=&_EXT_BBS_sContent=&_EXT_BBS_sCategory2=&_EXT_BBS_sKeyType=&_EXT_BBS_sKeyword=&_EXT_BBS_curPage=\(page)"
        
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
            let searchUrl = "http://law.ssu.ac.kr/web/law/board1?p_p_id=EXT_BBS&p_p_lifecycle=0&p_p_state=normal&p_p_mode=view&p_p_col_id=column-1&p_p_col_count=1&_EXT_BBS_struts_action=%2Fext%2Fbbs%2Fview&_EXT_BBS_sCategory=&_EXT_BBS_sTitle=\(keywordSearch ?? "")&_EXT_BBS_sWriter=&_EXT_BBS_sTag=&_EXT_BBS_sContent=&_EXT_BBS_sCategory2=&_EXT_BBS_sKeyType=title&_EXT_BBS_sKeyword=\(keywordSearch ?? "")&_EXT_BBS_curPage=\(page)"
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
                        for product in doc.css("table[class='bbs-list'] td") {
                            //print("***")
                            let content = product.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                            switch (index % 5) {
                            case 0:
                                // notice, normal
                                if product.innerHTML?.contains("img") ?? false {
                                    // isNotice
                                    isNoticeList.append(true)
                                } else {
                                    isNoticeList.append(false)
                                }
                                break
                            case 1:
                                // Title
                                //print(content)
                                titleList.append(content)
                                break
                            case 2: break
                            case 3:
                                // Date
                                //print(content)
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
                        let noticeItem = Notice(author: "", title: titleList[index], url: urlList[index], date: dateStringList[index], isNotice: isNoticeList[index])
                        noticeList.append(noticeItem)
                        index += 1
                    }
                    
                    completion(noticeList)
                }
            case .failure(_):
                print("Error message:\(response.result.error)")
                break
            }
        }
    }
    
    static func parseListIntlLaw(page: Int, keyword: String?, completion: @escaping ([Notice]) -> Void) {
        let noticeUrl = "http://lawyer.ssu.ac.kr/web/lawyer/27?p_p_id=EXT_BBS&p_p_lifecycle=0&p_p_state=normal&p_p_mode=view&p_p_col_id=column-1&p_p_col_count=1&_EXT_BBS_struts_action=%2Fext%2Fbbs%2Fview&_EXT_BBS_sCategory=&_EXT_BBS_sTitle=&_EXT_BBS_sWriter=&_EXT_BBS_sTag=&_EXT_BBS_sContent=&_EXT_BBS_sCategory2=&_EXT_BBS_sKeyType=&_EXT_BBS_sKeyword=&_EXT_BBS_curPage=\(page)"
        
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
            let searchUrl = "http://lawyer.ssu.ac.kr/web/lawyer/27?p_p_id=EXT_BBS&p_p_lifecycle=0&p_p_state=normal&p_p_mode=view&p_p_col_id=column-1&p_p_col_count=1&_EXT_BBS_struts_action=%2Fext%2Fbbs%2Fview&_EXT_BBS_sCategory=&_EXT_BBS_sTitle=\(keywordSearch ?? "")&_EXT_BBS_sWriter=&_EXT_BBS_sTag=&_EXT_BBS_sContent=&_EXT_BBS_sCategory2=&_EXT_BBS_sKeyType=title&_EXT_BBS_sKeyword=\(keywordSearch ?? "")&_EXT_BBS_curPage=\(page)"
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
                            //print(product["href"] ?? "")
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
                print("Error message:\(response.result.error)")
                break
            }
        }
    }
}
