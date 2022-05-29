//
//  PersistentStorage.swift
//  iTunesPractice
//
//  Created by Serge Rylko on 27.05.22.
//

import Interfaces

final class StorageService: Storage {
    
    let itemStorage: ItemStorage
    let searchHistoryStorage: SearchHistoryStorage
    
    init(itemStorage: ItemStorage, searchHistoryStorage: SearchHistoryStorage) {
        self.itemStorage = itemStorage
        self.searchHistoryStorage = searchHistoryStorage
    }
}

