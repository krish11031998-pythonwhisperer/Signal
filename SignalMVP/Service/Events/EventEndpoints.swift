//
//  EventEndPoints.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 23/12/2022.
//

import Foundation

enum EventEndpoints {
    case eventsForAllTickers(entity: [String]?, page: Int, limit: Int)
}

extension EventEndpoints: EndPoint {
    var scheme: String {
        return "https"
    }
    
    var path: String {
        switch self {
        case .eventsForAllTickers:
            return "/events/latestEvents"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .eventsForAllTickers(let entity, let page, let limit):
            var queries: [URLQueryItem] = [
                .init(name: "page", value: "\(page)"),
                .init(name: "limit", value: "\(limit)")
            ].filter { $0.value != nil }

            if let entity = entity {
                queries.append(contentsOf: entity.map { .init(name: "entity", value: $0) } )
            }
            
            return queries
        }
    }
}
