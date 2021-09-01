//
//  NoticeListPresenter.swift
//  Notissu
//
//  Copyright © 2019 Notissu. All rights reserved.
//

import Foundation
import CoreData
import Kanna
import UIKit

class NoticeListPresenter: NoticePresenter {
    var view: NoticeListView
    
    init(view: NoticeListView) {
        self.view = view
    }
    
    func fetchFavoriteNoticeList() {
        let managedContext = CoreDataUtil.shared.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Favorite")
        var resultCount: Int = 0
        do {
            let result = try managedContext.fetch(fetchRequest)
            var favoriteList = [Notice]()
            
            for notice in result as! [NSManagedObject] {
                resultCount += 1
                
                let title = notice.value(forKey: "title") as! String
                let url = notice.value(forKey: "url") as! String
                let date = notice.value(forKey: "date") as! String
                let author = notice.value(forKey: "author") as! String
                let isNotice = notice.value(forKey: "isNotice") as! Bool
//                let deptCode = notice.value(forKey: "deptCode") as! Int
                
                favoriteList.append(Notice(author: author, title: title, url: url, date: date, isNotice: isNotice))
            }
            self.view.applyToTableView(list: favoriteList)
            print("Retrieve Notice : \(resultCount)")
            
        } catch {
            print("ERROR")
        }
    }
    
    func loadNoticeList(page: Int, keyword: String?, deptCode: DeptCode) {
        NoticeParser.shared.parseNoticeList(type: deptCode, page: page, keyword: keyword, completion: self.view.applyToTableView)
    }
    
}

