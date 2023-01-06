//
//  AuthInterface.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 28/12/2022.
//

import Foundation
import FirebaseAuth
import Combine

protocol AuthInterface {
    func registerUser(email: String, password: String) -> AnyPublisher<AuthDataResult?, Error>
    func loginUser(email: String, password: String) -> AnyPublisher<AuthDataResult?, Error>
    func signOutUser() -> AnyPublisher<(), Error>
}
