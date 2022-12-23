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
	
    public func fetchTweets(entity: String? = nil, before: String? = nil, after: String? = nil, limit: Int = 20) -> AnyPublisher<TweetSearchResult, Error> {
        Bundle.main.loadDataFromBundle(name: "signalTweets", extensionStr: "json")
    }
}
