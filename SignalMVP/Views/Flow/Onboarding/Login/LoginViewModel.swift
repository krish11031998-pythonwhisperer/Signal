//
//  LoginViewModel.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 30/12/2022.
//

import Foundation
import Combine

class LoginViewModel {
    
    enum Routes {
        case nextPage
        case error
    }
    
    struct Input {
        let userLogin: AnyPublisher<UserLoginModel, Never>
    }
    
    
    struct Output {
        var navigation: AnyPublisher<Routes, Never>
    }
    
    func transform(input: Input) -> Output {
        
        let navigation = input.userLogin
            .print("👨‍💻 logging in")
            .flatMap { FirebaseAuthService.shared.loginUser(email: $0.username, password: $0.password).catch { _ in Empty() } }
            .compactMap { resp in
                if let user = resp?.user {
                    print("(DEBUG) user: ", user.uid)
                    return Routes.nextPage
                } else {
                    print("(ERROR) err from registration: ")
                }
                return nil
            }
            .eraseToAnyPublisher()
        
        return .init(navigation: navigation)
    }
    
}
