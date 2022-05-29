//
//  UIKit+Combine.swift
//  iTunesPractice
//
//  Created by Serge Rylko on 24.05.22.
//

import Combine
import UIKit

extension UISearchTextField {
    var textPublisher: AnyPublisher<String?, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap({ $0.object as? UITextField })
            .map({ $0.text })
            .eraseToAnyPublisher()
    }
}

extension UISearchBar {
    var textPublisher: AnyPublisher<String?, Never> {
        searchTextField.textPublisher
    }
}



