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

    public func fetchTweets(entity: String? = nil, before: String? = nil, after: String? = nil, limit: Int = 20) -> AnyPublisher<TweetSearchResult, Error> {
        TweetEndpoints.tweets(entity: entity, before: before, after: after, limit: limit)
            .fetch().eraseToAnyPublisher()
    }
}

