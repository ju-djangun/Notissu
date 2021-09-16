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
    func didSelectAttachmentItem(at: Int)
}

protocol NoticeDetailViewModelOutput {
    var title: String? { get }
    var caption: String? { get }
    var html: Dynamic<String> { get }
    var attachments: Dynamic<[Attachment]> { get }
}


class NewNoticeDetailViewModel: NoticeDetailViewModelInput, NoticeDetailViewModelOutput {
    
    //  MARK: - OUTPUT
    
    let title: String?
    let caption: String?
    let html: Dynamic<String> = Dynamic("")
    let url: Dynamic<String> = Dynamic("")
    let attachments: Dynamic<[Attachment]> = Dynamic([])
    var fileDownloaderDelegate: FileDownloaderDelegate?
    
    
    //  MARK: - INPUT
    
    func loadWebView() {
        if let url = notice.url {
            loadContentFromURL(string: url)
        }
    }
    
    func didSelectAttachmentItem(at index: Int) {
        downloadFile(at: index)
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
        self.attachments.value = attachments
    }
}

extension NewNoticeDetailViewModel {
    private func downloadFile(at index: Int) {
        let attachment = self.attachments.value[index]
        
        var encodedURL: String
        switch(departmentCode) {
        case .LAW_IntlLaw,
             .Inmun_Korean,
             .Inmun_French,
             .Inmun_Chinese,
             .Inmun_English,
             .Inmun_History,
             .Inmun_Philosophy,
             .Inmun_Japanese,
             .Inmun_Writing,
             .Engineering_Machine,
             .Engineering_Industrial,
             .NaturalScience_Math,
             .NaturalScience_Physics,
             .NaturalScience_Chemistry,
             .NaturalScience_Medical,
             .Business_biz,
             .Business_venture,
             .Business_Account,
             .Business_Finance,
             .Economy_Economics,
             .Economy_GlobalCommerce,
             .Social_Welfare,
             .Social_Administration,
             .Social_Sociology,
             .Social_Journalism,
             .Social_LifeLong,
             .Social_Political,
             .MIX_mix:
            encodedURL = attachment.fileURL
        default:
            encodedURL = attachment.fileURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        }
        
        let destination: DownloadRequest.Destination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(attachment.fileName)
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        AF.download(encodedURL, to: destination)
            .downloadProgress { progress in
                print("Download Progress: \(progress.fractionCompleted)")
        }
        .response { response in
            debugPrint(response)
            
            if let filePath = response.fileURL?.path {
                self.fileDownloaderDelegate?.didFileDownloaded(at: filePath)
            } else {
                self.fileDownloaderDelegate?.didFileDownloaded(at: nil)
            }
        }
    }
}

protocol FileDownloaderDelegate {
    func didFileDownloaded(at filePath: String?)
}
