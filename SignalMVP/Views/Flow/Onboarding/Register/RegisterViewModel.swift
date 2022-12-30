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
        let username: StringPublisher<Never>
        let email: StringPublisher<Never>
        let password: StringPublisher<Never>
        let confirmPassword: StringPublisher<Never>
        let registerUser: VoidPublisher
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
            .combineLatest(input.password.setFailureType(to: Error.self)) { ($0, $1)}
            .flatMap({ (userResponse, password) in
                FirebaseAuthService.shared.loginUser(email: userResponse.data?.email ?? "", password: password)
            })
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
