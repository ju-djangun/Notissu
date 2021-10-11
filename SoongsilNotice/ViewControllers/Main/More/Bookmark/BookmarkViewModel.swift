//
//  BookmarkViewModel.swift
//  SoongsilNotice
//
//  Created by denny on 2021/10/11.
//  Copyright © 2021 Notissu. All rights reserved.
//

import CoreData
import Foundation

final class BookmarkViewModel {
    var bookmarkList: Dynamic<[FavoriteNotice]> = Dynamic([])
    
    func fetchBookmarkNotice() {
        let managedContext = CoreDataUtil.shared.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Favorite")
        var resultCount: Int = 0
        do {
            let result = try managedContext.fetch(fetchRequest)
            var favoriteList = [FavoriteNotice]()
            
            for notice in result as! [NSManagedObject] {
                resultCount += 1
                
                let title = notice.value(forKey: "title") as! String
                let url = notice.value(forKey: "url") as! String
                let date = notice.value(forKey: "date") as! String
                let author = notice.value(forKey: "author") as! String
                let isNotice = notice.value(forKey: "isNotice") as! Bool
                let deptCode = notice.value(forKey: "deptCode") as! Int
//                let deptName = notice.value(forKey: "deptName") as! String
                let hasAttachment = (notice.value(forKey: "hasAttachment") as? Bool) ?? false
                
                favoriteList.append(FavoriteNotice(notice: Notice(author: author, title: title, url: url, date: date, isNotice: isNotice, hasAttachment: hasAttachment), deptCode: DeptCode(rawValue: deptCode) ?? DeptCode.IT_Computer))
            }
            
            var tempList = bookmarkList.value
            tempList.removeAll()
            tempList.append(contentsOf: favoriteList)
            bookmarkList.value = tempList
        } catch {
            print("ERROR")
        }
    }
    
    func removeBookmark(bookmark: FavoriteNotice) {
        let managedContext = CoreDataUtil.shared.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Favorite")
        fetchRequest.predicate = NSPredicate(format: "title = %@ AND date = %@ AND deptCode = %i", bookmark.notice.title!, bookmark.notice.date!, bookmark.deptCode.rawValue)
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            let objectToDelete = result[0] as! NSManagedObject
            managedContext.delete(objectToDelete)

            do {
                try managedContext.save()
                
                var tempList = bookmarkList.value
                for (index, item) in tempList.enumerated() {
                    if item == bookmark {
                        tempList.remove(at: index)
                    }
                }
                bookmarkList.value = tempList
            } catch {
                print(error)
                return
            }
        } catch {
            print(error)
            return
        }
    }
}
