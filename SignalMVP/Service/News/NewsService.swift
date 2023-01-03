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
	
	
    public func fetchNews(entity: [String]? = nil,
                          items: String? = nil,
                          source: String? = nil,
                          page: Int = 0,
                          limit: Int = 20,
                          refresh: Bool = false) -> AnyPublisher<NewsResult, Error> {
		NewsEndpoints
            .tickerNews(entity: entity, items: items, source: source, page: page, limit: limit)
            .execute(refresh: refresh)
            .eraseToAnyPublisher()
	}
	
}
