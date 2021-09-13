//
//  NoticeDetailPresenter.swift
//  Notissu
//
//  Copyright © 2019 Notissu. All rights reserved.
//

import CoreData
import Foundation
import JavaScriptCore
import Kanna

class NoticeDetailPresenter: NoticeDetail {
    private var view: NoticeDetailView?
    
    init(view: NoticeDetailView) {
        self.view = view
    }
    
    func isNoticeFavorite(title: String, date: String, major: DeptCode) -> Bool {
        // Retrieve Data From Core Data
        // Favorite 여부를 확인하여 View 에 적용하기 위한 함수
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
    
    func setFavorite(notice: Notice, majorCode: DeptCode, favorite: Bool) {
        // isFavorite이 참이면 Create하고 거짓이면 Delete한다.
        if favorite {
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
