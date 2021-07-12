//
//  PersistenceManager.swift
//  TestCode
//
//  Created by Ahmad Mohammadi on 6/8/21.
//

import Foundation
import CoreData

final class PersistenceManager {
    
    private init() {
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
    }
    static let shared = PersistenceManager()
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TestCode")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    lazy var context = persistentContainer.viewContext
    
    // MARK: - Core Data Saving support

    func save () {
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
