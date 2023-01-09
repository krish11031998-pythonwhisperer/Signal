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
            .execute(refresh: true)
            .eraseToAnyPublisher()
    }
    
    func getUser(userId: String) -> AnyPublisher<UserModelResponse, Error> {
        UserEndpoint
            .getUser(uid: userId)
            .execute(refresh: false)
            .eraseToAnyPublisher()
    }
    
    
    func updateWatchlist(uid: String, asset: String) -> AnyPublisher<UserModelResponse, Error> {
        UserEndpoint
            .updateWatchList(uid: uid, asset: asset)
            .execute(refresh: false)
            .eraseToAnyPublisher()
    }
}
