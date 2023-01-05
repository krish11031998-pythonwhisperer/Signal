//
//  NewsInterface.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 22/09/2022.
//

import Foundation
import Combine
protocol NewsServiceInterface {
	func fetchNewsForAllTickers(entity: [String]?, items: String?, source: String?, page: Int, limit: Int, refresh: Bool) -> AnyPublisher<NewsResult,Error>
    func fetchNewsForTicker(ticker: String, page: Int, limit: Int, refresh: Bool) -> AnyPublisher<NewsResult,Error>
}
