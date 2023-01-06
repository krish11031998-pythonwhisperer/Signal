//
//  StubService.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 22/09/2022.
//

import Foundation
import Combine

class StubTweetService: TweetServiceInterface {
	
	public static var shared: StubTweetService = .init()
	
    public func fetchTweetsForAllTickers(entity: String? = nil, page: Int = 0, limit: Int = 20, refresh: Bool = false ) -> AnyPublisher<TweetResult, Error> {
        Bundle.main.loadDataFromBundle(name: "tweetsProd", extensionStr: "json")
    }
    
    public func fetchTweetsForTicker(ticker: String = "", limit: Int = 0, nextPageToken: String? = nil, refresh: Bool = false) -> AnyPublisher<TweetSearchResult, Error> {
        Bundle.main.loadDataFromBundle(name: "tweetSearch", extensionStr: "json")
    }
}
