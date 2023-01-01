//
//  LoginViewModel.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 30/12/2022.
//

import Foundation
import Combine
import FirebaseAuth

struct ErrorModel {
    let errMsg: String
}

class LoginViewModel {
    
    private let err: PassthroughSubject<ErrorModel, Never> = .init()
    
    enum Routes {
        case nextPage
    }
    
    struct Input {
        let userLogin: AnyPublisher<UserLoginModel, Never>
    }
    
    
    struct Output {
        var navigation: AnyPublisher<Routes, Error>
        let errMsg: AnyPublisher<ErrorModel, Never>
    }
    
    func transform(input: Input) -> Output {
        
        let navigation = input.userLogin
            .print("👨‍💻 logging in")
            .flatMap {
                FirebaseAuthService.shared.loginUser(email: $0.username, password: $0.password)
                    .catch { [weak self] err in
                        if let self {
                            self.err.send(.init(errMsg: err.localizedDescription))
                        }
                        return Empty<AuthDataResult?, Error>()
                    }
            }
            .compactMap { resp in
                if let user = resp?.user {
                    print("(DEBUG) user: ", user.uid)
                    return Routes.nextPage
                }
                return nil
            }
            .eraseToAnyPublisher()
        
        return .init(navigation: navigation, errMsg: err.eraseToAnyPublisher())
    }
    
}
