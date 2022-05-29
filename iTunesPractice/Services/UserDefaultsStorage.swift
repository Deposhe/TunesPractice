//
//  LocaHistoryStorage.swift
//  iTunesPractice
//
//  Created by Serge Rylko on 29.05.22.
//

import Combine
import Foundation
import Interfaces

final class UserDefaultsStorage: SearchHistoryStorage {

    private enum Keys {
        static let latestSearch = "search"
    }
    
    private lazy var userDefaults = UserDefaults.standard
    
    func getLatestSearchText() -> String? {
        userDefaults.value(forKey: Keys.latestSearch) as? String
    }
    
    func saveLatestSearchText(searchText: String?) {
        userDefaults.set(searchText, forKey: Keys.latestSearch)
    }
}
