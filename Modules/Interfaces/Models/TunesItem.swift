//
//  TunesItem.swift
//  iTunesPractice
//
//  Created by Serge Rylko on 23.05.22.
//

import Foundation

final public class TunesItem {
    
    public let title: String
    public let id: String
    public let imageURL: URL
    public var imageData: Data?
    
    public init(title: String, id: String, imageURL: URL, imageData: Data?) {
        self.title = title
        self.id = id
        self.imageURL = imageURL
        self.imageData = imageData
    }
}

extension TunesItem: Hashable {
    
    public static func == (lhs: TunesItem, rhs: TunesItem) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
