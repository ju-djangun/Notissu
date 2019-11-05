//
//  NoticeIT.swift
//  SoongsilNotice
//
//  Created by TaeinKim on 2019/11/05.
//  Copyright © 2019 TaeinKim. All rights reserved.
//

import Foundation
import UIKit
import Kanna

class NoticeIT {
    static func parseListComputer(page: Int, completion: @escaping ([Notice]) -> Void) {
        var noticeList = [Notice]()
        var authorList = [String]()
        var titleList  = [String]()
        var pageStringList = [String]()
        var dateStringList = [String]()
        let noticeUrl = "http://cse.ssu.ac.kr/03_sub/01_sub.htm?page=\(page)&key=&keyfield=&category=&bbs_code=Ti_BBS_1"
        
        var index = 0
        
        guard let main = URL(string: noticeUrl) else {
            print("Error: \(noticeUrl) doesn't seem to be a valid URL")
            return
        }
        do {
            let noticeItemMain = try String(contentsOf: main, encoding: .utf8)
            let doc = try HTML(html: noticeItemMain, encoding: .utf8)
            for product in doc.xpath("//table/tbody/tr/*") {
                if product.nextSibling?.className ?? "" == "center" {
                    let noticeAuthor = product.nextSibling?.text ?? ""
                    let noticeDate = product.nextSibling?.nextSibling?.text ?? ""
                    let pageString = product.at_xpath("a")?["href"] ?? ""
                    
                    switch index % 2 {
                    case 0:
                        let noticeTitle = product.content ?? ""
                        authorList.append(noticeAuthor)
                        titleList.append(noticeTitle)
                        pageStringList.append("http://cse.ssu.ac.kr/03_sub/01_sub.htm\(pageString)")
                        dateStringList.append(noticeDate)
                        break;
                    case 1:  break;
                    default: break
                    }
                    index += 1
                }
            }
        } catch let error {
            print("Error : \(error)")
        }
        
        index = 0
        for _ in authorList {
            //            print("index : \(index) , title : \(titleList[index]), author : \(authorList[index]), date : \(dateStringList[index])")
            let noticeItem = Notice(author: authorList[index], title: titleList[index], url: pageStringList[index], date: dateStringList[index])
            
            noticeList.append(noticeItem)
            index += 1
        }
        
        completion(noticeList)
    }
    
    func parseListMedia(content: String) {
        
    }
    
    func parseListSoftware(content: String) {
        
    }
    
    func parseListElectricElec(content: String) {
        
    }
    
    func parseListElectricIT(content: String) {
        
    }
    
    func parseListSmartSystem(content: String) {
        
    }
    
    func parseListMediaOper(content: String) {
        
    }
}
