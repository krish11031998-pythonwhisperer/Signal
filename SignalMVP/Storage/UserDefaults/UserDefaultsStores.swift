//
//  UserDefaultsStores.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 24/12/2022.
//

import Foundation

enum UserDefaultStoreKey: String {
    case loggedIn
}

extension UserDefaultStoreKey {
    
    func value<T>() -> T? {
        UserDefaults.standard.object(forKey: self.rawValue) as? T
    }
    
}
