//
//  FavoriteFetcher.swift
//  SoongsilNotice
//
//  Created by Denny on 2020/09/20.
//  Copyright © 2020 TaeinKim. All rights reserved.
//

import Foundation
import CoreData

public class FavoriteFetcher {
    public static let shared: FavoriteFetcher = FavoriteFetcher()
    private init() { }
    
    func fetchFavoriteNotice() -> [Notice] {
        let context = CoreDataUtil.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")
        var results: [Notice] = [Notice]()
//        self.model.removeAllFavoriteNotice()
        
        do {
            let result = try context.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                let author = data.value(forKey: "author") as! String
                let title = data.value(forKey: "title") as! String
                let url = data.value(forKey: "url") as! String
                let date = data.value(forKey: "date") as! String
                let isNotice = data.value(forKey: "isNotice") as! Bool
                
                results.append(Notice(author: author, title: title, url: url, date: date, isNotice: isNotice))
//                self.model.appendFavoriteNotice(notice: Notice(author: author, title: title, url: url, date: date, isNotice: isNotice))
            }
        } catch {
            print("ERROR")
        }
//        return self.model.favoriteNoticeList
        return results
    }
}
