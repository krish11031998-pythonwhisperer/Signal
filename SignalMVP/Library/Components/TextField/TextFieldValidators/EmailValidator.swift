//
//  EmailValidator.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 24/12/2022.
//

import Foundation
import UIKit

extension String {
    
    enum RegexPattern: String {
        case email = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
    }
    
    func regexChecker(pattern: RegexPattern) -> Bool {
        let regex = try? NSRegularExpression(pattern: pattern.rawValue, options: [])
        let range = NSRange(location: 0, length: utf16.count)
        return regex?.firstMatch(in: self, options: [], range: range) != nil
    }
    
    var validEmail: Bool {
        regexChecker(pattern: .email)
    }
    
}

