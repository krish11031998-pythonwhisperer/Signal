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

    public func fetchTweets(entity: String? = nil, page: Int = 0, limit: Int = 20, refresh: Bool) -> AnyPublisher<TweetSearchResult, Error> {
        TweetEndpoints.tweets(entity: entity, page: page, limit: limit)
            .execute(refresh: refresh)
            .eraseToAnyPublisher()
    }
}

