//
//  ViewController.swift
//  SoongsilNotice
//
//  Created by TaeinKim on 2019/11/04.
//  Copyright © 2019 TaeinKim. All rights reserved.
//

import UIKit
import Kanna
import WebKit

class ViewController: UIViewController {
    var page: Int = 1
    
    @IBOutlet var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let detailHTML = loadDetailURL(url: "http://cse.ssu.ac.kr/03_sub/01_sub.htm?no=4209&bbs_cmd=view&page=1&key=&keyfield=&category=&bbs_code=Ti_BBS_1")
        
        webView.loadHTMLString(detailHTML, baseURL: nil)
        
        loadURL(url: "http://cse.ssu.ac.kr/03_sub/01_sub.htm?page=\(page)&key=&keyfield=&category=&bbs_code=Ti_BBS_1")
    }
    
    func loadDetailURL(url: String) -> String {
        guard let main = URL(string: url) else {
            print("Error: \(url) doesn't seem to be a valid URL")
            return ""
        }
        do {
            let noticeDetailMain = try String(contentsOf: main, encoding: .utf8)
            let doc = try HTML(html: noticeDetailMain, encoding: .utf8)
            //print(doc.css("div[class|=smartOutput]").first?.innerHTML ?? "")
            return doc.css("div[class|=smartOutput]").first?.innerHTML ?? ""
        } catch let error {
            print("Error : \(error)")
        }
        return ""
    }
    
    func loadURL(url: String) {
        guard let main = URL(string: url) else {
          print("Error: \(url) doesn't seem to be a valid URL")
          return
        }
        do {
            let noticeItemMain = try String(contentsOf: main, encoding: .utf8)
            let doc = try HTML(html: noticeItemMain, encoding: .utf8)
            
            for product in doc.xpath("//table/tbody/tr/*") {
                if product.nextSibling?.className ?? "" == "center" {
                    let noticeTitle = product.nextSibling?.text ?? ""
                    if !noticeTitle.isEmpty {
                        print(noticeTitle)
                    }
                    
                    let pageString = product.at_xpath("a")?["href"] ?? ""
                    let noticeContent = product.at_xpath("a")?.content ?? ""
                    if !pageString.isEmpty {
                        print(noticeContent)
                        print("http://cse.ssu.ac.kr/03_sub/01_sub.htm\(pageString)")
                    }
                }
            }
        } catch let error {
            print("Error: \(error)")
        }
    }
}

