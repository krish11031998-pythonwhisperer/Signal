//
//  TweetService.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 22/09/2022.
//

import Foundation
import UIKit

fileprivate extension Array where Self.Element == URLQueryItem {
	
	static var searchQuery: [Self.Element] {
		[
			.init(name: "query", value: "Crypto -is:retweet"),
			.init(name: "tweet.fields", value: "attachments,author_id,id,lang,public_metrics,text"),
			.init(name: "expansions", value: "attachments.media_keys,author_id"),
			.init(name: "media.fields", value: "height,media_key,preview_image_url,public_metrics,url,width"),
			.init(name: "user.fields", value: "name,profile_image_url,public_metrics,url,username,verified"),
			.init(name: "max_results", value: "100"),
			.init(name: "sort_order", value: "relevancy")
		]
	}
	
}



class TweetService: TweetServiceInterface {
	
	public static var shared: TweetService = .init()
	
	public func fetchTweets(queries: [URLQueryItem] = .searchQuery, completion: @escaping (Result<TweetSearchResult, Error>) -> Void) {
		TweetEndpoint.searchRecent(queries: .searchQuery).fetch(completion: completion)
	}
}

