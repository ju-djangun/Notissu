//
//  NoticeDetailViewModel.swift
//  Notissu
//
//  Copyright © 2021 Notissu. All rights reserved.
//

import CoreData
import Foundation
import Alamofire
import Kanna

protocol NoticeDetailViewModelInput {
    func loadWebView()
    func attachmentItemDidSelect(at: Int)
    func bookmarkButtondidTap()
}

protocol NoticeDetailViewModelOutput {
    var title: String? { get }
    var caption: String? { get }
    var html: Dynamic<String> { get }
    var url: Dynamic<String> { get }
    var attachments: Dynamic<[Attachment]> { get }
    var isBookmarked: Dynamic<Bool> { get }
    var shouldDividerBeHidden: Dynamic<Bool> { get }
    var downloadedFilePath: Dynamic<String?> { get }
}

protocol NoticeDetailViewModelProtocol: NoticeDetailViewModelInput, NoticeDetailViewModelOutput {}

class NoticeDetailViewModel: NoticeDetailViewModelProtocol {
    
    //  MARK: - OUTPUT
    let title: String?
    let caption: String?
    let html: Dynamic<String> = Dynamic("")
    let url: Dynamic<String> = Dynamic("")
    let attachments: Dynamic<[Attachment]> = Dynamic([])
    let isBookmarked: Dynamic<Bool> = Dynamic(false)
    let shouldDividerBeHidden: Dynamic<Bool> = Dynamic(true)
    var downloadedFilePath: Dynamic<String?> = Dynamic(nil)
    
    //  MARK: - INPUT
    func loadWebView() {
        if let url = notice.url {
            loadContentFromURL(string: url)
        }
    }
    
    func attachmentItemDidSelect(at index: Int) {
        downloadFile(at: index)
    }
    
    func bookmarkButtondidTap() {
        isBookmarked.value = !isBookmarked.value
        setFavorite()
    }
    
    //  MARK: - Property
    private let notice: Notice
    private let departmentCode: DeptCode?
    private let date: String?
    
    
    //  MARK: - Init
    init(notice: Notice, deptCode: DeptCode) {
        self.notice = notice
        self.title = notice.title
        self.caption = notice.date
        self.date = notice.date
        self.url.value = notice.url ?? ""
        self.departmentCode = deptCode
        self.isBookmarked.value = isNoticeBookmarked()
    }
    
}

//  MARK: - Bookmark
extension NoticeDetailViewModel {
    private func isNoticeBookmarked() -> Bool {
        // Retrieve Data From Core Data
        // Favorite 여부를 확인하여 View 에 적용하기 위한 함수
        guard let title = self.title, let date = self.date, let major = self.departmentCode else { return false }
        let managedContext = CoreDataUtil.shared.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Favorite")
        fetchRequest.predicate = NSPredicate(format: "title = %@ AND date = %@ AND deptCode = %i", title, date, major.rawValue)
        var resultCount: Int = 0
        do {
            let result = try managedContext.fetch(fetchRequest)
            
            for _ in result as! [NSManagedObject] {
                resultCount += 1
            }
        } catch {
            print("ERROR")
        }
        
        if resultCount > 0 {
            return true
        }
        return false
    }
    
    private func setFavorite() {
        // isFavorite이 참이면 Create하고 거짓이면 Delete한다.
        guard let majorCode = self.departmentCode else { return }
        if isBookmarked.value {
            self.addFavorite(notice: notice, majorCode: majorCode.rawValue)
        } else {
            self.deleteFavorite(notice: notice, majorCode: majorCode.rawValue)
        }
    }
    
    private func deleteFavorite(notice: Notice, majorCode: Int) {
        let managedContext = CoreDataUtil.shared.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Favorite")
        fetchRequest.predicate = NSPredicate(format: "title = %@ AND date = %@ AND deptCode = %i", notice.title!, notice.date!, majorCode)
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            let objectToDelete = result[0] as! NSManagedObject
            managedContext.delete(objectToDelete)

            do {
                try managedContext.save()
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
    }
    
    private func addFavorite(notice: Notice, majorCode: Int) {
        let managedContext = CoreDataUtil.shared.persistentContainer.viewContext
        let favoriteEntity = NSEntityDescription.entity(forEntityName: "Favorite", in: managedContext)!
        let noticeObject = NSManagedObject(entity: favoriteEntity, insertInto: managedContext)
        
        noticeObject.setValue(notice.author, forKey: "author")
        noticeObject.setValue(notice.date, forKey: "date")
        noticeObject.setValue(majorCode, forKey: "deptCode")
        noticeObject.setValue(notice.isNotice, forKey: "isNotice")
        noticeObject.setValue(notice.title, forKey: "title")
        noticeObject.setValue(notice.url, forKey: "url")
        noticeObject.setValue(notice.hasAttachment, forKey: "hasAttachment")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}

//  MARK: - Webview load
extension NoticeDetailViewModel {
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
        case .IT_Media:
            AF.request(url).responseData(completionHandler: { response in
                switch(response.result) {
                case .success(let data):
                    let utf8Text = String(data: data, encoding: .utf8) ?? String(decoding: data, as: UTF8.self)
                    self.parseNoticeDetail(html: utf8Text)
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
        self.shouldDividerBeHidden.value = attachments.isEmpty
    }
}

//  MARK: - Download file
extension NoticeDetailViewModel {
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
            self.downloadedFilePath.value = response.fileURL?.path
        }
    }
}
