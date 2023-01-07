//
//  TickerSearch.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 20/12/2022.
//

import Foundation

enum SignalTickerEndpoint {
    case search(query: String)
    case searchTrending
    case tweets(ticker: String, limit: Int = 20, nextPageToken: String? = nil)
    case news(ticker: String, page: Int, limit: Int)
    case events(ticker: String, page: Int, limit: Int)
    case story(ticker: String)
    case sentiment(ticker: String)
}

extension SignalTickerEndpoint: EndPoint {
    var scheme: String {
        return "https"
    }
    
    var baseUrl: String {
        switch self {
        case .search, .searchTrending:
            return "api.coingecko.com"
        default:
            return "signal.up.railway.app"
        }
        
    }
    
    var path: String {
        switch self {
        case .search:
            return "/api/v3/search"
        case .searchTrending:
            return "/api/v3/search/trending"
        case .tweets:
            return "/tickers/tweets"
        case .news:
            return "/tickers/news"
        case .events:
            return "/tickers/events"
        case .story:
            return "/tickers/story"
        case .sentiment:
            return "/tickers/sentiment"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .search(let query):
            var params = [URLQueryItem]()
            params.append(.init(name: "query", value: query))
            return params
        case .tweets(let ticker, let limit, let nextPageToken):
            return [
                .init(name: "ticker", value: ticker),
                .init(name: "limit", value: "\(limit)"),
                .init(name: "nextPageToken", value: nextPageToken)
            ].filter { $0.value != nil }
        case .news(let ticker, let page, let limit), .events(let ticker, let page, let limit):
            return [
                .init(name: "ticker", value: ticker),
                .init(name: "page", value: "\(page)"),
                .init(name: "limit", value: "\(limit)")
            ].filter { $0.value != nil }
        case .story(let ticker), .sentiment(let ticker):
            return [
                .init(name: "ticker", value: ticker)
            ].filter { $0.value != nil }
        default:
            return []
        }
        
    }
}

