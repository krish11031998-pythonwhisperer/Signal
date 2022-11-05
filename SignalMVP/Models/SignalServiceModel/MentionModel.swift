//
//  MentionModel.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 25/09/2022.
//

import Foundation

public extension Notification.Name {
    static let showMention: Notification.Name = .init("showMention")
}

struct MentionsResult: Codable {
	let data: MentionResultSection?
}

struct MentionResultSection: Codable{
	let all: [MentionModel]?
}

struct MentionModel: Codable {
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

struct MentionCellModel: ActionProvider {
    let model: MentionModel
    var action: Callback?
}

enum MentionPeriod {
	case weekly
	case monthly
}
