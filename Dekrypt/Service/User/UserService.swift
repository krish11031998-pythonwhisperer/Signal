//
//  UserService.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 25/12/2022.
//

import Foundation
import Combine

class UserService: UserServiceInterface {
    
    static var shared: UserService = .init()
    
    
    func registerUser(model: RegisterModel) -> AnyPublisher<UserModelResponse, Error> {
        UserEndpoint
            .register(model)
            .execute(refresh: false)
            .eraseToAnyPublisher()
    }
    
    func getUser(userId: String) -> AnyPublisher<UserModelResponse, Error> {
        UserEndpoint
            .getUser(uid: userId)
            .execute(refresh: false)
            .eraseToAnyPublisher()
    }
    
    
    func updateWatchlist(ticker: String) -> AnyPublisher<GenericMessageResult, Error> {
        UserEndpoint
            .updateWatchList(ticker)
            .execute(refresh: false)
            .eraseToAnyPublisher()
    }
}
