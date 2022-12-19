//
//  TrendingHeadlinesService.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 25/09/2022.
//

import Foundation
import Combine

class StubTrendingHeadlines: TrendingHeadlinesInterface {
	
	public static var shared: StubTrendingHeadlines = .init()
	
    public func fetchHeadlines() -> Future<TrendingHeadlinesResult,Error> {
        Bundle.main.loadDataFromBundle(name: "trendingHeadlines", extensionStr: "json").future
    }

}
