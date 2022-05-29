//
//  TunesResponse.swift
//  iTunesPractice
//
//  Created by Serge Rylko on 23.05.22.
//

import Foundation
import Interfaces

struct TunesResponse: Decodable {
    let results: [TunesItem]
}
