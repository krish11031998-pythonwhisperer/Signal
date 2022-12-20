//
//  TickerSearch.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 20/12/2022.
//

import Foundation

enum SignalTickerEndpoint {
    case search(query: String)
}

extension SignalTickerEndpoint: EndPoint {
    var scheme: String {
        return "https"
    }
    
    var baseUrl: String {
        "api.coingecko.com"
    }
    
    var path: String {
        switch self {
        case .search:
            return "/api/v3/search"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .search(let query):
            var params = [URLQueryItem]()
            params.append(.init(name: "query", value: query))
            return params
        }
    }
}

