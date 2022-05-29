//
//  PersistentDataProvider.swift
//  iTunesPractice
//
//  Created by Serge Rylko on 29.05.22.
//

import Foundation
import CoreData

final class PersistentDataProvider {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "iTunesPractice")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
    
    func requestDBTunesItems() throws -> [DBITunesItem] {
        let fetchRequest = DBITunesItem.fetchRequest()
        return try persistentContainer.viewContext.fetch(fetchRequest)
    }
    
    func save(_ item: DBITunesItem) throws {
        persistentContainer.viewContext.insert(item)
        try save()
    }
    
    func remove(by itemId: String) throws {
        let context = persistentContainer.viewContext
        let fetchRequest = DBITunesItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "trackId == \(itemId)", itemId)
        if let result = try context.fetch(fetchRequest).first {
            context.delete(result)
            try save()
        }
    }
    
    private func save() throws {
        try persistentContainer.viewContext.save()
    }
}
