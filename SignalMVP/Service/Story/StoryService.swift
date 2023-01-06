//
//  StoryService.swift
//  SignalMVP
//
//  Created by Krishna Venkatramani on 06/01/2023.
//

import Foundation
import Combine

typealias StoryDataResult = GenericResult<StoryModel>

class StoryService: StoryServiceInterface {
    
    static var shared: StoryService = .init()
    
    func fetchStory(ticker: String) -> AnyPublisher<StoryDataResult, Error> {
        StoryEndpoint
            .story(ticker: ticker)
            .execute(refresh: true)
            .eraseToAnyPublisher()
    }
    
}
