//
//  EventEndPoints.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 23/12/2022.
//

import Foundation

enum EventEndpoints {
    case latestEvents(entity: [String]?, before: String?, after: String?, limit: Int)
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
        case .latestEvents(let entity, let before, let after, let limit):
            var queries: [URLQueryItem] = [
                .init(name: "before", value: before),
                .init(name: "after", value: after),
                .init(name: "limit", value: "\(limit)")
            ].filter { $0.value != nil }

            if let entity = entity {
                queries.append(contentsOf: entity.map { .init(name: "entity", value: $0) } )
            }
            
            return queries
        }
    }
}
