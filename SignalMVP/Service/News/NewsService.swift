//
//  SignalNewsService.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 29/09/2022.
//

import Foundation
import Combine

class NewsService: NewsServiceInterface {
	
	public static var shared: NewsService = .init()
	
	
	public func fetchNews(tickers: String? = nil,
				   items: String? = nil,
				   source: String? = nil,
				   after: String? = nil,
				   before: String? = nil,
				   limit: Int = 20) -> AnyPublisher<NewsResult, Error> {
		NewsEndpoints
            .tickerNews(tickers: tickers, items: items, source: source, after: after, before: before, limit: limit)
            .fetch()
            .eraseToAnyPublisher()
	}
	
}
