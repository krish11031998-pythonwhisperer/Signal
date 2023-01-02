//
//  UserLogin.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 24/12/2022.
//

import Foundation

enum UserEndpoint {
    case getUser(uid: String)
    case login(_ params: UserLoginModel)
    case register(_ params: RegisterModel)
}

extension UserEndpoint: EndPoint {
    
    
    var path: String {
        switch self {
        case .register:
            return "/user/createUser"
        case .login:
            return "/user/loginUser"
        case .getUser:
            return "/user/get"
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
        switch self {
        case .getUser(let uid):
            let params: [URLQueryItem] = [
                .init(name: "uid", value: uid)
            ]
            return params
        default:
            return []
        }
    }
    
    var body: Data? {
        switch self {
        case .login(let loginParams):
            let data = try? JSONEncoder().encode(loginParams)
            return data
        case .register(let registerParams):
            let data = try? JSONEncoder().encode(registerParams)
            return data
        default:
             return nil
        }
    }

    
}
