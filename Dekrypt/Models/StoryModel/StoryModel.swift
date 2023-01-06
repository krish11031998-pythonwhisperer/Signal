//
//  StoryModel.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 06/01/2023.
//

import Foundation
import UIKit


struct StoryModel: Codable {
    let news: [NewsModel]?
    let video: [NewsModel]?
    let headlines: [TrendingHeadlinesModel]?
    let sentiment: [String: SentimentForTicker]?
}
