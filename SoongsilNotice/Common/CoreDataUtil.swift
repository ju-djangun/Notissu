//
//  CoreDataUtil.swift
//  Notissu
//
//  Copyright © 2020 Notissu. All rights reserved.
//

import Foundation
import CoreData

struct FavoriteNotice {
    var notice: Notice
    var deptCode: DeptCode
//    var deptName: DeptName
}

class CoreDataUtil {
    static let shared = CoreDataUtil()
    
    lazy var persistentContainer: NSPersistentContainer = {
            let container = NSCustomPersistentContainer(name: "FavoriteNotice")
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            return container
        }()
    
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

class NSCustomPersistentContainer: NSPersistentContainer {
    override open class func defaultDirectoryURL() -> URL {
        var storeURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.elliott.Notissu")
        storeURL = storeURL?.appendingPathComponent("Notissu.sqlite")
        return storeURL!
    }

}
