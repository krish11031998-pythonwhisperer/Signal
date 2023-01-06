//
//  StoryEndpoint.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 06/01/2023.
//

import Foundation
import Combine

enum StoryEndpoint {
    case story(ticker: String)
}

extension StoryEndpoint: EndPoint {
    var path: String {
        switch self {
        case .story:
            return "/ticker/story"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .story(let ticker):
            return [
                .init(name: "ticker", value: ticker)
            ]
        }
    }
    
}
