//
//  NewsInterface.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 22/09/2022.
//

import Foundation

protocol NewsServiceInterface {
	func fetchNews(query: [URLQueryItem], completion: @escaping (Result<[NewsModel],Error>) -> Void)
}
