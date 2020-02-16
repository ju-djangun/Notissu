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
    
    private var isFavorite: Bool = false {
        didSet {
            self.setFavoriteButton(favorite: isFavorite)
        }
    }
    
    var attachments   = [Attachment]()
    var detailURL     : String?
    var departmentCode: DeptCode?
    var noticeTitle   : String?
    var noticeDay     : String?
    var noticeItem    : Notice?
    var presenter     : NoticeDetailPresenter!
    var docController : UIDocumentInteractionController!
    
    private func setFavoriteButton(favorite: Bool) {
        self.navigationItem.rightBarButtonItem?.title = favorite ? "즐겨찾기 해제" : "즐겨찾기 추가"
    }
    
    override func viewDidLoad() {
        self.webView.uiDelegate = self
        self.webView.navigationDelegate = self
        self.attachmentView.delegate = self
        self.attachmentView.dataSource = self
        self.attachmentView.tableFooterView = UIView()
        
        self.attachViewHeightConstraint.constant = 0
        self.navigationItem.title = "상세보기"
        
        self.titleLabel.text = noticeTitle ?? ""
        self.dateLabel.text = noticeDay ?? ""
        self.presenter = NoticeDetailPresenter(view: self)
        
        self.showProgressBar()
        
        // Retrieve Favorite Information
        if let title = noticeTitle, let day = noticeDay, let code = departmentCode {
            if self.presenter.isNoticeFavorite(title: title, date: day, major: code) {
                // Favorite Notice
                isFavorite = true
            } else {
                // Non-Favorite Notice
                isFavorite = false
            }
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: isFavorite ? "즐겨찾기 해제" : "즐겨찾기 추가", style: .plain, target: self, action: #selector(favoriteTapped))
        
        Alamofire.request(detailURL!).responseString { response in
            switch(response.result) {
            case .success(_):
                guard let text = response.data else { return }
                let data = String(data: text, encoding: .utf8) ?? String(decoding: text, as: UTF8.self)
                do {
                    let doc = try HTML(html: data, encoding: .utf8)
                    switch(self.departmentCode!) {
                    case DeptCode.Soongsil:
                        self.presenter.parseSoongsil(html: doc, completion: self.showWebViewPage)
                        break
                    case DeptCode.IT_Computer:
                        self.presenter.parseComputer(html: doc, completion: self.showWebViewPage)
                        break
                    case DeptCode.IT_Electric:
                        self.presenter.parseElectric(html: doc, completion: self.showWebViewPage)
                        break
                    case DeptCode.IT_Software:
                        self.presenter.parseSoftware(html: doc, completion: self.showWebViewPage)
                        break
                    case DeptCode.IT_Media:
                        self.presenter.parseMedia(html: doc, completion: self.showWebViewPage)
                        break
                    case DeptCode.IT_SmartSystem:
                        self.hideProgressBar()
                        self.webView.load(URLRequest(url: URL(string: self.detailURL ?? "")!))
                        break
                    case DeptCode.LAW_Law:
                        self.presenter.parseLaw(html: doc, completion: self.showWebViewPage)
                        break
                    case DeptCode.LAW_IntlLaw:
                        self.presenter.parseIntlLaw(html: doc, completion: self.showWebViewPage)
                        break
                    case DeptCode.Inmun_Korean:
                        self.presenter.parseInmun(html: doc, host: "http://korlan.ssu.ac.kr", completion: self.showWebViewPage)
                        break
                    case DeptCode.Inmun_French:
                        self.presenter.parseInmun(html: doc, host: "http://france.ssu.ac.kr", completion: self.showWebViewPage)
                        break
                    case DeptCode.Inmun_German:
                        self.presenter.parseInmun(html: doc, host: "http://gerlan.ssu.ac.kr", completion: self.showWebViewPage)
                        break
                    case DeptCode.Inmun_Chinese:
                        self.presenter.parseInmun(html: doc, host: "http://chilan.ssu.ac.kr",completion: self.showWebViewPage)
                        break
                    case DeptCode.Inmun_English:
                        self.presenter.parseInmun(html: doc, host: "http://englan.ssu.ac.kr", completion: self.showWebViewPage)
                        break
                    case DeptCode.Inmun_History:
                        self.presenter.parseInmun(html: doc, host: "http://history.ssu.ac.kr", completion: self.showWebViewPage)
                        break
                    case DeptCode.Inmun_Philosophy:
                        self.presenter.parseInmun(html: doc, host: nil, completion: self.showWebViewPage)
                        break
                    case DeptCode.Inmun_Japanese:
                        self.presenter.parseInmun(html: doc, host: "http://japanstu.ssu.ac.kr", completion: self.showWebViewPage)
                        break
                    case DeptCode.Engineering_Chemistry:
                        self.presenter.parseEngineerChemistry(html: doc, completion: self.showWebViewPage)
                        break
                    case DeptCode.Engineering_Machine:
                        self.presenter.parseEngineerMachine(html: doc, host: "http://me.ssu.ac.kr", completion: self.showWebViewPage)
                        break
                    case DeptCode.Engineering_Electonic:
                        self.presenter.parseEngineerElectric(html: doc, host: "http://ee.ssu.ac.kr", completion: self.showWebViewPage)
                        break
                    case DeptCode.Engineering_Industrial:
                        self.presenter.parseEngineerIndustry(html: doc, host: "http://iise.ssu.ac.kr", completion: self.showWebViewPage)
                        break
                    case DeptCode.Engineering_Architect:
                        self.presenter.parseEngineerArchitect(html: doc, host: "http://soar.ssu.ac.kr", completion: self.showWebViewPage)
                        break
                    case DeptCode.Engineering_Organic:
                        self.hideProgressBar()
                        self.webView.load(URLRequest(url: URL(string: self.detailURL ?? "")!))
                        break
                    case DeptCode.NaturalScience_Math:
                        self.presenter.parseNaturalMath(html: doc, host: nil, completion: self.showWebViewPage)
                        break
                    case DeptCode.NaturalScience_Physics:
                        self.presenter.parseNaturalPhysics(html: doc, host: nil, completion: self.showWebViewPage)
                        break
                    case DeptCode.NaturalScience_Chemistry:
                        self.presenter.parseNaturalChemistry(html: doc, host: nil, completion: self.showWebViewPage)
                        break
                    case DeptCode.NaturalScience_Actuarial:
                        self.presenter.parseNaturalActuarial(html: doc, host: nil, completion: self.showWebViewPage)
                        break
                    case DeptCode.NaturalScience_Medical:
                        self.presenter.parseNaturalMedical(html: doc, host: nil, completion: self.showWebViewPage)
                        break
                    case DeptCode.Business_biz:
                        self.presenter.parseBusinessBiz(html: doc, host: "http://biz.ssu.ac.kr", completion: self.showWebViewPage)
                        break
                    case DeptCode.Business_venture:
                        self.presenter.parseBusinessVenture(html: doc, host: "http://ensb.ssu.ac.kr", completion: self.showWebViewPage)
                        break
                    case DeptCode.Business_Account:
                        self.presenter.parseBusinessAccount(html: doc, host: "http://accounting.ssu.ac.kr", completion: self.showWebViewPage)
                        break
                    case DeptCode.Business_Finance:
                        self.presenter.parseBusinessFinance(html: doc, host: "http://finance.ssu.ac.kr", completion: self.showWebViewPage)
                        break
                    case DeptCode.Economy_Economics:
                        self.presenter.parseEconomyEconomics(html: doc, host:"http://eco.ssu.ac.kr", completion: self.showWebViewPage)
                        break
                    case DeptCode.Economy_GlobalCommerce:
                        self.presenter.parseEconomyGlobalCommerce(html: doc, host:nil, completion: self.showWebViewPage)
                        break
                    case DeptCode.Social_Welfare:
                        self.presenter.parseSocialWelfare(html: doc, host:nil, completion: self.showWebViewPage)
                        break
                    case DeptCode.Social_Administration:
                        self.presenter.parseSocialAdministration(html: doc, host:"http://pubad.ssu.ac.kr", completion: self.showWebViewPage)
                        break
                    case DeptCode.Social_Sociology:
                        self.presenter.parseSocialSociology(html: doc, host:"http://inso.ssu.ac.kr", completion: self.showWebViewPage)
                        break
                    case DeptCode.Social_Journalism:
                        self.presenter.parseSocialJournalism(html: doc, host:"http://pre.ssu.ac.kr", completion: self.showWebViewPage)
                        break
                    case DeptCode.Social_LifeLong:
                        self.presenter.parseSocialLifeLong(html: doc, host: "http://lifelongedu.ssu.ac.kr", completion: self.showWebViewPage)
                        break
                    case DeptCode.Social_Political:
                        self.presenter.parseSocialPolitical(html: doc, host: "http://pre.ssu.ac.kr", completion: self.showWebViewPage)
                        break
                    case DeptCode.MIX_mix:
                        self.presenter.parseConvergence(html: doc, host: "http://pre.ssu.ac.kr", completion: self.showWebViewPage)
                        break
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
    
    @objc func favoriteTapped() {
        print("FavoriteTapped")
        // UPDATE Core Data
        // Retrieve New Core Data
        self.isFavorite = !self.isFavorite
        self.presenter.setFavorite(notice: self.noticeItem!, majorCode: self.departmentCode!, favorite: self.isFavorite)
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
        
        self.hideProgressBar()
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
            cell.majorCode = self.departmentCode
            
            print("FINAL")
            print(attachments[indexPath.row].fileURL)
        }
        cell.selectionStyle  = .none
        
        return cell
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
