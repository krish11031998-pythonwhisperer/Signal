//
//  StubVideoService.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 25/09/2022.
//

import Foundation
import Combine

class StubVideoService: VideoServiceInterface {
	
	public static let shared: StubVideoService = .init()
	
	public func fetchVideo(ticker: String? = nil,
                           before: Int? = nil,
                           after: Int? = nil,
                           limit: Int = 20) -> AnyPublisher<VideoResult, Error> {
        Bundle.main.loadDataFromBundle(name: "videos", extensionStr: "json")
	}
}
