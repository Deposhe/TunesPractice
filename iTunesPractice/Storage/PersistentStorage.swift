//
//  PersistentStorage.swift
//  iTunesPractice
//
//  Created by Serge Rylko on 27.05.22.
//

import CoreData
import Foundation
import Combine

final class PersistentStorage {
    private let storeService = PersistentDataProvider()
    private var viewContext: NSManagedObjectContext { storeService.persistentContainer.viewContext }
    
    @Published
    private var tunesItems: [TunesItem] = []
    
    init() {
        refresh()
    }
    
    func save(tunesItem: TunesItem) throws {
        let entity = DBITunesItem(context: viewContext, item: tunesItem)
        try storeService.save(entity)
        refresh()
    }
    
    func remove(tunesItem: TunesItem) throws {
        try storeService.remove(by: tunesItem.id)
        refresh()
    }
    
    func refresh() {
        guard let dbItems = try? storeService.requestDBTunesItems() else { return }
        tunesItems = dbItems.map { TunesItem(from: $0) }
    }
}

extension PersistentStorage: Storage {
    func get(itemBy id: String) -> TunesItem? {
        refresh()
        return tunesItems.first(where: { $0.id == id })
    }
    
    func save(item: TunesItem) {
        try? save(tunesItem: item)
    }
    
    func remove(item: TunesItem) {
        try? remove(tunesItem: item)
    }
    
    func getItems() -> [TunesItem] {
        refresh()
        return tunesItems
    }
    
    func getItemsPublisher() -> AnyPublisher<[TunesItem], Never> {
        $tunesItems
            .eraseToAnyPublisher()
    }
}
