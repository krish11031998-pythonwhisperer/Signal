//
//  SocialHighlightsModel.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 29/12/2022.
//

import Foundation

typealias SocialHighlightResult = GenericResult<SocialHighlightModel>

struct SocialHighlightModel:Codable {
    let tweets: [TweetModel]?
    let news: [NewsModel]?
    let events: [EventModel]?
    let topMention: [DailyMentions]?
}
