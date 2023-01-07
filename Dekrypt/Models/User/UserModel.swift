//
//  UserModel.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 25/12/2022.
//

import Foundation

struct UserModel: Codable {
    let dob: String
    let email: String
    let following: Int
    let id: String
    let img: String
    let location: String
    let name: String
    let uid: String
    let userName: String
    let watching: [String]?
}


typealias UserModelResponse = GenericResult<UserModel>
