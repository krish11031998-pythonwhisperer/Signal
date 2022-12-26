//
//  VideoEndpoints.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 23/12/2022.
//

import Foundation

enum VideoEndpoints {
    case fetchVideos(entity: [String]?, before: Int?, after: Int?, limit: Int)
}

extension VideoEndpoints: EndPoint {
    var scheme: String {
        "https"
    }
    
    var path: String {
        switch self {
        case .fetchVideos:
            return ""
        }
    }
    
    var queryItems: [URLQueryItem] {
        return []
    }
    
}
