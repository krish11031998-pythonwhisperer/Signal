//
//  NewsEndpoints.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 23/12/2022.
//

import Foundation

enum NewsEndpoints {
    case newsForAllTickers(entity: [String]? = nil,
                    items: String? = nil,
                    source: String? = nil,
                    page: Int,
                    limit: Int = 20)
    case newsForEvent(eventId: String)
}

extension NewsEndpoints: EndPoint {
    var scheme: String {
        return "https"
    }
    
    var path: String {
        switch self {
        case .newsForAllTickers:
            return "/news/tickerNews"
        case .newsForEvent:
            return "/events/news"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .newsForAllTickers( let entity,
                          let items,
                          let source,
                          let page,
                          let limit):
            var queries: [URLQueryItem] = [
                .init(name: "items", value: items),
                .init(name: "source", value: source),
                .init(name: "page", value: "\(page)"),
                .init(name: "limit", value: "\(limit)")
            ].filter { $0.value != nil }
            
            if let entity = entity {
                queries.append(contentsOf: entity.map { .init(name: "entity", value: $0) } )
            }
            
            return queries
        case .newsForEvent(let eventId):
            return [
                .init(name: "eventId", value: eventId)
            ]
        }
    }
}
