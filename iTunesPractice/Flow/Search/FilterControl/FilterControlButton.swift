//
//  MediaButton.swift
//  iTunesPractice
//
//  Created by Serge Rylko on 24.05.22.
//

import UIKit

class FilterControlButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {

        layer.cornerRadius = 5
        layer.borderWidth = 2
        layer.borderColor = UIColor.red.cgColor
        
        layer.masksToBounds = true
        
        titleLabel?.textColor = .red
        
        setTitleColor(.white, for: .selected)
        setTitleColor(.red, for: .normal)
        setTitleColor(UIColor.red.withAlphaComponent(0.6), for: .highlighted)

        setBackgroundImage(.init(named: "btn_filter_unselected"), for: .normal)
        setBackgroundImage(.init(named: "btn_filter_selected"), for: .selected)
        setBackgroundImage(.init(named: "btn_filter_selected"), for: .highlighted)
    }
}
