//
//  NewsService.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 22/09/2022.
//

import Foundation
import Combine
class StubNewsService: NewsServiceInterface {

	public static var shared: StubNewsService = .init()
	
	public func fetchNews(entity: [String]? = nil,
						  items: String? = nil,
						  source: String? = nil,
                          page: Int = 0,
						  limit: Int = 20) -> AnyPublisher<NewsResult, Error> {

        Bundle.main.loadDataFromBundle(name: "signalNews", extensionStr: "json")
	}
	
}
