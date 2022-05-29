//
//  RootVM.swift
//  iTunesPractice
//
//  Created by Serge Rylko on 27.05.22.
//

import CoreDataStorage
import Combine
import Interfaces
import Networking

final class RootTabVM {
    
    @Published
    private (set) var badgeValue: String?
    
    private lazy var networking: Networking = ITunesNetworking()
    private lazy var storage: Storage = StorageService(itemStorage: PersistentItemStorage())
    private lazy var searchVM = SearchVM(networking: networking, storage: storage)
    private lazy var favouritesVM = FavouritesVM(itemStorage: storage.itemStorage)
 
    init() {
        setupSubscriptions()
    }
    
    private func setupSubscriptions() {
        storage.itemStorage
            .getItemsPublisher()
            .map { $0.isEmpty ? nil : String($0.count) }
            .assign(to: &$badgeValue)
    }
    
    func getSearchViewModel() -> SearchVM {
        searchVM
    }
    
    func getFavouritesViewModel() -> FavouritesVM {
        favouritesVM
    }
    
    func getSearchTitle() -> String {
        "Search"
    }
    
    func getFavouritesTitle() -> String {
        "Farourites"
    }
    
    
}
