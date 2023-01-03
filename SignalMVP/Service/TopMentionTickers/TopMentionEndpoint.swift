//
//  TopMentionEndpoint.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 03/01/2023.
//

import Foundation

enum TopMentionEndpoint {
    case topMentionTickers(page: Int?, limit: Int?)
}

extension TopMentionEndpoint: EndPoint {
    var path: String {
        switch self {
        case .topMentionTickers:
            return "/tickers/topMentions"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .topMentionTickers(let page, let limit):
            return [
                .init(name: "page", value: "\(page)"),
                .init(name: "limit", value: "\(limit ?? 1)")
            ].filter { $0.value != nil }
        }
    }
    
    
    
    
}
