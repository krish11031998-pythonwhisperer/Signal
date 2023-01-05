//
//  TweetService.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 22/09/2022.
//

import Foundation
import UIKit
import Combine

class TweetService: TweetServiceInterface {
	
	public static var shared: TweetService = .init()

    public func fetchTweetsForAllTickers(entity: String? = nil, page: Int = 0, limit: Int = 20, refresh: Bool) -> AnyPublisher<TweetResult, Error> {
        TweetEndpoints.tweetsForAllTickers(entity: entity, page: page, limit: limit)
            .execute(refresh: refresh)
            .eraseToAnyPublisher()
    }
    
    public func fetchTweetsForTicker(entity: String, limit: Int = 20, nextPageToken: String? = nil, refresh: Bool) -> AnyPublisher<TweetSearchResult, Error> {
        TweetEndpoints
            .tweetsForTicker(entity: entity, limit: limit, nextPageToken: nextPageToken)
            .execute(refresh: refresh)
            .eraseToAnyPublisher()
    }
}

