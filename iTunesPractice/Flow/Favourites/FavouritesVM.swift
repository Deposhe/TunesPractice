//
//  FavouritesVM.swift
//  iTunesPractice
//
//  Created by Serge Rylko on 26.05.22.
//

import Combine
import Foundation
import AVFoundation

final class FavouritesVM {

    typealias RemoveConfirmation = (Bool) -> Void
    
    private enum Constants {
        static let sorting: (FavouriteCellVM, FavouriteCellVM) -> Bool = { $0.title ?? "" < $1.title ?? "" }
    }
    
    @Published
    private(set) var cellViewModels: [FavouriteCellVM] = []
    private(set) var removeConfirmation = PassthroughSubject<RemoveConfirmation, Never>()
    private var removableItemTitle: String?
    
    private let storage: Storage
    private let soundService = SoundService()
    
    init(storage: Storage) {
        self.storage = storage
        setupSubscriptions()
    }
    
    private func setupSubscriptions() {
        storage.getItemsPublisher()
            .map { $0.map { FavouriteCellVM(item: $0, delegate: self) } }
            .map { $0.sorted(by: Constants.sorting) }
            .assign(to: &$cellViewModels)
    }
    
    private func performRemoveActions(for item: TunesItem) {
        storage.remove(item: item)
        removableItemTitle = nil
        soundService.play(.removeFavourite)
        
    }
    
    func alertTitleText() -> String {
        "Remove from Favourites"
    }
    
    func alertMessageText() -> String {
        "Do you really want to remove \(removableItemTitle ?? "an item")?"
    }
    
    func alertRemoveText() -> String {
        "Sure, Remove"
    }
    
    func alertCancelText() -> String {
        "Cancel"
    }
}

extension FavouritesVM: FavouriteCellViewModelDelegate {
    
    func didRemoveItem(delegate: FavouriteCellVM, item: TunesItem) {
        removableItemTitle = item.title
        
        let confirmation: RemoveConfirmation = {  [weak self] confirmed in
            if confirmed {
                self?.performRemoveActions(for: item)
            }
        }
        
        removeConfirmation.send(confirmation)
    }
}
