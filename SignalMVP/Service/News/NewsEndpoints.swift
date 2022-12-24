//
//  NewsEndpoints.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 23/12/2022.
//

import Foundation

enum NewsEndpoints {
    case tickerNews(tickers: String? = nil,
                    items: String? = nil,
                    source: String? = nil,
                    after: String? = nil,
                    before: String? = nil,
                    limit: Int = 20)
}

extension NewsEndpoints: EndPoint {
    var scheme: String {
        return "https"
    }
    
    var path: String {
        switch self {
        case .tickerNews:
            return "/news/tickerNews"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .tickerNews( let tickers,
                          let items,
                          let source,
                          let after,
                          let before,
                          let limit):
            return [
                .init(name: "tickers", value: tickers),
                .init(name: "items", value: items),
                .init(name: "source", value: source),
                .init(name: "before", value: before),
                .init(name: "after", value: after),
                .init(name: "limit", value: "\(limit)")
            ].filter { $0.value != nil }
        }
    }
}
