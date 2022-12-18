//
//  ServiceCatalogue.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 22/09/2022.
//

import Foundation
import Combine
protocol TweetServiceInterface {
//	func fetchTweets(entity: String?, before: String?, after: String?, limit: Int, completion: @escaping (Result<TweetSearchResult,Error>) -> Void)
    func fetchTweets(entity: String?, before: String?, after: String?, limit: Int) -> Future<TweetSearchResult, Error>
}
