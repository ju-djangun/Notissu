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
        if let url = notice.url {
            loadContentFromURL(string: url)
        }
    }
    
    //  MARK: - 그 외
    
    private let notice: Notice
    private let departmentCode: DeptCode?
    
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
        
        switch self.departmentCode {
        case .IT_SmartSystem, .Engineering_Organic:
            self.url.value = url
            
        case .Inmun_Writing, .Dormitory:
            AF.request(url).responseData(completionHandler: { response in
                switch(response.result) {
                case .success(let data):
                    let responseString = NSString(data: data,
                                                  encoding:CFStringConvertEncodingToNSStringEncoding(0x0422))
                    if let responseString = responseString as String? {
                        self.parseNoticeDetail(html: responseString)
                    }
                case .failure(let error):
                    print(error)
                }
            })
            
        default:
            AF.request(url).responseString(completionHandler: { response in
                switch(response.result) {
                case .success(let string):
                    self.parseNoticeDetail(html: string)
                case .failure(let error):
                    print(error)
                }
            })
        }
    }
    
    private func parseNoticeDetail(html: String) {
        do {
            let doc = try HTML(html: html, encoding: .utf8)
            if let deptCode = self.departmentCode {
                NoticeParser.shared.parseNoticeDetail(html: doc,
                                                      type: deptCode,
                                                      completion: self.webViewContentUpdate)
            }
        } catch let error {
            print("ERROR : \(error)")
        }
    }
    
    private func webViewContentUpdate(attachments: [Attachment], html: String) {
        self.html.value = html
    }
}
