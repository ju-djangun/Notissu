//
//  CoreDataUtil.swift
//  SoongsilNotice
//
//  Created by TaeinKim on 2020/02/16.
//  Copyright © 2020 TaeinKim. All rights reserved.
//

import Foundation
import CoreData

struct FavoriteNotice {
    var notice: Notice
    var deptCode: DeptCode
}

class CoreDataUtil {
    static let shared = CoreDataUtil()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FavoriteNotice")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
//
//    lazy var persistentContainer: NSPersistentContainer = {
//        let container = NSPersistentContainer(name: "FavoriteNotice")
//        let storeURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.elliott.Notissu")!.appendingPathComponent("FavoriteNotice.sqlite")
//
//        var defaultURL: URL?
//        if let storeDescription = container.persistentStoreDescriptions.first, let url = storeDescription.url {
//            defaultURL = FileManager.default.fileExists(atPath: url.path) ? url : nil
//        }
//
//        if defaultURL == nil {
//            container.persistentStoreDescriptions = [NSPersistentStoreDescription(url: storeURL)]
//        }
//        container.loadPersistentStores(completionHandler: { [unowned container] (storeDescription, error) in
//            if let error = error as NSError? {
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//
//            if let url = defaultURL, url.absoluteString != storeURL.absoluteString {
//                let coordinator = container.persistentStoreCoordinator
//                if let oldStore = coordinator.persistentStore(for: url) {
//                    do {
//                        try coordinator.migratePersistentStore(oldStore, to: storeURL, options: nil, withType: NSSQLiteStoreType)
//                    } catch {
//                        print(error.localizedDescription)
//                    }
//
//                    // delete old store
//                    let fileCoordinator = NSFileCoordinator(filePresenter: nil)
//                    fileCoordinator.coordinate(writingItemAt: url, options: .forDeleting, error: nil, byAccessor: { url in
//                        do {
//                            try FileManager.default.removeItem(at: url)
//                        } catch {
//                            print(error.localizedDescription)
//                        }
//                    })
//                }
//            }
//        })
//        return container
//    }()
    
    private init() { }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
