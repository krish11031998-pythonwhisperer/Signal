//
//  UITextField+Publishers.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 21/12/2022.
//

import Foundation
import Combine
import UIKit

extension UITextField {
    
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap { ($0.object as? UITextField)?.text }
            .eraseToAnyPublisher()
    }
    
    var didStartEditing: AnyPublisher<Bool, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidBeginEditingNotification, object: self)
            .compactMap { ($0.object as? UITextField)?.isEditing }
            .eraseToAnyPublisher()
    }
    
    var didFinishEditing: AnyPublisher<Bool, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidEndEditingNotification, object: self)
            .compactMap { ($0.object as? UITextField)?.isEditing }
            .eraseToAnyPublisher()
    }
    
    
    var isValidEmail: AnyPublisher<Bool, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap { ($0.object as? UITextField)?.text?.regexChecker(pattern: .email) }
            .eraseToAnyPublisher()
    }
}
