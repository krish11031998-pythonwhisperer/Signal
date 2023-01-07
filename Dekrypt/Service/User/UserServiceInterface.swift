//
//  UserServiceInterface.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 25/12/2022.
//

import Foundation
import Combine

protocol UserServiceInterface {
    func getUser(userId: String) -> AnyPublisher<UserModelResponse, Error>
    func registerUser(model: RegisterModel) -> AnyPublisher<UserModelResponse, Error>
    func updateWatchlist(uid: String, asset: String) -> AnyPublisher<UserModelResponse, Error>
}
