//
//  NewsInterface.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 22/09/2022.
//

import Foundation
import Combine
protocol NewsServiceInterface {
	func fetchNews(entity: [String]?,
				   items: String?,
				   source: String?,
                   page: Int,
				   limit: Int) -> AnyPublisher<NewsResult,Error>
}
