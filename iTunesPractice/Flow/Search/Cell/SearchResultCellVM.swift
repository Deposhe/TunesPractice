//
//  CellVM.swift
//  iTunesPractice
//
//  Created by Serge Rylko on 24.05.22.
//

import Foundation
import Combine

protocol SearchResultModelDelegate: AnyObject {
    func getFavouritePublisher(viewModel: SearchResultCellVM, for item: TunesItem) -> AnyPublisher<Bool, Never>
    func didSelectFavourite(viewModel: SearchResultCellVM, item: TunesItem)
}

final class SearchResultCellVM {
    
    @Published
    var isFavourite = false
    
    @Published
    private(set) var title: String?

    @Published
    private(set) var imageURL: URL
    
    private let item: TunesItem
    private unowned let delegate: SearchResultModelDelegate

    init(item: TunesItem, delegate: SearchResultModelDelegate) {
        self.item = item
        self.delegate = delegate
        self.title = item.title
        self.imageURL = item.imageURL
        
        setupSubscriptions()
    }
    
    private func setupSubscriptions() {
        delegate.getFavouritePublisher(viewModel: self, for: item)
            .assign(to: &$isFavourite)
    }
    
    func didPressFavouriteButton() {
        delegate.didSelectFavourite(viewModel: self, item: item)
    }
}

extension SearchResultCellVM: Hashable {
    static func == (lhs: SearchResultCellVM, rhs: SearchResultCellVM) -> Bool {
        lhs.item.id == rhs.item.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(item.id)
    }
}
