//
//  NoticeDetailViewController.swift
//  Notissu
//
//  Copyright © 2019 Notissu. All rights reserved.
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
    
    private var isFavorite: Bool = false {
        didSet {
            self.setFavoriteButton(favorite: isFavorite)
        }
    }
    
    var attachments   = [Attachment]()
    var detailURL     : String?
    var department    : Major? {
        didSet {
            self.departmentCode = department?.majorCode
        }
    }
    var writingUID    : String?
    var departmentCode: DeptCode?
    var noticeTitle   : String?
    var noticeDay     : String?
    var noticeItem    : Notice? {
        didSet {
            self.noticeTitle = self.noticeItem?.title
            self.noticeDay = self.noticeItem?.date
            self.detailURL = self.noticeItem?.url
        }
    }
    var presenter     : NoticeDetailPresenter!
    var docController : UIDocumentInteractionController!
    
    private func getBookmarkImage(favorite: Bool) -> UIImage? {
        return favorite ? NotissuImage.favoriteNavigationImageON : NotissuImage.favoriteNavigationImageOFF
    }
    
    private func setFavoriteButton(favorite: Bool) {
        self.navigationItem.rightBarButtonItems?[0].image = isFavorite ? NotissuImage.favoriteNavigationImageON : NotissuImage.favoriteNavigationImageOFF
    }
    
    override func viewDidLoad() {
        self.webView.uiDelegate = self
        self.webView.navigationDelegate = self
        self.attachmentView.delegate = self
        self.attachmentView.dataSource = self
        self.attachmentView.separatorInset = .zero
        self.attachmentView.tableFooterView = UIView()
        
        self.attachViewHeightConstraint.constant = 0
        self.navigationItem.title = "상세보기"
        
        self.titleLabel.text = noticeTitle ?? ""
        self.dateLabel.text = noticeDay ?? ""
        self.presenter = NoticeDetailPresenter(view: self)
        
        self.showProgressBar()
        
        if let title = noticeTitle, let day = noticeDay, let code = departmentCode {
            if self.presenter.isNoticeFavorite(title: title, date: day, major: code) {
                isFavorite = true
            } else {
                isFavorite = false
            }
        }
        let bookmarkButton = UIBarButtonItem(image: isFavorite ? NotissuImage.favoriteNavigationImageON : NotissuImage.favoriteNavigationImageOFF, style: .plain, target: self, action: #selector(favoriteTapped))
        
        let linkCopyButton = UIBarButtonItem(image: NotissuImage.noticeLinkCopyImage, style: .plain, target: self, action: #selector(linkButtonTapped))
        
        self.navigationItem.setRightBarButtonItems([bookmarkButton, linkCopyButton], animated: false)
        
        self.loadContentFromURL(string: detailURL!)
    }
    
    @objc func linkButtonTapped() {
        guard let url = detailURL?.decodeUrl()?.encodeUrl() else {
            return
        }
        
        let textToShare = [url]
        let activityVC = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityVC.excludedActivityTypes = [ UIActivity.ActivityType.airDrop ]
        self.present(activityVC, animated: true, completion: nil)
    }
    
    @objc func favoriteTapped() {
        self.isFavorite = !self.isFavorite
        self.presenter.setFavorite(notice: self.noticeItem!, majorCode: self.departmentCode!, favorite: self.isFavorite)
    }
    
    func loadContentFromURL(string: String) {
        guard let url = string.decodeUrl()?.encodeUrl() else {
            return
        }
        
        if self.departmentCode! == DeptCode.Inmun_Writing || self.departmentCode! == DeptCode.Dormitory {
            AF.request(url).responseData(completionHandler: { response in
                switch(response.result) {
                case .success(_):
                    guard let data = response.data else { return }
                    let responseString = NSString(data: data, encoding:CFStringConvertEncodingToNSStringEncoding(0x0422))
                    do {
                        let doc = try HTML(html: responseString as String? ?? "", encoding: .utf8)
                        if let deptCode = self.departmentCode, deptCode == .Dormitory || deptCode == .Inmun_Writing {
                            NoticeParser.shared.parseNoticeDetail(html: doc, type: deptCode, completion: self.showWebViewPage)
                        }
                    } catch let error {
                        print("ERROR : \(error)")
                    }
                case .failure(let error):
                    print(error)
                }
            })
        } else {
            AF.request(url).responseString(completionHandler: { response in
                switch(response.result) {
                case .success(_):
                    guard let text = response.data else { return }
                    let data = String(data: text, encoding: .utf8) ?? String(decoding: text, as: UTF8.self)
                    do {
                        let doc = try HTML(html: data, encoding: .utf8)
                        if let deptCode = self.departmentCode, deptCode != .Inmun_Writing {
                            if deptCode == .IT_SmartSystem || deptCode == .Engineering_Organic {
                                self.hideProgressBar()
                                self.webView.load(URLRequest(url: URL(string: self.detailURL ?? "")!))
                            }
                            NoticeParser.shared.parseNoticeDetail(html: doc, type: deptCode, completion: self.showWebViewPage)
                        }
                    } catch let error {
                        print("ERROR : \(error)")
                    }
                case .failure(let error):
                    print(error)
                }
            })
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
        } else if self.departmentCode == DeptCode.Inmun_Writing {
            self.attachViewHeightConstraint.constant = 64
            self.attachmentView.isScrollEnabled = false
        }
        
        for attachment in attachments {
            print("attachment : \(attachment.fileName) / \(attachment.fileURL)")
        }
        
        self.hideProgressBar()
        self.attachmentView.reloadData()
    }
    
    // Attachment Table View Delegate Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.departmentCode == DeptCode.Inmun_Writing {
            return 1
        } else {
            return attachments.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.departmentCode == DeptCode.Inmun_Writing {
            let cell = tableView.dequeueReusableCell(withIdentifier: "notSupportAttachment", for: indexPath)
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "noticeAttachmentCell", for: indexPath) as! NoticeAttachmentCell
            
            print("cell : \(attachments.count)")
            if self.attachments.count > 0 {
                cell.viewController = self
                cell.cellDelegate = self
                cell.attachment = attachments[indexPath.row]
                cell.majorCode = self.departmentCode
            }
            cell.selectionStyle  = .none
            
            return cell
        }
    }
    
    func showDocumentInteractionController(filePath: String) {
        print("open file dialog")
        self.hideProgressBar()
        self.docController = UIDocumentInteractionController(url: NSURL(fileURLWithPath: filePath) as URL)
        self.docController.name = NSURL(fileURLWithPath: filePath).lastPathComponent
        print("NAME : " + self.docController.name!)
        self.docController.delegate = self
        self.docController.presentOptionsMenu(from: view.frame, in: view, animated: true)
    }
    
    func showIndicator() {
        print("show Indicator")
        self.showProgressBar()
    }
}

