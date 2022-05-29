//
//  UIViewController+Keyboard.swift
//  iTunesPractice
//
//  Created by Serge Rylko on 24.05.22.
//

import Combine
import UIKit

extension UIViewController {
    
    func keyboardApeparance() -> AnyPublisher<CGFloat, Never> {
        let pub = Publishers.Merge(
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillShowNotification)
                .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect }
                .map { $0.height },
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillHideNotification)
                .map { _ in CGFloat(0) }
        ).eraseToAnyPublisher()

        return pub
    }
 
    func adjust(scrollView: UIScrollView, by offset: CGFloat) {
        let toApplyOffset = offset > 0
        
        if toApplyOffset {
            scrollView.contentInset.bottom += offset
            scrollView.verticalScrollIndicatorInsets.bottom += offset
        } else {
            scrollView.contentInset.bottom = 0
            scrollView.verticalScrollIndicatorInsets.bottom = 0
        }
    }
}
