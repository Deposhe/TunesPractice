//
//  ITunesAPI.swift
//  Neworking
//
//  Created by Serge Rylko on 19.05.22.
//

import Foundation
import Combine
import Interfaces

enum NetworkingError: Error {
    case urlMissconfiguration
    case limitReached
}

final public class ITunesNetworking: Networking {

    private static let baseURL = URL(string: "https://itunes.apple.com/search")!
    private static let countryCode = "Us"
    
    private let session: URLSession = {
        URLSession(configuration: .default)
    }()
    
    public init() { }
    
    public func request(searchText: String, mediaTypes: [MediaType]) -> AnyPublisher<[TunesItem], Error> {

        let publisher = buildURLs(searchText: searchText, mediaTypes: mediaTypes)
            .tryCompactMap({ $0 })
            .flatMap { [unowned self] url in
                self.session.dataTaskPublisher(for: url)
                    .compactMap({ $0.data })
                    .decode(type: TunesResponse.self, decoder: JSONDecoder())
                    .compactMap({ $0.results })
                    .share()
            }
            .collect()
            .tryMap({ $0.flatMap({ $0 }) })
            .eraseToAnyPublisher()

        return publisher
    }
    
    private func buildURLs(searchText: String, mediaTypes: [MediaType]) -> Publishers.Sequence<[URL], NetworkingError> {

        let urls = mediaTypes.compactMap({ buildURL(searchText: searchText, mediaType: $0) })
        let publisher = urls
            .publisher
            .setFailureType(to: NetworkingError.self)

        return publisher
    }
    
    private func buildURL(searchText: String, mediaType: MediaType) -> URL? {
        
        var urlComponents = URLComponents(url: ITunesNetworking.baseURL, resolvingAgainstBaseURL: false)
        var queryItems = [URLQueryItem]()

        queryItems.append(.init(name: "term", value: searchText))
        queryItems.append(.init(name: "country", value: ITunesNetworking.countryCode))
        queryItems.append(.init(name: "media", value: mediaType.rawValue))
        urlComponents?.queryItems = queryItems
        
        if let result = urlComponents?.url {
            return result
        } else {
            assertionFailure("url can not be composed")
            return nil
        }
    }
}
