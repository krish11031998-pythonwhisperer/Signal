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
    
    public func fetchVideo(entity: [String]? = nil,
                           page: Int = 0,
                           limit: Int = 20) -> AnyPublisher<VideoResult, Error> {
        VideoEndpoints
            .fetchVideos(entity: entity, page: page, limit: limit)
            .execute()
            .eraseToAnyPublisher()
    }
}
