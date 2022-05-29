//
//  CellVM.swift
//  iTunesPractice
//
//  Created by Serge Rylko on 24.05.22.
//

import Foundation
import Combine
import Interfaces

protocol SearchResultModelDelegate: AnyObject {
    func getFavouritePublisher(viewModel: SearchResultCellVM, for item: TunesItem) -> AnyPublisher<Bool, Never>
    func didSelectFavourite(viewModel: SearchResultCellVM, item: TunesItem)
    func didLoadImageData(viewModel: SearchResultCellVM, item: TunesItem, imageData: Data?)
}

final class SearchResultCellVM {
    
    typealias ImageDataRequest = ((Data?) -> Void)
    
    @Published
    var isFavourite = false
    
    @Published
    private(set) var title: String?

    @Published
    private(set) var imageURL: URL
    
    @Published
    var imageData: Data?
    
    let dataSubscription = PassthroughSubject<ImageDataRequest, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
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
        dataSubscription.send { [weak self] data in
            guard let self = self else { return }
            self.delegate.didLoadImageData(viewModel: self, item: self.item, imageData: data)
        }
        dataSubscription.send(completion: .finished)

        delegate.didSelectFavourite(viewModel: self, item: item)
    }
    
    func getDataRequestPublisher() -> AnyPublisher<ImageDataRequest, Never> {
        dataSubscription
            .eraseToAnyPublisher()
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
