//
//  MediaType.swift
//  iTunesPractice
//
//  Created by Serge Rylko on 29.05.22.
//

import Foundation

public enum MediaType:  String, Decodable, CaseIterable {
    case music = "music"
    case book = "ebook"
    case soft = "software"
}
