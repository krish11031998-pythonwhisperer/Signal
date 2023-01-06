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
	
    public func fetchNewsForAllTickers(entity: [String]? = nil,
                          items: String? = nil,
                          source: String? = nil,
                          page: Int = 0,
                          limit: Int = 20,
                          refresh: Bool = false) -> AnyPublisher<NewsResult, Error> {
        
        Bundle.main.loadDataFromBundle(name: "signalNews", extensionStr: "json")
    }
    
    func fetchNewsForTicker(ticker: String = "", page: Int = 0, limit: Int = 0, refresh: Bool) -> AnyPublisher<NewsResult,Error> {
        Bundle.main.loadDataFromBundle(name: "signalNews", extensionStr: "json")
    }
    
    func fetchNewsForEvent(eventId: String, refresh: Bool) -> AnyPublisher<NewsResult, Error> {
        Bundle.main.loadDataFromBundle(name: "signalNews", extensionStr: "json")
    }
}
