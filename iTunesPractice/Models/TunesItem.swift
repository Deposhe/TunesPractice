//
//  TunesItem.swift
//  iTunesPractice
//
//  Created by Serge Rylko on 23.05.22.
//

import Foundation

final class TunesItem {
    
    let title: String
    let id: String
    let imageURL: URL
    
    init(title: String, id: String, imageURL: URL) {
        self.title = title
        self.id = id
        self.imageURL = imageURL
    }
}

extension TunesItem: Hashable {
    
    static func == (lhs: TunesItem, rhs: TunesItem) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
