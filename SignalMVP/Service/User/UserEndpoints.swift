//
//  UserLogin.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 24/12/2022.
//

import Foundation

enum UserEndpoint {
    case login(_ params: UserLogin)
    case register(_ params: UserRegister)
}

extension UserEndpoint: EndPoint {
    
    
    var path: String {
        switch self {
        case .register:
            return "/user/createUser"
        case .login:
            return "/user/createUser"
        }
    }
    
    var method: String {
        switch self {
        case .login, .register:
            return "POST"
        default:
            return "GET"
        }
    }
    
    var queryItems: [URLQueryItem] {
        return []
    }
    
    var body: Data? {
        switch self {
        case .login(let loginParams):
            let data = try? JSONEncoder().encode(loginParams)
            return data
        case .register(let registerParams):
            let data = try? JSONEncoder().encode(registerParams)
            return data
        }
    }

    
}
