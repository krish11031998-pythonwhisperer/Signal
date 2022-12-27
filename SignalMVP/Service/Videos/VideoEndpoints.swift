//
//  VideoEndpoints.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 23/12/2022.
//

import Foundation

enum VideoEndpoints {
    case fetchVideos(entity: [String]?, page: Int, limit: Int)
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
        case .fetchVideos(let entity, let page, let limit):
            var queries: [URLQueryItem] = [
                .init(name: "page", value: "\(page)"),
                .init(name: "limit", value: "\(limit)")
            ].filter { $0.value != nil }
            
            if let entity = entity {
                queries.append(contentsOf: entity.map { .init(name: "entity", value: $0) })
            }
            
            return queries
        }
    }
    
}
