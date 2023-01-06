//
//  MentionModel.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 25/09/2022.
//

import Foundation
import UIKit
public extension Notification.Name {
    static let showMention: Notification.Name = .init("showMention")
}

 typealias MentionsResult = GenericResult<DailyMentions>

 struct DailyMentions: Codable{
    let date: String?
	let tickers: [MentionTickerModel]?
}

 struct MentionTickerModel: Codable {
	let totalMentions: Int
	let positiveMentions: Int
	let negativeMentions: Int
	let neutralMentions: Int
	let ticker: String
	let name: String
	let sentimentScore: Float
	
	enum CodingKeys: String, CodingKey {
		case ticker, name
		case totalMentions = "total_mentions"
		case negativeMentions = "negative_mentions"
		case positiveMentions = "positive_mentions"
		case neutralMentions = "neutral_mentions"
		case sentimentScore = "sentiment_score"
	}
}

//MARK: - Hashable
 extension MentionTickerModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(ticker)
    }
}

//MARK: - MentionModel

 extension MentionTickerModel {
    
    var ratio: CGFloat {
        CGFloat(positiveMentions) / CGFloat(positiveMentions + neutralMentions + negativeMentions)
    }
    
    var color: UIColor {
        switch ratio {
        case 0..<0.5:
            return .appRed
        case 0.5..<0.75:
            return .appOrange
        case 0.75...1:
            return .appGreen
        default:
            return .clear
        }
    }
}

 struct MentionCellModel: ActionProvider {
    let model: MentionTickerModel
    var action: Callback?
    var actionWithFrame: ((CGRect) -> Void)?
}

enum MentionPeriod: String {
	case weekly = "topMentionsWeek"
	case monthly = "topMentionsMonth"
}
