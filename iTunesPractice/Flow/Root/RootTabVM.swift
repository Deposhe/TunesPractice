//
//  RootVM.swift
//  iTunesPractice
//
//  Created by Serge Rylko on 27.05.22.
//

import Combine

final class RootTabVM {
    
    @Published
    private (set) var badgeValue: String?
    
    private lazy var networking: Networking = ITunesNetworking()
    private lazy var storage: Storage = PersistentStorage()
    private lazy var searchVM = SearchVM(networking: networking, storage: storage)
    private lazy var favouritesVM = FavouritesVM(storage: storage)
 
    init() {
        setupSubscriptions()
    }
    
    private func setupSubscriptions() {
        storage
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
