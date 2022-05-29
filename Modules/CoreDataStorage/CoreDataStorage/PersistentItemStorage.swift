//
//  PersistentItemStorage.swift
//  CoreDataStorage
//
//  Created by Serge Rylko on 29.05.22.
//

import Combine
import CoreData
import Interfaces
import Foundation

public final class PersistentItemStorage: ItemStorage {
    
    @Published
    private var tunesItems: [TunesItem] = []
    
    private let coreData = CoreDataFacade()
    
    private var viewContext: NSManagedObjectContext { coreData.persistentContainer.viewContext }
    
    public init() {
        refresh()
    }
    
    public func get(itemBy id: String) -> TunesItem? {
        refresh()
        return tunesItems.first(where: { $0.id == id })
    }
    
    public func save(item: TunesItem) {
        let entity = DBITunesItem(context: viewContext, item: item)
        try? coreData.save(entity)
        refresh()
    }
    
    public func remove(item: TunesItem) {
        try? coreData.remove(by: item.id)
        refresh()
    }
    
    public func getItems() -> [TunesItem] {
        refresh()
        return tunesItems
    }
    
    public func getItemsPublisher() -> AnyPublisher<[TunesItem], Never> {
        $tunesItems.eraseToAnyPublisher()
    }
    
    public func refresh() {
        guard let dbItems = try? coreData.requestDBTunesItems() else { return }
        tunesItems = dbItems.map { TunesItem(from: $0) }
    }
}
