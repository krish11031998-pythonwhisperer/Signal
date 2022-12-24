//
//  EventEndPoints.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 23/12/2022.
//

import Foundation

enum EventEndpoints {
    case latestEvents(tickers: String?, before: String?, after: String?, limit: Int)
}

extension EventEndpoints: EndPoint {
    var scheme: String {
        return "https"
    }
    
    var path: String {
        switch self {
        case .latestEvents:
            return "/events/latestEvents"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .latestEvents(let tickers, let before, let after, let limit):
            return [
                .init(name: "tickers", value: tickers),
                .init(name: "before", value: before),
                .init(name: "after", value: after),
                .init(name: "limit", value: "\(limit)")
            ].filter { $0.value != nil }
        }
    }
}
