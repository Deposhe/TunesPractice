//
//  MediaSegmentControl.swift
//  iTunesPractice
//
//  Created by Serge Rylko on 24.05.22.
//

import Combine
import UIKit

class FilterControl: UIControl {

    @Published
    var selectedItems = Set<Int>()
    
    var items: [String] {
        didSet { setupUI() }
    }
    
    private var buttons: [UIButton] = []
    private var insets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
    
    private var cancellables = Set<AnyCancellable>()

    init(items: [String] = [], frame: CGRect = .zero) {
        self.items = items
        super.init(frame: frame)
        
        setupUI()
        setupBinding()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let buttonWidth = bounds.width / CGFloat(buttons.count)
        let buttonHeight = bounds.height
        let size = CGSize(width: buttonWidth, height: buttonHeight)
        
        buttons
            .enumerated()
            .map { (CGFloat($0.0), $0.1) }
            .forEach { (index, button) in
                let origin = CGPoint(x: index * buttonWidth, y: 0)
                let frame = CGRect(origin: origin, size: size)
                button.tag = Int(index)
                button.frame = frame.inset(by: insets)
            }
    }
    
    private func setupUI() {
        buttons.forEach({ $0.removeFromSuperview() })
 
        items.enumerated().forEach { (index, buttonTitle) in
            let button = FilterControlButton()
            button.setTitle(buttonTitle, for: .normal)
            button.tag = index
            
            // TODO: add custom publisher for UIControls
            button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
            buttons.append(button)
            addSubview(button)
        }
    }
    
    private func setupBinding() {
        $selectedItems
            .sink { [weak self] selected in
                self?.buttons.forEach { button in
                    button.isSelected = selected.contains(button.tag)
                }
            }.store(in: &cancellables)
    }
    
    @objc private func didTapButton(_ sender: UIButton) {
        select(index: sender.tag)
    }

    private func select(index: Int) {
        if selectedItems.contains(index) {
            selectedItems.remove(index)
        } else {
            selectedItems.insert(index)
        }
    }
}

