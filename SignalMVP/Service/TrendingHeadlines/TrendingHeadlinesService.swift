//
//  TrendingHeadlinesService.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 25/09/2022.
//

import Foundation

class StubTrendingHeadlines: TrendingHeadlinesInterface {
	
	public static var shared: StubTrendingHeadlines = .init()
	
	public func fetchHeadlines(completion: @escaping (Result<TrendingHeadlinesResult,Error>) -> Void) {
		let result: Result<TrendingHeadlinesResult,Error> = Bundle.main.loadDataFromBundle(name: "trendingHeadlines", extensionStr: "json")
		completion(result)
	}

}
