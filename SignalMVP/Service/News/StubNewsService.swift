//
//  NewsService.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 22/09/2022.
//

import Foundation
import UIKit

class StubNewsService: NewsServiceInterface {

	public static var shared: StubNewsService = .init()
	
	public func fetchNews(tickers: String? = nil,
						  items: String? = nil,
						  source: String? = nil,
						  after: String? = nil,
						  before: String? = nil,
						  limit: Int = 20,
						  completion: @escaping (Result<NewsResult, Error>) -> Void) {
		let result: Result<NewsResult,Error> = Bundle.main.loadDataFromBundle(name: "signalNews", extensionStr: "json")
		
		switch result {
		case .success(let newsResult):
			completion(.success(newsResult))
		case .failure(let err):
			completion(.failure(err))
		}
	}
	
}
