//
//  AppStorage.swift
//  Dekrypt
//
//  Created by Krishna Venkatramani on 07/01/2023.
//

import Foundation
import Combine

class AppStorage {
    static var shared: AppStorage = .init()
    @Published var user: UserModel? = nil
    
    var userPublisher: AnyPublisher<UserModel, Never> {
        $user
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }
}
