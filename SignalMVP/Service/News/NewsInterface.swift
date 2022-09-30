//
//  NewsInterface.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 22/09/2022.
//

import Foundation

protocol NewsServiceInterface {
	func fetchNews(tickers: String?,
				   items: String?,
				   source: String?,
				   after: String?,
				   before: String?,
				   limit: Int,
				   completion: @escaping (Result<NewsResult,Error>) -> Void)
}
