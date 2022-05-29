//
//  Publisher+Debug.swift
//  iTunesPractice
//
//  Created by Serge Rylko on 27.05.22.
//

import Combine

extension Publisher {
    func tap( _ closure: @escaping (Self.Output) -> Void) ->  AnyPublisher<Self.Output, Failure> {
        return self.map { value in
            closure(value)
            return value
        }.eraseToAnyPublisher()
    }
}
