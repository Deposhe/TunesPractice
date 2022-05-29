//
//  TunesItem+Decodable.swift
//  iTunesPractice
//
//  Created by Serge Rylko on 29.05.22.
//

import Foundation
import Interfaces

extension TunesItem: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case title = "trackName"
        case id = "trackId"
        case imageURL = "artworkUrl100"
    }
    
    convenience public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let title = try container.decode(String.self, forKey: .title)
        let integerId = try container.decode(Int.self, forKey: .id)
        let id = String(integerId)
        let imageURL = try container.decode(URL.self, forKey: .imageURL)
        
        self.init(title: title,
                  id: id,
                  imageURL: imageURL)
    }
}
