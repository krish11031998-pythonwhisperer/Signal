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
        //TODO: Password Validation Rule!
  
        let navigation =
        input.registerUser
            .combineLatest(input.username, input.email, input.password) { UserRegister(username: $1, email: $2, password: $3)}
            .flatMap { UserService.shared.registerUser(model: $0) }
            .compactMap {
                print("(DEBUG) Success: ",$0.success)
                if let user = $0.data {
                    print("(DEBUG) user: ", user.uid)
                    return Routes.nextPage
                } else {
                    print("(ERROR) err from registration: ", $0.err)
                }
                return nil
            }
            .eraseToAnyPublisher()
        
        return .init(navigation: navigation)
    }
    
}
