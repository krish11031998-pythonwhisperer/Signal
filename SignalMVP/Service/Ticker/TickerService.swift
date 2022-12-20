//
//  TickerService.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 20/12/2022.
//

import Foundation
import Combine

class TickerService: TickerServiceInterface {
    
    static var shared: TickerService = .init()
    
    func search(query: String) -> Future<TickerSearchResult, Error> {
        SignalTickerEndpoint
            .search(query: query)
            .fetch()
    }
    
}
