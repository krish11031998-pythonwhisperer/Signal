//
//  Result+Future.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 18/12/2022.
//

import Foundation
import Combine

extension Result  {
    var future: Future<Success,Error> {
        Future { promise in
            switch self {
            case .success(let success):
                promise(.success(success))
            case .failure(let failure):
                promise(.failure(failure))
            }
        }
        
    }
}
