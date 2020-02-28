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
