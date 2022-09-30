//
//  TrendingHeadlinesInterface.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 25/09/2022.
//

import Foundation


protocol TrendingHeadlinesInterface {
	func fetchHeadlines(completion: @escaping (Result<TrendingHeadlinesResult,Error>) -> Void)
}
