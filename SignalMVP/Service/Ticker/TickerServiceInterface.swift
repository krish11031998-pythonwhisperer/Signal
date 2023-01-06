//
//  TickerServiceInterface.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 20/12/2022.
//

import Foundation
import Combine

typealias StoryDataResult = GenericResult<StoryModel>
typealias SentimentResult = GenericResult<SentimentForTicker>

protocol TickerServiceInterface {
    func search(query: String) -> AnyPublisher<TickerSearchResult, Error>
    func fetchStory(ticker: String, refresh: Bool) -> AnyPublisher<StoryDataResult, Error>
    func fetchEvent(ticker: String, page: Int, limit: Int, refresh: Bool) -> AnyPublisher<EventResult, Error>
    func fetchNews(ticker: String, page: Int, limit: Int, refresh: Bool) -> AnyPublisher<NewsResult,Error>
    func fetchTweets(ticker: String, limit: Int, nextPageToken: String?, refresh: Bool) -> AnyPublisher<TweetSearchResult, Error>
    func fetchSentiment(ticker: String, refresh: Bool) -> AnyPublisher<SentimentResult, Error>
}
