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

class NoticeDetailViewController: BaseViewController, WKNavigationDelegate, WKUIDelegate, UITableViewDelegate, UITableViewDataSource, UIDocumentInteractionControllerDelegate, NoticeDetailView, AttachmentDelegate {
    
    @IBOutlet var attachmentView            : UITableView!
    @IBOutlet var webView                   : WKWebView!
    @IBOutlet var titleLabel                : UILabel!
    @IBOutlet var dateLabel                 : UILabel!
    @IBOutlet var attachViewHeightConstraint: NSLayoutConstraint!
    
    var attachments   = [Attachment]()
    var detailURL     : String?
    var departmentCode: DeptCode?
    var noticeTitle   : String?
    var noticeDay     : String?
    var presenter     : NoticeDetailPresenter?
    var docController : UIDocumentInteractionController!
    
    override func viewDidLoad() {
        self.webView.uiDelegate = self
        self.webView.navigationDelegate = self
        self.attachmentView.delegate = self
        self.attachmentView.dataSource = self
        
        self.attachViewHeightConstraint.constant = 0
        self.navigationItem.title = "상세보기"
        
        self.titleLabel.text = noticeTitle ?? ""
        self.dateLabel.text = noticeDay ?? ""
        self.presenter = NoticeDetailPresenter(view: self)
        
        Alamofire.request(detailURL!).responseString { response in
            //            print("\(response.result.isSuccess)")
            //            print(response.result.value ?? "")
            switch(response.result) {
            case .success(_):
                guard let text = response.data else { return }
                let data = String(data: text, encoding: .utf8) ?? String(decoding: text, as: UTF8.self)
                    do {
                        let doc = try HTML(html: data, encoding: .utf8)
                        switch(self.departmentCode!) {
                        case DeptCode.IT_Computer:
                            self.presenter!.parseComputer(html: doc, completion: self.showWebViewPage)
                            break
                        case DeptCode.IT_Electric:
                            self.presenter!.parseElectric(html: doc, completion: self.showWebViewPage)
                            break
                        case DeptCode.IT_Software:
                            self.presenter!.parseSoftware(html: doc, completion: self.showWebViewPage)
                        case DeptCode.IT_Media:
                            self.presenter!.parseMedia(html: doc, completion: self.showWebViewPage)
                        default: break
                        }
                    } catch let error {
                        print("ERROR : \(error)")
                    }
//            }
                break
            default: break
            }
        }
    }
    
    func showWebViewPage(attachments: [Attachment], html: String) {
        self.webView.loadHTMLString(html, baseURL: nil)
        self.attachments = attachments
        
        if attachments.count > 0 {
            self.attachViewHeightConstraint.constant = 128
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
        
        for attachment in attachments {
            print("attachment : \(attachment.fileName) / \(attachment.fileURL)")
        }
        self.attachmentView.reloadData()
    }
    
    // Attachment Table View Delegate Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attachments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noticeAttachmentCell", for: indexPath) as! NoticeAttachmentCell
        
        print("cell : \(attachments.count)")
        if self.attachments.count > 0 {
            cell.viewController = self
            cell.cellDelegate = self
            cell.fileName = attachments[indexPath.row].fileName
            cell.attachmentTitle.text = attachments[indexPath.row].fileName
            cell.fileDownloadURL = attachments[indexPath.row].fileURL
        }
        cell.selectionStyle  = .none
        
        return cell
    }
    
    func showDocumentInteractionController(filePath: String) {
        print("open file dialog")
        self.hideActivityIndicator()
        self.docController = UIDocumentInteractionController(url: NSURL(fileURLWithPath: filePath) as URL)
        self.docController.name = NSURL(fileURLWithPath: filePath).lastPathComponent
        print("NAME : " + self.docController.name!)
        self.docController.delegate = self
        self.docController.presentOptionsMenu(from: view.frame, in: view, animated: true)
    }
    
    func showIndicator() {
        print("show Indicator")
        self.showActivityIndicator()
    }
}
