//
//  Storage.swift
//  iTunesPractice
//
//  Created by Serge Rylko on 27.05.22.
//

import Combine
import Foundation

protocol Storage {
    func get(itemBy id: String) -> TunesItem?
    func save(item: TunesItem)
    func remove(item: TunesItem)
    func getItems() -> [TunesItem]
    func getItemsPublisher() -> AnyPublisher<[TunesItem], Never>
}
