//
//  ServiceCatalogue.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 22/09/2022.
//

import Foundation
import Combine
protocol TweetServiceInterface {
    func fetchTweets(entity: String?, page: Int, limit: Int) -> AnyPublisher<TweetSearchResult, Error>
}
