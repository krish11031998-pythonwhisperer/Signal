//
//  RegisterViewModel.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 25/12/2022.
//

import Foundation
import Combine

class RegisterViewModel {
    
    enum Routes {
        case nextPage
        case errorMessage(err: String)
    }
    
    struct Input {
        let username: AnyPublisher<String, Never>
        let email: AnyPublisher<String, Never>
        let password: AnyPublisher<String, Never>
        let confirmPassword: AnyPublisher<String, Never>
        let registerUser: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let navigation: AnyPublisher<Routes, Error>
    }
    
    public func transform(input: Input) -> Output {
        
        let navigation = input.registerUser
            .combineLatest(input.username, input.email, input.password) { _, username, email, password in
                return UserRegister(username: username, email: email, password: password)
            }
            .flatMap {
                FirebaseAuthService.shared.registerUser(email: $0.email, password: $0.password)
            }
            .compactMap {
                if let user = $0?.user {
                    return Routes.nextPage
                } else {
                    return Routes.errorMessage(err: "")
                }
            }
            .eraseToAnyPublisher()
        
        return .init(navigation: navigation)
    }
    
}
