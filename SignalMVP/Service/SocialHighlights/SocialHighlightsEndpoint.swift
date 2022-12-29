//
//  SocialHighlightsEndpoint.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 29/12/2022.
//

import Foundation

enum SocialHighlightEndpoint {
    case fetchSocialHighlights(asset: [String] = [], keyword: [String] = [])
}

extension SocialHighlightEndpoint: EndPoint {
    var path: String {
        switch self {
        case .fetchSocialHighlights:
            return "/social/hightlights"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .fetchSocialHighlights(let asset, let keyword):
            var url: [URLQueryItem] = []
            asset.forEach { url.append(.init(name: "asset", value: $0)) }
            keyword.forEach { url.append(.init(name: "keyword", value: $0)) }
            return url
        }
    }
}
