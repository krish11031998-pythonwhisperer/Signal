//
//  StubService.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 22/09/2022.
//

import Foundation


class StubTweetService: TweetServiceInterface {
	
	public static var shared: StubTweetService = .init()
	
	public func fetchTweets(queries: [URLQueryItem] = [], completion: @escaping (Result<TweetSearchResult, Error>) -> Void) {
		completion(Bundle.main.loadDataFromBundle(name: "tweets", extensionStr: "json"))
	}
}
