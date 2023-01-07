//
//  GenericResult.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 29/12/2022.
//

import Foundation

struct GenericResult<T:Codable>: Codable {
    let data: T?
    let err: String?
    let success: Bool
}


typealias GenericMessageResult = GenericResult<String>
