//
//  NoticeDetailViewModel.swift
//  SoongsilNotice
//
//  Copyright © 2021 Notissu. All rights reserved.
//

import Foundation
import Alamofire
import Kanna

protocol NoticeDetailViewModelInput {
    func loadWebView()
}

protocol NoticeDetailViewModelOutput {
    var title: String? { get }
    var caption: String? { get }
    var html: Dynamic<String> { get }
}


class NewNoticeDetailViewModel: NoticeDetailViewModelInput, NoticeDetailViewModelOutput {
    
    //  MARK: - OUTPUT
    
    let title: String?
    let caption: String?
    let html: Dynamic<String> = Dynamic("")
    let url: Dynamic<String> = Dynamic("")
    
    
    //  MARK: - INPUT
    
    func loadWebView() {
        loadContentFromURL(string: notice.url ?? "google.com")
    }
    
    //  MARK: - 그 외
    
    let notice: Notice
    let departmentCode: DeptCode?
    
    init(notice: Notice, deptCode: DeptCode) {
        self.notice = notice
        self.title = notice.title
        self.caption = notice.date
        self.departmentCode = deptCode
    }
    
    
}

extension NewNoticeDetailViewModel {
    private func loadContentFromURL(string: String) {
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
//                                self.webView.load(URLRequest(url: URL(string: self.detailURL ?? "")!))
                                self.url.value = self.notice.url ?? ""
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
        self.html.value = html
    }
}
