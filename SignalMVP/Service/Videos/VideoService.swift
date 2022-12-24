//
//  VideoService.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 23/12/2022.
//

import Foundation
import Combine

class VideoService: VideoServiceInterface {
    
    public static var shared: VideoService = .init()
    
    public func fetchVideo(ticker: String? = nil,
                    before: Int? = nil,
                    after: Int? = nil,
                    limit: Int = 20) -> AnyPublisher<VideoResult, Error> {
        VideoEndpoints
            .fetchVideos(ticker: ticker, before: before, after: after, limit: limit)
            .execute()
            .eraseToAnyPublisher()
    }
}
