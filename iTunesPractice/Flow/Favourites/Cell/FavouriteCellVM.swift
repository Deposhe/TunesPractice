//
//  FavouriteCellVM.swift
//  iTunesPractice
//
//  Created by Serge Rylko on 27.05.22.
//

import Combine
import Foundation
import Interfaces

protocol FavouriteCellViewModelDelegate: AnyObject {
    func didRemoveItem(delegate: FavouriteCellVM, item: TunesItem)
}

final class FavouriteCellVM {
    
    @Published
    private(set) var title: String?
    
    @Published
    private(set) var imageData: Data?
    
    private let item: TunesItem
    private unowned let delegate: FavouriteCellViewModelDelegate
    
    init(item: TunesItem, delegate: FavouriteCellViewModelDelegate) {
        self.item = item
        self.delegate = delegate
        self.title = item.title
        self.imageData = item.imageData
    }
    
    func didTapRemoveFavourite() {
        delegate.didRemoveItem(delegate: self, item: item)
    }
}

extension FavouriteCellVM: Hashable {
    static func == (lhs: FavouriteCellVM, rhs: FavouriteCellVM) -> Bool {
        lhs.item.id == rhs.item.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(item.id)
    }
}
