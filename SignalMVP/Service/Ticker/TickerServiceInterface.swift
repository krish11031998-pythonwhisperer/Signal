//
//  TickerServiceInterface.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 20/12/2022.
//

import Foundation
import Combine

public protocol TickerServiceInterface {
    func search(query: String) -> Future<TickerSearchResult, Error>
}
