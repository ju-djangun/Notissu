//
//  NoticeDetailViewController.swift
//  SoongsilNotice
//
//  Created by TaeinKim on 2019/11/05.
//  Copyright © 2019 TaeinKim. All rights reserved.
//

import Foundation
import UIKit
import Kanna
import WebKit

class NoticeDetailViewController: UIViewController {
    @IBOutlet var webView: WKWebView!
    var detailURL: String?
    
    override func viewDidLoad() {
        guard let detail = URL(string: detailURL ?? "") else {
            print("Error: \(detailURL ?? "") doesn't seem to be a valid URL")
            return
        }
        do {
            let main = try String(contentsOf: detail, encoding: .utf8)
            let doc = try HTML(html: main, encoding: .utf8)
            let detailHTML = doc.css("div[class|=smartOutput]").first?.innerHTML ?? ""
            webView.loadHTMLString(detailHTML, baseURL: nil)
        } catch let error {
            print("ERROR : \(error)")
        }
    }
}
