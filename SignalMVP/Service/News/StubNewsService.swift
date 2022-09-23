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
	
	public func fetchNews(query: [URLQueryItem], completion: @escaping (Result<[NewsModel], Error>) -> Void) {
		let result: Result<NewsFirebaseResult,Error> = Bundle.main.loadDataFromBundle(name: "news", extensionStr: "json")
		
		switch result {
		case .success(let newsResult):
			if let news = newsResult.data?.values {
				completion(.success(Array(news)))
			} else {
				completion(.failure(URLSessionError.noData))
			}
		case .failure(let err):
			completion(.failure(err))
		}
	}
	
}
