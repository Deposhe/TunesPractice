//
//  PersistentStorage.swift
//  iTunesPractice
//
//  Created by Serge Rylko on 27.05.22.
//

import Interfaces

final class StorageService: Storage {
    
    let itemStorage: ItemStorage
    
    init(itemStorage: ItemStorage) {
        self.itemStorage = itemStorage
    }
}

