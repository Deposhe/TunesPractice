//
//  SearchVM.swift
//  iTunesPractice
//
//  Created by Serge Rylko on 24.05.22.
//

import Combine
import Foundation
import Interfaces

final class SearchVM {
    
    private enum Constants {
        static let debounce: DispatchQueue.SchedulerTimeType.Stride = .microseconds(2000)
        static let sorting: (SearchResultCellVM, SearchResultCellVM) -> Bool = { $0.title ?? "" < $1.title ?? "" }
    }
    
    private static var filters = [
        MediaType.soft,
        MediaType.music,
        MediaType.book
    ]
    
    @Published
    var searchText: String?
    
    @Published
    var selectedMediaTypeIndexes: Set<Int> = []
    
    @Published
    private(set) var cellViewModels: [SearchResultCellVM] = []
    
    @Published
    var mediaTitles = filters
        .map { $0.rawValue }
        .map { $0.capitalized }
    
    @Published
    private var storedItems: [TunesItem] = []
    private let subscribeScheduler = DispatchQueue(label: "SearchVM", qos: .userInteractive, attributes: .concurrent)
    private var cancellables = Set<AnyCancellable>()
    
    private let networking: Networking
//    private let storage: Storage
    private let itemsStorage: ItemStorage

    init(networking: Networking, storage: Storage) {
        self.networking = networking
        self.itemsStorage = storage.itemStorage
        setupSubscriptions()
    }
    
    private func setupSubscriptions() {
        getUserInputPublisher()
            .flatMap { [unowned self] (searchText, mediaTypes) in
                self.networking.request(searchText: searchText ?? "", mediaTypes: mediaTypes)
            }
            .replaceError(with: [])
            .subscribe(on: subscribeScheduler)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
            .map { $0.map { SearchResultCellVM(item: $0, delegate: self) } }
            .map { $0.sorted(by: Constants.sorting) }
            .assign(to: &$cellViewModels)
        
        itemsStorage.getItemsPublisher()
            .receive(on: DispatchQueue.main)
            .assign(to: &$storedItems)
    }
    
    private func getUserInputPublisher() -> AnyPublisher<(String?, [MediaType]), Never> {
        getSearchTextPublisher()
            .combineLatest(getSelectedFiltersPublisher())
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
            .removeDuplicates { $0.0 == $1.0 && $0.1 == $1.1 }
            .eraseToAnyPublisher()
    }
    
    private func getSearchTextPublisher() -> AnyPublisher<String?, Never> {
        $searchText
            .drop(while: { $0?.isEmpty == true })
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    private func getSelectedFiltersPublisher() -> AnyPublisher<[MediaType], Never> {
        $selectedMediaTypeIndexes
            .removeDuplicates()
            .compactMap({ Array($0) })
            .map({ $0.map { SearchVM.filters[$0] } })
            .replaceEmptyCollection(with: SearchVM.filters)
            .eraseToAnyPublisher()
    }
}

extension SearchVM: SearchResultModelDelegate {
    
    func getFavouritePublisher(viewModel: SearchResultCellVM, for item: TunesItem) -> AnyPublisher<Bool, Never> {
        $storedItems
            .map({ $0.contains(where: { $0.id == item.id }) })
            .eraseToAnyPublisher()
    }
    
    func didSelectFavourite(viewModel: SearchResultCellVM, item: TunesItem) {
        if storedItems.contains(item) {
            itemsStorage.remove(item: item)
        } else {
            itemsStorage.save(item: item)
        }
    } 
}

