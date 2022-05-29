//
//  Publisher+Collection.swift
//  iTunesPractice
//
//  Created by Serge Rylko on 26.05.22.
//

import Combine
import Foundation

extension Publisher where Output: Collection {
    
    func replaceEmptyCollection(with output: Self.Output) -> AnyPublisher<Self.Output, Failure> {
        
        return self
            .map { $0.isEmpty ? output : $0 }
            .eraseToAnyPublisher()
    }
}
