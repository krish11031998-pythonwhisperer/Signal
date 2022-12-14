//
//  RegisterViewModel.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 25/12/2022.
//

import Foundation
import Combine

struct UserSession {
    let uid: String?
    let err: String?
}

extension UserSession {
    static let empty: AnyPublisher<UserSession, Error> = Just(UserSession(uid: nil, err: nil))
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
}

class RegisterViewModel {
    
    private let currentUser: CurrentValueSubject<UserModel?, Never>
    let nextPage: PassthroughSubject<Void, Never>
    init(currentUser: CurrentValueSubject<UserModel?, Never>, nextPage: PassthroughSubject<Void, Never>) {
        self.currentUser = currentUser
        self.nextPage = nextPage
    }
    
    enum Routes {
        case nextPage
        case errorMessage(err: String)
        case none
    }
    
    struct Input {
        let registerUser: AnyPublisher<RegisterModel, Never>
    }
    
    struct Output {
        let navigation: AnyPublisher<Routes, Error>
    }
    
    public func transform(input: Input) -> Output {
        //TODO: Password Validation Rule!
        let navigation = input.registerUser
            .flatMap { model in UserService.shared.registerUser(model: model) }
            .handleEvents(receiveOutput: { [weak self] in self?.currentUser.send($0.data)})
            .withLatestFrom(input.registerUser.setFailureType(to: Error.self).eraseToAnyPublisher())
            .flatMap { [weak self] in self?.loginUserAfterRegistration($0, $1.password ?? "") ?? UserSession.empty }
            .compactMap { [weak self] in self?.mapSessionToRoutes($0) }
            .eraseToAnyPublisher()
        
        let navTest = input.registerUser.map { _ in Routes.nextPage }.setFailureType(to: Error.self).eraseToAnyPublisher()
        
       return .init(navigation: navigation)
        //return .init(navigation: navTest)
    }
    
    private func mapSessionToRoutes(_ session: UserSession) -> Routes {
        if let uid = session.uid {
            print("(DEBUG) user: ", uid)
            return .nextPage
        } else if let err = session.err {
            print("(ERROR) err from registration: ")
            return .errorMessage(err: err)
        } else {
            return .none
        }
    }
    
    private func loginUserAfterRegistration(_ userResponse: UserModelResponse, _ password: String) -> AnyPublisher<UserSession, Error> {
        if let email = userResponse.data?.email {
            return FirebaseAuthService
                .shared
                .loginUser(email: email, password: password)
                .compactMap { result in
                    guard let uid = result?.user.uid else {
                        return UserSession(uid: nil, err: "Unsuspected Error")
                    }
                    return UserSession(uid: uid, err: nil)
                }
                .eraseToAnyPublisher()
        }
        return Just(UserSession(uid: nil, err: userResponse.err))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
