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
			.init(name: "query", value: "BTC  lang:en"),
			.init(name: "tweet.fields", value: "attachments,public_metrics,text"),
//			.init(name: "expansions", value: "attachments.media_keys,attachments.poll_ids,author_id,entities.mentions.username,geo.place_id,in_reply_to_user_id,referenced_tweets.id,referenced_tweets.id.author_id"),
			.init(name: "media.fields", value: "alt_text,duration_ms,height,media_key,non_public_metrics,organic_metrics,preview_image_url,promoted_metrics,public_metrics,type,url,variants,width"),
			.init(name: "user.fields", value: "description,id,name,url,username")
		]
	}
	
}



class TweetService: TweetServiceInterface {
	
	public static var shared: TweetService = .init()
	
	public func fetchTweets(queries: [URLQueryItem] = .searchQuery, completion: @escaping (Result<TweetSearchResult, Error>) -> Void) {
		TweetEndpoint.searchRecent(queries: .searchQuery).fetch(completion: completion)
	}
}

