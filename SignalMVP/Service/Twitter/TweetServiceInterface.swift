//
//  ServiceCatalogue.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 22/09/2022.
//

import Foundation

protocol TweetServiceInterface {
	func fetchTweets(queries: [URLQueryItem], completion: @escaping (Result<TweetSearchResult,Error>) -> Void)
}
