//
//  AuthService.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 28/12/2022.
//

import Foundation
import FirebaseAuth
import Combine

class FirebaseAuthService: AuthInterface {
    
    static var shared: FirebaseAuthService = .init()
    
    func registerUser(email: String, password: String) -> AnyPublisher<AuthDataResult?, Error> {
        Future { promise in
            Auth.auth().createUser(withEmail: email, password: password) { [weak self] authRes, err in
                guard let self, let validAuthRes = authRes else {
                    if let err = err {
                        print("(ERROR) err: ", err.localizedDescription)
                        promise(.failure(err))
                    }
                    return
                }
                print("(DEBUG) auth: ", validAuthRes)
                promise(.success(authRes))
            }
        }.eraseToAnyPublisher()
       
    }
    
    func loginUser(email: String, password: String) -> AnyPublisher<AuthDataResult?, Error>  {
        Future { promise in
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authRes, err in
                guard let self, let validAuthRes = authRes else {
                    if let err = err {
                        print("(ERROR) err: ", err.localizedDescription)
                        promise(.failure(err))
                    }
                    return
                }
                print("(DEBUG) auth: ", validAuthRes)
                promise(.success(authRes))
            }
        }.eraseToAnyPublisher()
    }
    
    
}
