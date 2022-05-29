//
//  Collection+Optionals.swift
//  iTunesPractice
//
//  Created by Serge Rylko on 27.05.22.
//

import Foundation

extension Collection {
    public subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
