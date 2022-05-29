//
//  PersistentDataProvider.swift
//  iTunesPractice
//
//  Created by Serge Rylko on 29.05.22.
//

import Foundation
import CoreData

final class CoreDataFacade {
    
    lazy var persistentContainer = makeContainer()
    
    //MARK: - DBITunesItem
    func requestDBTunesItems() throws -> [DBITunesItem] {
        let fetchRequest = DBITunesItem.fetchRequest()
        return try persistentContainer.viewContext.fetch(fetchRequest)
    }
    
    func save(_ dbItem: DBITunesItem) throws {
        persistentContainer.viewContext.insert(dbItem)
        try save()
    }
    
    func remove(by dbItemId: String) throws {
        let dbItem = try getItem(by: dbItemId)
        
        if let dbItem = dbItem {
            let context = persistentContainer.viewContext
            context.delete(dbItem)
            try save()
        }
    }
    
    func getItem(by dbItemId: String) throws -> DBITunesItem? {
        let context = persistentContainer.viewContext
        let fetchRequest = DBITunesItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "trackId == %@", dbItemId)
        let result = try context.fetch(fetchRequest).first
        
        return result
    }
    
    // MARK: - Supplementary
    private func save() throws {
        try persistentContainer.viewContext.save()
    }
    
    private func makeContainer() -> NSPersistentContainer {
        let bundle = Bundle.init(for: CoreDataFacade.self)
        guard
            let url = bundle.url(forResource: "iTunesPractice", withExtension: "momd"),
            let mom = NSManagedObjectModel(contentsOf: url)
        else {
            fatalError()
        }
        
        let container = NSPersistentContainer(name: "iTunesPracticeDB", managedObjectModel: mom)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }
}
