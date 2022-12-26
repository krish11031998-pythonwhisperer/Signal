//
//  VideoEndpoints.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 23/12/2022.
//

import Foundation

enum VideoEndpoints {
    case fetchVideos(entity: [String]?, before: String?, after: String?, limit: Int)
}

extension VideoEndpoints: EndPoint {
    var scheme: String {
        "https"
    }
    
    var path: String {
        switch self {
        case .fetchVideos:
            return "/video/videos"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .fetchVideos(let entity, let before, let after, let limit):
            var queries: [URLQueryItem] = [
                .init(name: "before", value: before),
                .init(name: "after", value: after),
                .init(name: "limit", value: "\(limit)")
            ].filter { $0.value != nil }
            
            if let entity = entity {
                queries.append(contentsOf: entity.map { .init(name: "entity", value: $0) })
            }
            
            return queries
        }
    }
    
}
