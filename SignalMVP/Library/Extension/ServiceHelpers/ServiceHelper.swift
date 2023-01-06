//
//  ServiceHelper.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 23/10/2022.
//

import Foundation
import UIKit

typealias Response<T> = (Result<T,Error>) -> Void

extension Result {
    var data: Success? {
        switch self {
        case .success(let data):
            return data
        default:
            return nil
        }
    }
    
}



