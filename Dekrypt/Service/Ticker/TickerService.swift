//
//  TickerService.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 20/12/2022.
//

import Foundation
import Combine

class TickerService: TickerServiceInterface {
    
    static var shared: TickerService = .init()
    
    //MARK: - Search
    func search(query: String) -> AnyPublisher<TickerSearchResult, Error> {
        SignalTickerEndpoint
            .search(query: query)
            .execute()
            .eraseToAnyPublisher()
    }
    
    //MARK: - Trending
    func trending() -> AnyPublisher<TickerSearchTrendingResult, Error> {
        SignalTickerEndpoint
            .searchTrending
            .execute(refresh: false)
            .eraseToAnyPublisher()
    }
    
    //MARK: - Story
    func fetchStory(ticker: String, refresh: Bool) -> AnyPublisher<StoryDataResult, Error> {
        SignalTickerEndpoint
            .story(ticker: ticker)
            .execute(refresh: refresh)
            .eraseToAnyPublisher()
    }
    
    //MARK: - Events
    func fetchEvent(ticker: String, page: Int = 0, limit: Int = 20, refresh: Bool) -> AnyPublisher<EventResult, Error> {
        SignalTickerEndpoint
            .events(ticker: ticker, page: page, limit: limit)
            .execute(refresh: refresh)
            .eraseToAnyPublisher()
    }
    
    //MARK: - News
    func fetchNews(ticker: String, page: Int = 0, limit: Int = 20, refresh: Bool) -> AnyPublisher<NewsResult, Error> {
        SignalTickerEndpoint
            .news(ticker: ticker, page: page, limit: limit)
            .execute(refresh: refresh)
            .eraseToAnyPublisher()
    }
    
    //MARK: - Tweets
    func fetchTweets(ticker: String, limit: Int = 50, nextPageToken: String? = nil, refresh: Bool) -> AnyPublisher<TweetSearchResult, Error> {
        SignalTickerEndpoint
            .tweets(ticker: ticker, limit: limit, nextPageToken: nextPageToken)
            .execute(refresh: refresh)
            .eraseToAnyPublisher()
    }
    
    //MARK: - Sentiment
    func fetchSentiment(ticker: String, refresh: Bool) -> AnyPublisher<SentimentResult, Error> {
        SignalTickerEndpoint
            .sentiment(ticker: ticker)
            .execute(refresh: refresh)
            .eraseToAnyPublisher()
    }
}
