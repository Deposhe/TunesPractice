//
//  FavouriteButton.swift
//  iTunesPractice
//
//  Created by Serge Rylko on 26.05.22.
//

import UIKit

class FavouriteButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        setImage(.init(named: "star_unselected"), for: .normal)
        setImage(.init(named: "star_selected"), for: .selected)
    }
}
