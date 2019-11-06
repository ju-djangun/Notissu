//
//  NoticeDetailViewController.swift
//  SoongsilNotice
//
//  Created by TaeinKim on 2019/11/05.
//  Copyright © 2019 TaeinKim. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import Kanna
import WebKit

class NoticeDetailViewController: UIViewController, WKNavigationDelegate, WKUIDelegate, NoticeDetailView {
    @IBOutlet var webView: WKWebView!
    var detailURL: String?
    var departmentCode: DeptCode?
    var presenter: NoticeDetailPresenter?
    
    override func viewDidLoad() {
        self.webView.uiDelegate = self
        self.webView.navigationDelegate = self
        self.navigationItem.title = "상세보기"
        self.presenter = NoticeDetailPresenter(view: self)
        
        Alamofire.request(detailURL!).responseString(encoding: .utf8) { response in
            //            print("\(response.result.isSuccess)")
            //            print(response.result.value ?? "")
            switch(response.result) {
            case .success(_):
                if let data = response.result.value {
                    do {
                        let doc = try HTML(html: data, encoding: .utf8)
                        switch(self.departmentCode!) {
                        case DeptCode.IT_Computer:
                            self.presenter!.parseComputer(html: doc, completion: self.showWebViewPage)
                            break
                        case DeptCode.IT_Electric:
                            self.presenter!.parseElectric(html: doc, completion: self.showWebViewPage)
                            break
                        default: break
                        }
                    } catch let error {
                        print("ERROR : \(error)")
                    }
                }
                break
            default: break
            }
        }
    }
    
    func showWebViewPage(attachments: [Attachment], html: String) {
        self.webView.loadHTMLString(html, baseURL: nil)
    }
}
