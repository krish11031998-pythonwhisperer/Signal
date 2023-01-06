//
//  TweetMetricType.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 01/01/2023.
//

import Foundation
import UIKit

enum MetricType: String, CaseIterable {
    case fakeNews = "Fake News"
    case trustedNews = "Trusted News"
    case qualityAnalysis = "Quality Analysis"
    case badAnalysis = "Bad Analysis"
    case overReaction = "Over reaction"
}


extension MetricType {
    var imgStr: String {
        switch self {
        case .fakeNews:
            return "❌"
        case .trustedNews:
            return "✅"
        case .qualityAnalysis:
            return "👍"
        case .badAnalysis:
            return "👎"
        case .overReaction:
            return "😅"
        }
    }
}
