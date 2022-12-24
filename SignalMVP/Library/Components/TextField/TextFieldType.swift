//
//  TextFieldType.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 24/12/2022.
//

import Foundation
import UIKit
import Combine

enum TextFieldType {
    case email
    case password
}

//MARK: - TextFieldType

extension TextFieldType {
    
    var secureText: Bool {
        switch self {
        case .password:
            return true
        default:
            return false
        }
    }
    
    func rightSideView(_ textField: UITextField) ->  UIView? {
        switch self {
        case .password:
            let imageName = textField.isSecureTextEntry ? "eye" : "eye.slash"
            let image = UIImage(systemName: imageName)?.withTintColor(.surfaceBackgroundInverse)
            return image?.imageView(size: .init(width: 24, height: 16))
        default:
            return nil
        }
    }
    
    var rightSideViewMode: UITextField.ViewMode {
        switch self {
        case .password:
            return .always
        default:
            return .never
        }
    }
    
    func validation(_ textField: UITextField) -> AnyPublisher<Bool, Never> {
        switch self {
        case .email:
            return textField.isValidEmail
        case .password:
            return textField.isValidEmail
        }
    }
    
    func handleRightSideTap(_ textField: UITextField) {
        switch self {
        case .password:
            textField.isSecureTextEntry.toggle()
            let gestures = textField.rightView?.gestureRecognizers?.first(where: {$0 is UITapGestureRecognizer })
            textField.rightView = rightSideView(textField)
            if let validGesture = gestures {
                textField.rightView?.addGestureRecognizer(validGesture)
                textField.rightView?.isUserInteractionEnabled = true
            }
        default:
            break
        }
    }
    
}
