//
//  ServiceCatalogue.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 22/09/2022.
//

import Foundation
import Combine
protocol TweetServiceInterface {
    func fetchTweetsForAllTickers(entity: String?, page: Int, limit: Int, refresh: Bool) -> AnyPublisher<TweetResult, Error>
    func fetchTweetsForTicker(entity: String, limit: Int, nextPageToken: String?, refresh: Bool) -> AnyPublisher<TweetSearchResult, Error>
}
