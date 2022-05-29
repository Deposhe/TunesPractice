//
//  NetworkingInterface.swift
//  Networking
//
//  Created by Serge Rylko on 29.05.22.
//

import Foundation
import Combine

public protocol Networking {
    func request(searchText: String, mediaTypes: [MediaType]) -> AnyPublisher<[TunesItem], Error>
}
